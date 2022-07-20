# devtools::install_github("forwards/certificate")
library(certificate)
library(dplyr)
library(googlesheets4)

wd <- file.path("collaboration_campfires", "certificates")

signature <- file.choose()

attendees <- read_sheet(readline(prompt = "Enter sheet URL:"))

attendees |>
    count(`Would you like to have a certificate of attendance?`)

attendees <- attendees |>
    filter(grepl("yes|maybe", tolower(`Would you like to have a certificate of attendance?`))) |>
    pull(`Name`)

workshop <- "Collaboration Campfire"
date <- as.Date("2022-05-24")
location <- "15:30-17:00 UTC, Online"

curriculum_title <- "How to Contribute to a Translation Team:"
curriculum <- normalizePath(file.path(wd, paste0("curriculum_", date, ".md")))

certifier <- "Heather Turner"
credentials <- "Session Leader"

dir <- file.path(wd, date)

create_workshop_certificates(attendees,
                             workshop, date, location,
                             curriculum, certifier, credentials,
                             organization = "R Contribution Working Group",
                             organization_url = "contributor.r-project.org/",
                             dir = dir,
                             title = "CERTIFICATE OF ATTENDANCE",
                             curriculum_title = curriculum_title,
                             signature = signature, signature_skip = -1.2,
                             logo = "R", papersize = "a4paper")

