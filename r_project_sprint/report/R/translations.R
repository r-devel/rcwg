library(anytime)
library(dplyr)
library(forcats)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(tidyr)
library(readr)

unit_summary <- read_csv("unit_summary.csv")


Pre-processing - only leaves changes from R project (not recommended packages)

```{r}
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
```

Across languages

```{r languages}
col <- c(brewer.pal(4, "Greens")[-1], brewer.pal(4, "Oranges")[2:3], brewer.pal(4, "Blues"))
unit_summary |>
    ggplot(aes(fill = progress, x = fct_infreq(translation))) +
    geom_bar() +
    scale_fill_manual(values = col) +
    labs(x = NULL, y = NULL) +
    theme_minimal(base_size = 36) +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
          legend.title=element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

ggsave(here::here(dir, "figures", "translations.png"), width = 20, height = 11, units = "in", device = "png", dpi = 320)
