#!/usr/local/bin/Rscript

library(potools)
suppressPackageStartupMessages(library(data.table))

script_wd = setwd("~/github/r-svn")
GIT_COMMIT = if (interactive()) readline('git commit: ') else commandArgs(TRUE)
setwd('src/library')

get_po_messages <- potools:::get_po_messages
`%||%` <- stats:::`%||%`

translation_metadata <- list()

packages <- rownames(subset(file.info(list.files()), isdir))
for (package in packages) {
    po_dir <- file.path(package, 'po')
    if (!dir.exists(po_dir)) next

    old_wd <- setwd(po_dir)

    for (po_file in list.files()) {
        # ignore for simplicity
        if (grepl("rgui", tolower(po_file))) next
        po_messages <- tryCatch(get_po_messages(po_file), error = identity)
        if (inherits(po_messages, "error")) next
        if (endsWith(po_file, "po")) {
            language <- gsub("^R-|\\.po$", "", po_file)
            n_messages <- sum(with(
                po_messages,
                fuzzy == 0
                & (
                    (type == "singular" & nzchar(msgstr))
                    | (type == "plural" & vapply(msgstr_plural, function(s) any(nzchar(s)), NA))
                )
            ))
        } else {
            language <- "_"
            n_messages <- nrow(po_messages)
        }
        if (startsWith(po_file, "R-")) {
            translation_metadata[[package]][[language]][['R']] <- n_messages
        } else {
            translation_metadata[[package]][[language]][['C']] <- n_messages
        }
    }

    setwd(old_wd)
}

languages = setdiff(unique(unlist(lapply(translation_metadata, names))), "_")

translation_data <- CJ(git_commit = GIT_COMMIT, package = packages, language = languages, type = c("R", "C"))

for (PACKAGE in packages) {
    n_r_messages <- translation_metadata[[PACKAGE]][["_"]][["R"]] %||% 0L
    n_c_messages <- translation_metadata[[PACKAGE]][["_"]][["C"]] %||% 0L
    if (n_r_messages == 0L && n_c_messages == 0L) next
    for (LANGUAGE in languages) {
        R_TRANSLATED <- translation_metadata[[PACKAGE]][[LANGUAGE]][["R"]] %||% 0L
        C_TRANSLATED <- translation_metadata[[PACKAGE]][[LANGUAGE]][["C"]] %||% 0L
        translation_data[
            .(GIT_COMMIT, PACKAGE, LANGUAGE, c("R", "C")),
            `:=`(
                n_translated = c(R_TRANSLATED, C_TRANSLATED),
                n_untranslated = c(n_r_messages - R_TRANSLATED, n_c_messages - C_TRANSLATED)
            )
        ]
    }
}

translation_data <- translation_data[, if (!all(is.na(n_translated))) .SD, by = .(git_commit, package)]
setwd(script_wd)
fwrite(translation_data, paste0(GIT_COMMIT, ".csv"))
