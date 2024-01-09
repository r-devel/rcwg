library(conflicted)
library(lubridate)
library(hms)
library(glue)
library(rtoot)
conflicts_prefer(hms::hms)
conflicts_prefer(lubridate::hours)
source("admin/R/misc.R")

add_hours <- function(time, hours) substr(hms(hm(time) + hours(hours)), 1, 5)

office_hour_post <- function(month, day, time, #UTC
                             meetup, zoom,
                             venue, templates, ask = TRUE){
    # convert AMER time from UTC to PDT/PST
    date <- as.POSIXct(paste(ymd(glue("2000-{match(month, month.name)}-{day}")),
                             time[2]), tz = "UTC")
    date <- with_tz(date, "US/Pacific")
    tz <- substr(capture.output(print(date)), 26, 28)
    time[2] <- format(date, "%H:%M")
    # make post
    social_post(region = c("EMEA/APAC", "AMER"),
                month = month, day = day, time = time,
                date = date, timezone = c("UTC", tz),
                meetup = meetup, zoom = zoom,
                venue = venue, templates = templates,
                ask = ask)
}


social_post <- function(...,
                        venue = c("mastodon", "twitter", "slack",
                                  "email", "rweekly"),
                        templates,
                        ask = TRUE){
    args <- list(...)
    template_file <- switch(venue,
                            mastodon = "toot.txt",
                            twitter = "toot.txt",
                            slack = "slack.txt",
                            email = "email.txt",
                            rweekly = "rweekly.txt",
                            "none")
    if (template_file == "none")
        stop("`venue` not recognized.",
             "Should be one of ", paste(venue, collapse = ", "))
    template_file <- file.path(templates, template_file)
    post_template <- readChar(template_file, file.info(template_file)$size)
    post <- glue_data(args, post_template)
    cat(post, sep = "\n\n")
    post
}
