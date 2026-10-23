library(dplyr)
library(ggplot2)
library(readr)
library(rnaturalearth)

dir <- "r_project_sprint/2026"

# location ----------------------------------------------------------------

location <- read_csv(file.path(dir, "data", "location.csv"))

dat <- location |>
  mutate(Country = case_when(
    `Country of residence` == "United States" ~ "United States of America",
    .default = `Country of residence`
  )) |>
  count(Country)

my_world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
  select(-geometry) |>
  # filter(sovereignt != "Antarctica") |>
  rename("Country" = name)

my_world |>
  full_join(dat, by = "Country") |>
  ggplot() +
  geom_sf(aes(fill = n), linewidth = 0.1) +
  coord_sf(crs = "+proj=eqearth +wktext") +
  scale_fill_viridis_c(
    option = "C",
    trans = "log10",
    breaks = c(1, 2, 5, 10),
    na.value = "grey85"
  ) +
  theme_minimal(base_size = 18) +
  theme(
    panel.background = element_blank(),
    panel.grid = element_line(color = "#ebebeb"),
    legend.position = c(0.97, 0.95),
    legend.background = element_blank(),
    panel.border = element_blank(),
  )

# svg doesn't seem to work propoerly here
ggsave("participant_map.png",
  path = file.path(dir, "figures"), device = png,
  width = 10, height = 5
)

location |>
    count(Online)

location |>
  count(Region, `Country of residence`) |>
  arrange(Region, n)
