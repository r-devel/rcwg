# from https://gist.github.com/MichaelChirico/020922ce3c392e9fc143e5663fd74de3

library(withr)
library(data.table)
script_wd <- "collaboration_campfires/translations"
r_dir <- "../../../r-svn"
setwd(script_wd)

## hashes of all commits in git repo
all_commits <- with_dir(r_dir, system('git log --pretty="format:%H %b"', intern=TRUE))
all_commits <- all_commits[nzchar(all_commits)]
hashes <- substr(grep("^[0-9a-f]{40} ", all_commits, value=TRUE), 1, 40)

## hash of latest checked out commit
trunk_hash <- head(hashes, 1L)

## commit where translations were introduced?
# grep("trunk@33000", all_commits, value = TRUE)
oldest_commit <- "34e784f86c1457eabd46a8ca4e40ca315cdbeb54"

## sample of 100 commits from current to oldest commit with translations
hash_idx_grid <- as.integer(seq(1L, match(oldest_commit, hashes), length.out = 100L))

for (idx in hash_idx_grid) {
    hash <- hashes[idx]
    writeLines(paste("Getting translation status for r-svn commit", hash))
    with_dir(r_dir, system(paste("git reset --quiet --hard", hash)))
    system(paste("Rscript get_r_translation_status_for_revision.R", hash, r_dir))
}

withr::with_dir(r_dir, system("git reset --quiet --hard upstream/master"))

commit_dates <- with_dir(r_dir, system('git log --date=short --pretty="format:%H %ad"', intern=TRUE))
commit_dates <- setDT(tstrsplit(commit_dates, " ", fixed = TRUE))
setnames(commit_dates, c("hash", "date"))

summaries = list.files(pattern = "^[0-9a-f]{40}\\.csv$")
translation_data <- rbindlist(lapply(setNames(nm = summaries), fread))
translation_data[commit_dates, on = c(git_commit = "hash"), date := as.IDate(i.date)]

setorder(translation_data, date, package, language, type)

file.remove(summaries)
fwrite(translation_data, sprintf("translation_summary_%s.csv", trunk_hash))

# this _should_ be impossible, and it's not common -- it mostly looks like it's
#   due to mismatch between the messages in the .pot & .po files. a more complete
#   approach would try and outer join the .pot & .po files but it may be a pain.
#   instead just eliminate those observations for now. we just want a quick summary.
translation_data = translation_data[n_untranslated >= 0]

translation_data[, n_messages := n_translated + n_untranslated]
translation_data[
    potools:::.potools$KNOWN_LANGUAGES,
    on = c(language = "code"),
    `:=`(language_name = i.full_name_eng, language_native = i.full_name_native)
]
# can be removed after potools#295
translation_data[
    language == "lt",
    `:=`(language_name = "Lithuanian", language_native = "lietuvių")
]
translation_data = translation_data[!is.na(language_name)]

translation_data[,
                 keyby = .(date, language_name),
                 .(
                     n_translated = sum(n_translated),
                     n_messages = sum(n_messages)
                 )
][,
  pct_translated := n_translated / n_messages
][,
  dcast(.SD, date ~ language_name, value.var = "pct_translated", fill = 0)
][, {
    y = 100 * as.matrix(.SD[, !'date'])
    matplot(date, y, lty = 1L, type = 'l')
}]

translation_data[,
                 keyby = .(date, package),
                 .(
                     n_translated = sum(n_translated),
                     n_messages = sum(n_messages)
                 )
][,
  pct_translated := n_translated / n_messages
][,
  dcast(.SD, date ~ package, value.var = "pct_translated", fill = 0)
][, {
    y = 100 * as.matrix(.SD[, !'date'])
    matplot(date, y, lty = 1L, type = 'l')
}]

par(mfrow = 1:2, mar = c(9.6, 4.1, 4.1, 2.1))
translation_data[
    date == max(date) & !grepl("English", language_name) & package == "base",
    keyby = .(language_native),
    .(
        n_translated = sum(n_translated),
        n_messages = sum(n_messages)
    )
][
    order(-n_translated),
    barplot(
        n_translated,
        names.arg = language_native, las = 2L,
        space = 0,
        col = 2:8,
        main = "State of r-devel translations\nbase",
        ylab = "# Translated messages"
    )
]

translation_data[
    date == max(date) & !grepl("English", language_name),
    keyby = .(language_native),
    .(
        n_translated = sum(n_translated),
        n_messages = sum(n_messages)
    )
][
    order(-n_translated),
    barplot(
        n_translated,
        names.arg = language_native, las = 2L,
        space = 0,
        col = 2:8,
        main = "State of r-devel translations\nbase + other default packages",
        ylab = "# Translated messages"
    )
]
