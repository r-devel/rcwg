library(conflicted)
library(lubridate)
library(hms)
library(glue)
conflicts_prefer(hms::hms)
conflicts_prefer(lubridate::hours)
source("admin/R/misc.R")

add_hours <- function(time, hours) substr(hms(hm(time) + hours(hours)), 1, 5)

office_hour_post <- function(month, day, time, #UTC
                             signup, zoom,
                             venue, templates, ask = TRUE){
    if (length(day) == 1) day <- c(day, day)
    # convert days to dates in UTC
    txt <- "{year(Sys.Date())}-{match(month, month.name)}-{day}"
    date <- as.POSIXct(paste(ymd(glue(txt)), time), tz = "UTC")
    weekday <- weekdays(date)
    # convert AMER time from UTC to PDT/PST
    amer <- with_tz(date[2], "US/Pacific")
    tz <- substr(capture.output(print(amer)), 26, 28)
    weekday[2] <- weekdays(amer)
    time[2] <- format(amer, "%H:%M")
    # make post
    social_post(region = c("EMEA/APAC", "AMER"),
                month = month, day = day, time = time,
                weekday = weekday, timezone = c("UTC", tz),
                signup = signup, zoom = zoom,
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
                            zulip = "zulip.txt",
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
