library(conflicted)
library(lubridate)
library(hms)
library(glue)
library(rtoot)
conflicts_prefer(hms::hms)
# auth_setup() # choose user token and login as RContributors on Mastodon

add_hours <- function(time, hours) substr(hms(hm(time) + hours(hours)), 1, 5)

office_hour_toot <- function(region, month, day, time, #UTC
                             meetup, post){
    if (region == "AMER"){
        timezone <- "PDT"
        # convert UTC to PDT/PST
        date <- as.POSIXct(paste(ymd(glue("2000-{match(month, month.name)}-{day}")),
                                time), tz = "UTC")
        date <- with_tz(date, "US/Pacific")
        timezone <- substr(capture.output(print(date)), 26, 28)
        time <- format(date, "%H:%M")
    } else timezone <- "UTC"
    toot <- glue("📢 Contributor Office Hour ({region})\n",
         "📅 {month} {day}, {time} - {add_hours(time, 1)} {timezone}\n",
         "Join an online Office Hour to\n",
         " - discuss how to get started contributing to R\n",
         " - get help/feedback on contributions you are working on\n",
         " - look at open bugs/work on translations together\n",
         meetup)

    if (post) post_toot(status = toot)
    toot
}

# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly
month <- "May"
day <- 11
office_hour_toot("EMEA/APAC", month, day, "09:00",
                 "https://www.meetup.com/r-contributors/events/xwxrdtyfchbpb/",
                 post = FALSE)

office_hour_toot("AMER", month, day, "16:30",
                 "https://www.meetup.com/r-contributors/events/txxrdtyfchbpb/",
                 post = FALSE)
