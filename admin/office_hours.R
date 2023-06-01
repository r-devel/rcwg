library(conflicted)
library(lubridate)
library(hms)
library(glue)
library(rtoot)
conflicts_prefer(hms::hms)
# auth_setup() # choose user token and login as RContributors on Mastodon

add_hours <- function(time, hours) substr(hms(hm(time) + hours(hours)), 1, 5)

office_hour_toot <- function(month, day, time, #UTC
                             meetup, venue){
    # convert AMER time from UTC to PDT/PST
    date <- as.POSIXct(paste(ymd(glue("2000-{match(month, month.name)}-{day}")),
                             time[2]), tz = "UTC")
    date <- with_tz(date, "US/Pacific")
    tz <- substr(capture.output(print(date)), 26, 28)
    time[2] <- format(date, "%H:%M")
    # function to write toot/tweet
    make_toot <- function(region, month, day, time, timezone,
                          meetup){
        glue("📢 Contributor Office Hour ({region})\n",
             "📅 {month} {day}, {time} - {add_hours(time, 1)} {timezone}\n",
             "Join an online Office Hour to\n",
             " - discuss how to get started contributing to R\n",
             " - get help/feedback on contributions you are working on\n",
             " - look at open bugs/work on translations together\n",
             meetup)
    }

    if (venue %in% c("mastodon", "twitter")) {
        emea_apac_toot <- make_toot("EMEA/APAC", month, day, time[1], "UTC",
                                    meetup[1])
        amer_toot <- make_toot("AMER", month, day, time[2], tz, meetup[2])
        if (venue == "mastodon"){
            post_toot(status = emea_apac_toot)
            post_toot(status = amer_toot)
        }
        print(emea_apac_toot, amer_toot, sep = "\n\n")
    } else if (venue == "slack"){
        print(glue("📢 Contributor Office Hours, {weekdays(date)} {month} {day}\n\n",
                   "Join an online Office Hour to\n",
                   " - discuss how to get started contributing to R\n",
                   " - get help/feedback on contributions you are working on\n",
                   " - look at open bugs/work on translations together\n\n",
                   "EMEA/APAC, {time[1]}-{add_hours(time[1], 1)} UTC: {meetup[1]}\n",
                   "AMER, {time[2]}-{add_hours(time[1], 1)} {tz}: {meetup[2]}\n"))
    } else if (venue == "R weekly"){
        print(glue("R Contributor Office Hours, {weekdays(date)} {month} {day}: ",
                   "[Europe/Middle East/Asia-Pacific Hour]({meetup[1]}) or ",
                   "[Americas Hour]({meetup[2]})\n\n",
                   "Join an online Office Hour at the time that suits you to:\n",
                   " - discuss how to get started contributing to R\n",
                   " - get help/feedback on contributions you are working on\n",
                   " - look at open bugs/work on translations together"))
        browseURL("https://github.com/rweekly/rweekly.org/edit/gh-pages/draft.md")
    } else warning("venue misspelt, nothing done!")
}

# venues: Twitter, Mastodon, Slack, R Weekly
# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly
month <- "June"
day <- 8
office_hour_toot(month, day, c("09:00", "16:30"), # UTC times
                 c("https://www.meetup.com/r-contributors/events/cjsfftyfcjblb/",
                   "https://www.meetup.com/r-contributors/events/sjsfftyfcjblb/"),
                 venue = "R weekly")

