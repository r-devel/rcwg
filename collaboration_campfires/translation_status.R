# set location of r-svn repo and output dir
out_dir <- "collaboration_campfires"
r_svn <- "../../r-svn"
src_lib <- file.path(r_svn, "src", "library")

# packages required
library(ISOcodes)
library(countrycode)
library(dplyr)
library(purrr)
library(readr)
library(tidyr)
library(utf8)


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

write_csv(languages, file.path(out_dir, "languages.csv"))


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
    tibble(package = pkg,
           po_file = po_file,
           r_version = gsub("[^0-9.]", "", txt[R_id]),
           bug_reports = gsub_value(txt[Bug_id]),
           pot_creation_date = gsub_date(txt[POT_id]),
           po_revision_date = gsub_date(txt[PO_id]),
           last_translator = gsub_value(txt[trans_id]),
           team = gsub_value(txt[team_id]))
}

metadata <- pmap_df(languages[c("package", "po_file")], get_metadata)

write_csv(metadata, file.path(out_dir, "metadat.csv"))
