# set location of r-svn repo and output dir
out_dir <- "collaboration_campfires/translations"
r_svn <- "../r-svn"
src_lib <- file.path(r_svn, "src", "library")

# packages required
library(ISOcodes)
library(dplyr)
library(purrr)
library(readr)
library(tidyr)
library(utf8)
library(withr)

# update SVN repo
with_dir(r_svn, system("git pull"))

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
        separate(code, c("code", "region"), "_", fill = "right") |>
        replace_na(list(component = "C")) |>
        arrange(component, code, region)
}

translations <- map_df(pkg, translations_present)

# convert ISO 639 code and region to (regional) language name
translations <- left_join(translations, ISO_639_2[c("Alpha_2", "Name")],
                       by = c(code = "Alpha_2")) |>
    rename(language = Name) |>
    mutate(language = gsub("([^;]+).*", "\\1", language),
           language = ifelse(is.na(region), language,
                             paste(language, region, sep = "_"))) |>
    select(-code, -region)

# add in sha and date
translations <- bind_cols(tibble(sha = sha, date = date),
                          translations)

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

    gsub_value <- function(x) gsub(".+[:] ([^\\]*)[\\].*", "\\1", x)
    gsub_date <- function(x) gsub(".+[:] ([^ \\]*)[ \\].*", "\\1", x)
    tibble(package = package,
           po_file = po_file,
           r_version = gsub("[^0-9.]", "", txt[R_id]),
           bug_reports = gsub_value(txt[Bug_id]),
           pot_creation_date = gsub_date(txt[POT_id]),
           po_revision_date = gsub_date(txt[PO_id]),
           last_translator = gsub_value(txt[trans_id]),
           team = gsub_value(txt[team_id]))
}

metadata <- pmap_df(translations[c("package", "po_file")], get_metadata)

## add in translations data (information from file name)
metadata <- left_join(translations, metadata)

write_csv(metadata, file.path(out_dir, paste0("metadata.csv")))

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
    any_grepl <- function(x, pattern) any(grepl(pattern, x))
    old <- vapply(entries, any_grepl, logical(1), "#~")
    entries <- entries[!old]

    # fuzzy translations
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

message_status <- pmap_df(translations[c("package", "po_file")],
                          get_message_status)

## add in translations data (information from file name)
message_status <- left_join(translations, message_status)

write_csv(message_status,
          file.path(out_dir, paste0("message_status.csv")))
