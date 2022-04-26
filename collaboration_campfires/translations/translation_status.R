# set location of r-svn repo and output dir
out_dir <- "collaboration_campfires/translations"
r_svn <- "../../r-svn"
src_lib <- file.path(r_svn, "src", "library")

# packages required
library(ISOcodes)
library(countrycode)
library(dplyr)
library(forcats)
library(ggplot2)
library(purrr)
library(readr)
library(tidyr)
library(utf8)
library(withr)

# git commit and date for reference
sha <- with_dir(r_svn, system("git rev-parse --short HEAD", intern = TRUE))
date <- with_dir(r_svn,
                 system("git show -s --date=format:%Y-%m-%d --format=%cd",
                        intern = TRUE))

# Identify packages with po files -----------------------------------------

po_dir <- dir(src_lib, pattern = "^[^.]*po$",
              include.dirs = TRUE, recursive = TRUE)
pkg <- sub("/po", "", po_dir)


# Determine translations present, per package -----------------------------

translations_present <- function(pkg) {
    tibble(package = pkg,
           po_file = dir(file.path(src_lib, pkg, "po"), pattern = ".po$"),
           po = sub(".po", "", po_file)) |>
        separate(po, c("component", "code"), "-", fill = "left") |>
        separate(code, c("code", "variant"), "_", fill = "right") |>
        replace_na(list(component = "C")) |>
        arrange(component, code, variant)
}

languages <- map_df(pkg, translations_present)

# add language
languages <- left_join(languages, ISO_639_2[c("Alpha_2", "Name")],
                       by = c(code = "Alpha_2")) |>
    rename(language = Name)

# add country for variant
languages <- languages |>
    mutate(country = countrycode(variant, "iso2c", "country.name"))

write_csv(languages,
          file.path(out_dir, paste0("languages_", sha, "_", date, ".csv")))


# Get metadata for po files -----------------------------------------------

get_metadata <- function(package, po_file) {
    txt <- readLines(file.path(src_lib, package, "po", po_file),
                     encoding = "UTF-8")
    R_id <- grep("Project-Id-Version:", txt)
    Bug_id <- grep("Report-Msgid-Bugs-To:", txt)
    POT_id <- grep("POT-Creation-Date:", txt)
    PO_id <- grep("PO-Revision-Date:", txt)
    trans_id <- grep("Last-Translator:", txt)
    team_id <- grep("Language-Team:", txt)

    gsub_value <- function(x) gsub("(.+[:] )([^\\]*)([\\].*)", "\\2", x)
    gsub_date <- function(x) gsub("(.+[:] )([^ \\]*)[ \\](.*)", "\\2", x)
    tibble(package = package,
           po_file = po_file,
           r_version = gsub("[^0-9.]", "", txt[R_id]),
           bug_reports = gsub_value(txt[Bug_id]),
           pot_creation_date = gsub_date(txt[POT_id]),
           po_revision_date = gsub_date(txt[PO_id]),
           last_translator = gsub_value(txt[trans_id]),
           team = gsub_value(txt[team_id]))
}

metadata <- pmap_df(languages[c("package", "po_file")], get_metadata)

write_csv(metadata,
          file.path(out_dir, paste0("metadata_", sha, "_", date, ".csv")))

# Categorise message status -----------------------------------------------

get_message_status <- function(package, po_file) {
    txt <- readLines(file.path(src_lib, package, "po", po_file),
                     encoding = "UTF-8")
    # get lines for untranslated and (potentially) translated strings
    msg_id <- grep("^msgid ", txt)[-1]
    msgstr_id <- grep('^msgstr( \\"|\\[0).*', txt)[-1]

    # split text into entries for each message
    new_entry <- which(txt == "")
    n_lines <- diff(c(0, new_entry, length(txt)))
    grp <- rep.int(x = seq(0, length(n_lines) - 1), times = n_lines)
    entries <- split(txt, grp)[-1]

    # ignore old messages
    old <- vapply(entries, any_grepl, logical(1), "#~")
    entries <- entries[!old]

    # fuzzy translations
    any_grepl <- function(x, pattern) any(grepl(pattern, x))
    fuzzy <- vapply(entries, any_grepl, logical(1), "^#,.*fuzzy.*")

    # translated messages
    translated <- grepl('\\".+\\"', txt[msgstr_id]) |
        grepl('\\".+\\"', txt[msgstr_id + 1])

    tibble(package = package,
           po_file = po_file,
           message = txt[msg_id],
           translated = translated,
           fuzzy = fuzzy)
}

message_status <- pmap_df(languages[c("package", "po_file")],
                          get_message_status)

write_csv(message_status,
          file.path(out_dir, paste0("message_status_", sha, "_", date, ".csv")))

# Example plot ------------------------------------------------------------

## barplot of translated messages, by language

plot_dat <- left_join(message_status, languages) |>
    mutate(dialect = ifelse(is.na(variant),
                            gsub("([^ ;]+).*", "\\1", language),
                            paste(language, variant, sep = "_")))

ggplot(filter(plot_dat, translated),
       aes(x = fct_infreq(dialect))) +
    geom_bar(stat = "count", fill = "steelblue") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
          legend.position = "none") +
    labs(x = NULL, y = "# translated messages",
         subtitle = "Translated messages in base and default packages")
