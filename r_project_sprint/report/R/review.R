library(dplyr)
library(forcats)
library(ggplot2)
library(here)
library(readr)
library(tidyr)
library(viridis)

dark_text <- "#2e2e2f"
mid_text <-  "#4d4e4f"
light_text <- "#747576"
pale_text <- "#ebebeb"

here::i_am("r_project_sprint/report/R/review.R")
dir <- "r_project_sprint/report/"

review1 <- read_csv(here(dir, "data", "review.csv")) |>
    filter(Type != "Not taken up" & !Area %in% c("Weblate")) |>
    separate_longer_delim(`Status end sprint`, delim = ";") |>
    separate_wider_regex(`Status end sprint`,
                         patterns = c(" *", n = "[0-9]+", " ",
                                      Status = ".*"))

# simplify categories and total within area
review1 <- review1  |>
    mutate(Status = case_when(
        Status %in% c("closed duplicate", "closed fixed", "closed won't fix", "patch accepted") ~
            "closed",
        Status %in% c("new tests", "proposed patch") ~ "patch",
        Status %in% c("running tests", "wip") ~ "work in progress",
        .default = Status),
        Status = factor(Status, levels = rev(c("unstarted", "discussion", "roadmap",
                                               "work in progress", "patch",
                                               "closed")))) |>
    group_by(Area, Status) |>
    summarize(n = sum(as.numeric(n))) |> ungroup()

# read in and split out status counts
review2 <- read_csv(here(dir, "data", "review.csv")) |>
    filter(Type != "Not taken up" & !Area %in% c("Weblate")) |>
    separate_longer_delim(`Status two months`, delim = ";") |>
    separate_wider_regex(`Status two months`,
                         patterns = c(" *", n = "[0-9]+", " ",
                                      Status = ".*"))

# simplify categories and total within area
review2 <- review2  |>
    mutate(Status = case_when(
        Status %in% c("closed duplicate", "closed fixed", "closed fixed R Core", "closed won't fix",
                      "patch accepted", "patch added to CRAN packaged") ~
            "closed",
        Status %in% c("new tests", "proposed patch", "patch under review",
                      "proposed patches") ~ "patch",
        Status %in% c("running tests", "wip") ~ "work in progress",
        .default = Status),
        Status = factor(Status, levels = rev(c("unstarted", "discussion", "roadmap",
                                               "work in progress", "patch",
                                               "closed")))) |>
    group_by(Area, Status) |>
    summarize(n = sum(as.numeric(n))) |> ungroup()

review <- bind_rows("End of sprint" = review1,
                    "Two months after" = na.omit(review2),
                    .id = "Timepoint")

# vertical
review |>
    ggplot(aes(fill = Status, y = n, x = fct_infreq(Area, w = n))) +
    geom_col() +
    scale_fill_viridis(discrete = TRUE, option = "plasma", direction = -1) +
    scale_x_discrete(limits = rev) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    facet_grid(~ Timepoint) +
    theme_minimal(base_size = 12) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank())

ggsave("bug_review.pdf", path = here(dir, "figures"),
       device = cairo_pdf, width = 8, height = 3)
ggsave("bug_review.svg", path = here(dir, "figures"),
       device = svg, width = 8, height = 3)
