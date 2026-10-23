library(dplyr)
library(forcats)
library(ggplot2)
library(readr)
library(tidyr)
library(viridis)

dark_text <- "#2e2e2f"
mid_text <-  "#4d4e4f"
light_text <- "#747576"
pale_text <- "#ebebeb"

dir <- "r_project_sprint/2026"
issues <- read_csv(file.path(dir, "data", "issue_status.csv"))

# status at the end of the sprint
status1 <- issues |>
    filter({!`Status end sprint` %in% c("Superseded", "Unstarted") &
            !Area %in% c("CRAN", "CRAN support",
                         "Contributor infrastructure",
                         "Translation infrastructure")}) |>
    rename(Status = `Status end sprint`)

# simplify categories and total within area
status1 <- status1 |>
    mutate(Status = case_when(
        Status %in% c("Closed - Fixed", "Closed - Done", "Closed - Other") ~
            "closed",
        Status %in% c("Patch Developed", "Patch Submitted", "Patch Tested") ~ "patch",
        Status %in% c("Work in progress") ~ "work in progress",
        Status %in% c("Proposal", "Roadmap") ~ "proposal",
        Status %in% c("Inconclusive", "Discussion") ~ "discussion",
        .default = Status),
        Status = factor(Status, levels = rev(c("discussion", "proposal",
                                               "work in progress", "patch",
                                               "closed")))) |>
    group_by(Area, Status) |>
    count()

# same again for two months later
status2 <- issues |>
    filter({!`Status end sprint` %in% c("Superseded", "Unstarted") &
            !Area %in% c("CRAN", "CRAN support",
                         "Contributor infrastructure",
                         "Translation infrastructure")}) |>
    rename(Status = `Status two months after`)

# simplify categories and total within area
status2 <- status2 |>
    mutate(Status = case_when(
        Status %in% c("Closed - Fixed", "Closed - Done", "Closed - Other") ~
            "closed",
        Status %in% c("Patch Developed", "Patch Submitted", "Patch Tested") ~ "patch",
        Status %in% c("Work in progress") ~ "work in progress",
        Status %in% c("Proposal", "Roadmap") ~ "proposal",
        Status %in% c("Inconclusive", "Discussion") ~ "discussion",
        .default = Status),
        Status = factor(Status, levels = rev(c("discussion", "proposal",
                                               "work in progress", "patch",
                                               "closed")))) |>
    group_by(Area, Status) |>
    count()

status <- bind_rows("End of sprint" = status1,
                    "Two months after" = na.omit(status2),
                    .id = "Timepoint")

# vertical
p <- status |>
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

ggsave("bug_review.svg", path = file.path(dir, "figures"),
       device = svg, width = 8, height = 3)

status1

# overall issues
issues |>
    filter(!`Status end sprint` %in% c("Superseded", "Unstarted")) |>
    mutate(group = case_when(
        startsWith(Area, "CRAN") ~ "CRAN",
        startsWith(Area, "Contributor") ~ "Contributor",
        startsWith(Area, "Translation") ~ "Translation",
        .default = "Base R"
    )) |>
    count(group)


