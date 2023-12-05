library(dplyr)
library(forcats)
library(ggplot2)
library(here)
library(readr)
library(tidyr)
library(viridis)

blue <- "#0d0888"
dark_text <- "#2e2e2f"
mid_text <-  "#4d4e4f"
light_text <- "#747576"
pale_text <- "#ebebeb"

here::i_am("r_project_sprint/report/R/experience.R")
dir <- "r_project_sprint/report/"

experience <- read_csv(here(dir, "data", "experience.csv"))

experience |>
    summarise(scoping = sum(!is.na(scoping)),
              bugs = sum(!is.na(bugs)),
              translation = sum(!is.na(translation)),
              documentation = sum(!is.na(documentation)))

activities <- list()
activities[["Scoping work (n = 12)"]] <- experience |>
    separate_longer_delim(scoping, delim = ",") |>
    transmute(activity = ifelse(scoping %in% c("null", "No"), NA, scoping)) |>
    drop_na()
activities[["Code (n = 23)"]] <- experience |>
    separate_longer_delim(bugs, delim = ",") |>
    transmute(activity = ifelse(bugs %in% c("null", "No", "Graphical User Interfaces"), NA, bugs)) |>
    drop_na()
activities[["Documentation (n = 13)"]] <- experience |>
    separate_longer_delim(documentation, delim = ",") |>
    transmute(activity = ifelse(documentation %in% c("null", "No", "Not involved in documentation work"), NA, documentation)) |>
    drop_na()
activities[["Translation (n = 12)"]] <- experience |>
    transmute(translation = sub("([^ ]*) [(]weblate, dashboards[)]", "\\1", translation),
           translation = sub("Developing translation guidelines/documentation",
                             "Developing translation documentation", translation)) |>
    separate_longer_delim(translation, delim = ",") |>
    transmute(activity = ifelse(translation %in% c("null", "No"), NA, translation)) |>
    drop_na()

activities2 <- do.call(bind_rows, c(activities, list(.id = "area"))) |>
    mutate(area = factor(area, levels = c("Code (n = 23)", "Documentation (n = 13)", "Translation (n = 12)", "Scoping work (n = 12)")),
           activity = factor(activity, levels =
                                 c("Project scoping", "Triaging bugs", "Developing a roadmap",
                                   "Bug analysis/issue discussion", "Creating a patch",
                                   "Bug fixing", "Developing improved/new functionality",
                                   "Optimizing/refactoring code", "Creating/running tests",
                                   "Reviewing a patch", "Message translation",
                                   "Developing translation documentation",
                                   "Developing translation infrastructure")))

# vertical
activities2 |>
    ggplot(aes(fill = area, group = area, x = activity)) +
    geom_bar(fill = blue, na.rm = TRUE) +
    scale_x_discrete(limits = rev, na.translate = FALSE) +
    scale_x_discrete(limits = rev, na.translate = FALSE) +
    labs(x = NULL, y = NULL) +
    guides(fill = "none") +
    coord_flip() +
    facet_wrap(~ area, scales = "free_y") +
    theme_minimal(base_size = 12) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank())

ggsave("sprint_activities.png", path = here(dir, "figures"), device = "png",
       dpi = 320, width = 8, height = 5)
ggsave("sprint_activities.pdf", path = here(dir, "figures"), device = cairo_pdf,
       width = 8, height = 5)
ggsave("sprint_activities.svg", path = here(dir, "figures"), device = svg,
       width = 8, height = 5)

experience |>
    summarise(firsts = sum(!is.na(firsts)),
              acitivities2 = sum(!is.na(activities2)))

firsts <- list()
firsts[["R Core interactions (n = 22)"]] <- experience |>
    separate_longer_delim(firsts, delim = ",") |>
    transmute(activity = firsts) |>
    drop_na()
firsts[["R contribution activities (n = 25)"]] <- experience |>
    separate_longer_delim(activities2, delim = ",") |>
    transmute(activity = activities2) |>
    drop_na()

firsts2 <- do.call(bind_rows, c(firsts, list(.id = "area"))) |>
    mutate(area = factor(area, levels = c("R Core interactions (n = 22)", "R contribution activities (n = 25)")),
           activity = factor(activity, levels =
                                 c("First time discussing a bug/issue with an R Core member (online/in person)",
                                   "First time having a patch reviewed by an R Core member (online/in person)",
                                   "First time making a comment on R’s Bugzilla",
                                   "First time posting a patch on R’s Bugzilla",
                                   "First time working on R code in base R",
                                   "First time working on C code in base R",
                                   "First time working on Rd files in base R",
                                   "First time creating a patch from the R sources",
                                   "First time building R from source in the GitHub Codespace",
                                   "First time building R from source on your own laptop",
                                   "First time adding/updating a translation on Weblate"),
                             labels =
                                 c("Discussing bug/issue with R Core member\n(online/in person)",
                                   "Having patch reviewed by R Core member\n(online/in person)",
                                   "Making a comment on R’s Bugzilla",
                                   "Posting a patch on R’s Bugzilla",
                                   "Working on R code in base R",
                                   "Working on C code in base R",
                                   "Working on Rd files in base R",
                                   "Creating a patch from the R sources",
                                   "Building R from source in GitHub Codespace",
                                   "Building R from source on own laptop",
                                   "Adding/updating a translation on Weblate")))

firsts2 |>
    ggplot(aes(group = area, x = fct_infreq(activity))) +
    geom_bar(fill = blue, na.rm = TRUE) +
    scale_x_discrete(limits = rev, na.translate = FALSE) +
    labs(x = NULL, y = NULL) +
    guides(fill = "none") +
    coord_flip() +
    facet_wrap(~ area, scales = "free_y") +
    theme_minimal(base_size = 14) +
    theme(axis.text.y = element_text(colour = mid_text, size = rel(1)),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank())

ggsave("first_activities.png", path = here(dir, "figures"), device = "png",
       dpi = 320, width = 11, height = 3)
ggsave("first_activities.svg", path = here(dir, "figures"), device = svg,
       width = 11, height = 3)
ggsave("first_activities.pdf", path = here(dir, "figures"), device = cairo_pdf,
       width = 11, height = 3)


sum(grepl("First time building R from source in the GitHub Codespace", experience$activities2) |
    grepl("First time building R from source on your own laptop", experience$activities2))

sum(grepl("First time working on R code in base R", experience$activities2) |
    grepl("First time working on C code in base R", experience$activities2)|
    grepl("First time working on Rd files in base R", experience$activities2))
