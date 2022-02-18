# devtools::install_github("forwards/certificate")
library(certificate)

# Fake names generated via charlatan::ch_name
title <- "CERTIFICATE OF ATTENDANCE"

attendees <- c("Marnie Dickinson", "Dr. Marlin Wilderman")
action_text <- "participated in the"

workshop <- "Collaboration Campfire"
date <- as.Date("2022-02-22")
location <- "15:30-17:00 UTC, Online"

curriculum_title <- "Exploring R’s Bug-tracking Process:"
curriculum <- c(" - Introduction to R Contribution",
                " - The R Development Guide",
                " - Bug-tracking in R",
                " - Exploring R's Bugzilla")

certifier <- "Zaire Crooks"
credentials <- "Session Leader"
organization <- "R Contribution Working Group:"
organization_url <- "contributor.r-project.org/"

dir <- "certificates"

create_workshop_certificates(title, attendees, action_text,
                             workshop, date, location,
                             curriculum_title, curriculum, NULL,
                             certifier, credentials,
                             organization, organization_url,
                             logo = "R", papersize = "a4paper", dir = dir)

