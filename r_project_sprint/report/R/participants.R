library(dplyr)
library(forcats)
library(ggplot2)
library(here)
library(readr)

here::i_am("r_project_sprint/report/R/participants.R")
dir <- "r_project_sprint/report/"

# location ----------------------------------------------------------------

location <- read_csv(here(dir, "data", "location.csv"))

world_map <- map_data("world") %>%
    filter(region != "Antarctica")

dat <- location |>
    mutate(`Country of residence` = case_when(
        `Country of residence` == "United States of America" ~ "USA",
        `Country of residence` == "United Kingdom" ~ "UK",
        `Country of residence` == "Russian Federation" ~ "Russia",
        .default = `Country of residence`)
    ) |>
    count(`Country of residence`) |>
    full_join(world_map, by = c("Country of residence" = "region"))

ggplot(dat, aes(long, lat, group = group))+
    geom_polygon(aes(fill = n ), color = NA)+
    scale_fill_viridis_c(option = "C") +
    theme_void()

ggsave("participant_map.png", path = here(dir, "figures"), device = "png",
       dpi = 320, width = 14)

location |>
    count(Online)

# skills ------------------------------------------------------------------

blue <- "#0d0888"
dark_text <- "#2e2e2f"
mid_text <-  "#4d4e4f"
light_text <- "#747576"
pale_text <- "#ebebeb"

contributor_level <- read_csv(here(dir, "data", "contributor_level.csv"))

contributor_level |>
    mutate(`Contributor class` =
               factor(`Contributor class`,
                      c("R-core", "Advanced", "Intermediate", "Beginner"),
                      c("R Core", "Advanced", "Intermediate", "Novice"))) |>
    ggplot(aes(x = `Contributor class`, y = n)) +
           geom_col(fill = blue) +
    labs(title = 'Contributor level', x = NULL, y = NULL) +
    theme_minimal(base_size = 14) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

ggsave("contributor_level.png", path = here(dir, "figures"), device = "png",
       dpi = 320, width = 5, height = 3)

translator_level <- read_csv(here(dir, "data", "translator_level.csv"))

translator_level |>
    mutate(`Translator class` = ifelse(is.na(`Translator class`), "R Core",
                                       `Translator class`),
           `Translator class` =
               factor(`Translator class`,
                      c("R Core", "Translator", "Possible", "No evidence"))) |>
    ggplot(aes(x = `Translator class`, y = n)) +
    geom_col(fill = blue) +
    labs(title = 'Translator potential', x = NULL, y = NULL) +
    theme_minimal(base_size = 14) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

ggsave("translator_level.png", path = here(dir, "figures"), device = "png",
       dpi = 320, width = 5, height = 3)


