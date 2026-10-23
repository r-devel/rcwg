library(dplyr)
library(ggplot2)
library(readr)

dir <- "r_project_sprint/2026"

# skills ------------------------------------------------------------------

blue <- "#0d0888"
dark_text <- "#2e2e2f"
mid_text <-  "#4d4e4f"
light_text <- "#747576"
pale_text <- "#ebebeb"

contributor_level <- read_csv(file.path(dir, "data", "contributor_level.csv"))

contributor_level |>
    mutate(`Contributor class` =
               factor(`Contributor class`,
                      c("R Core", "Advanced", "Intermediate", "Novice", "Beginner"))) |>
    ggplot(aes(x = `Contributor class`, y = n)) +
           geom_col(fill = blue) +
    labs(title = 'Contributor level', x = NULL, y = NULL) +
    theme_minimal(base_size = 18) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

ggsave("contributor_level.svg", path = file.path(dir, "figures"), device = svg,
       width = 10, height = 5)


