library(dplyr)
library(ggplot2)
library(readr)
library(viridis)

here::i_am("r_project_sprint/report/R/translations.R")
dir <- "r_project_sprint/report"

unit_summary <- read_csv(here::here(dir, "data", "unit_summary.csv"))

# Pre-processing - only leaves changes from R project (not recommended packages)

progress_lev <- c("approved", "updated translation, approved", "new translation, approved",
                  "updated translation", "new translation", "marked for edit",
                  "suggestion for updated translation", "suggestion for new translation",
                  "translation deleted")
translation_lev <- c("Arabic", "Bengali", "Catalan", "Danish", "German", "English",
                     "English_GB", "Spanish", "Persian", "French", "Hindi", "Hungarian",
                     "Indonesian", "Italian", "Japanese", "Korean", "Lithuanian", "Nepali",
                     "Dutch", "Norwegian Norsk", "Polish", "Portuguese_BR", "Russian",
                     "Albanian", "Turkish", "ignore", "Urdu", "Chinese_CN", "Chinese_TW")
unit_summary <- unit_summary |>
    mutate(translation = factor(translation, labels = translation_lev)) |>
    filter(!progress %in% c("external update", "no change overall",
                            "translation uploaded")) |>
    mutate(progress = factor(progress, progress_lev))

# plot changes across languages

pal <- viridis_pal(option = "C")(4)

col <- c("#7f7f7f",
         colorRampPalette(c(pal[1], "white"))(4)[-4],
         colorRampPalette(c(pal[2], "white"))(3)[-3],
         colorRampPalette(c(pal[3:4], "yellow"))(4)[-4])

unit_summary |>
    ggplot(aes(fill = progress, x = fct_infreq(translation))) +
    geom_bar() +
    scale_fill_manual(values = rev(col)) +
    labs(x = NULL, y = NULL) +
    theme_minimal(base_size = 36) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
          legend.title=element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

ggsave(here::here(dir, "figures", "translations.svg"), width = 20, height = 11, units = "in", device = svg)
ggsave(here::here(dir, "figures", "translations.pdf"), width = 20, height = 11, units = "in", device = cairo_pdf)
