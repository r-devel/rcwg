# slack-analysis.R
# Analyse archived Slack channels to inform which ones to import into Zulip.

suppressPackageStartupMessages({
  library(tidyverse)
})

options(tibble.print_max = 50, tibble.print_min = 50)

# Read summary CSV
summary_path <- file.path("slack", "slack-summary.csv")
slack_summary <- read_csv(summary_path, show_col_types = FALSE) %>%
  mutate(
    # Work entirely in character space, then convert to Date
    most_recent_date = as.character(most_recent_date),
    most_recent_date = if_else(
      most_recent_date == "",
      NA_character_,
      most_recent_date
    ),
    most_recent_date = as.Date(most_recent_date) #,
    #is_top_level = subdirectory == "(top-level)"
  )

# Basic overview
print("=== Slack channel summary ===")
print(glimpse(slack_summary))

# Channels ordered by recency
recent_channels <- slack_summary %>%
  arrange(desc(most_recent_date))

print("=== Channels ordered by most recent activity ===")
print(recent_channels)

# Channels ordered by volume (json_count)
active_channels <- slack_summary %>%
  arrange(desc(json_count))

print("=== Channels ordered by message volume (json_count) ===")
print(active_channels)

# Heuristic for import-worthiness:
# - Exclude top-level aggregate row
# - Prefer channels with recent activity (e.g. within last 2 years)
# - And/or high volume

cutoff_date <- as.Date("2024-01-01")
min_messages <- 30

import_candidates <- slack_summary %>%
  # filter(!is_top_level) %>%
  mutate(
    recent = !is.na(most_recent_date) & most_recent_date >= cutoff_date,
    high_volume = json_count >= min_messages
  ) %>%
  filter(recent | high_volume) %>%
  arrange(desc(recent), desc(high_volume), desc(most_recent_date))

print("=== Suggested channels to import into Zulip (heuristic) ===")
print(import_candidates)

# Channels *not* selected for import
anti_join(slack_summary, import_candidates)

print(
  "Analysis complete. Suggested import candidates written to slack/slack-import-candidates.csv"
)
