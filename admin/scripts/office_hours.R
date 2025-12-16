# Data for next office hours ----------------------------------------------

# UTC times
# Thurs Dec 11 10am, 8pm (EMEA UK Thurs 10am | AMER PDT: 12pm, UK: 8pm, Auckland: Fri Dec 12 9am)
# Fri Dec 12 02:00am (APAC UTC 2:00 am, IST 7:30am, Jakarta 09:00am, Auckland: 3:00pm)

# January: back to winter times?

day <- c(11, 11, 12) # day number
month <- "December"

meetup <- c(emea = "https://www.meetup.com/r-contributors/events/311344152/",
            amer = "https://www.meetup.com/r-contributors/events/311344204/",
            apac = "https://www.meetup.com/r-contributors/events/311344211/")

zoom <- c(emea = "https://us02web.zoom.us/j/82709474418?pwd=LSoxPzjbCKfZ4Dzqw3EVAGwPFqN43R.1",
          amer = "https://us02web.zoom.us/j/89905390972?pwd=PQYglr5EKLUfIuhflLX4bxHIibM6RI.1",
          apac = "https://us02web.zoom.us/j/89168945557?pwd=ea8BgaXNAZpiRyQjhNKZyZSBNDFS5j.1")

utc_times <- c("10:00", "20:00", "02:00")

## will need to adapt functions for separate EMEA/APAC meetings!

# Ensure office hour announced on meetup (see rcwg_tasks.md) --------------

# Send calendar invite to r-contribution-wg@r-project.org contacts --------

## Send for this event only:

source("admin/R/r_contribution_wg_subscribers.R")

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
# stick with standalone sever from http://selenium-release.storage.googleapis.com/index.html
# if issues, reinstall geckodriver (and Java?)
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("R-contribution-wg password") # opens dialog to enter password

# get subscribers to email list
rcwg_subscribers(browser = browser,
                 page = "https://stat.ethz.ch/mailman/listinfo/r-contribution-wg",
                 username = "ht@heatherturner.net",
                 key = "R-contribution-wg password")

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))

## - copy list of current subscribers, add to guest list on Google calendar event
## (use one on Office Hours Calendar, so it shows as this when email)
## (paste and enter for comma-separated list to be added in bulk)
## - turn off option for people to see full guest list
## - add note about why they are being sent calendar invite and how to unsubscribe

You are being invited as a subscriber to the R-Contribution-WG mailing list, please visit
https://stat.ethz.ch/mailman/listinfo/r-contribution-wg if you wish to unsubscribe.

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: (email), slack, (R weekly - if know R core member coming)
# use "office_hour" for main post,
# "office_hour_reminder" for mastodon/slack reminders
post <- office_hour_post(month, day, utc_times,
                         meetup, zoom,
                         venue = "rweekly",
                         templates = "admin/posts/office_hour")

# Mastodon via Buffer ------------------------------------

# Also Bluesky by bridging. No longer post on Twitter.
# This could replaced by rtoot now, but won't schedule in advance

post <- office_hour_post(month, day[3], utc_times[3],
                         meetup[3], zoom[3],
                         venue = "mastodon",
                         templates = "admin/posts/office_hour")

source("admin/R/buffer_post.R")

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
# stick with standalone sever from http://selenium-release.storage.googleapis.com/index.html
# if issues, reinstall geckodriver (and Java?)
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("Buffer password") # opens dialog to enter password

buffer_signin(browser = browser,
              page = "https://login.buffer.com/login",
              username = "heather@r-project.org",
              key = "Buffer password")

# note posting day will usually be different from event day!
# If NULL, will post this day, this month, next hour (UTC times)
# must be on Publish tab
buffer_createpost(browser = browser,
                  day = NULL, # day number of month, e.g. 10
                  month = NULL,
                  time = NULL, # 24 hour clock, e.g. "09:00"
                  postcontent = post[[1]],
                  venue = "mastodon")

buffer_createpost(browser = browser,
                  day = NULL,
                  month = NULL,
                  time = "16:30",
                  postcontent = post[[2]],
                  venue = "mastodon")

browser$close()

# LinkedIn event ----------------------------------------------------------

# WIP: currently very specific to my machine
# Setup for MacOS: https://rpubs.com/grahamplace/rseleniumonmac
# Using firefox with geckodriver

source("admin/R/linkedin_event.R")

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
# stick with standalone sever from http://selenium-release.storage.googleapis.com/index.html
# if issues, reinstall geckodriver (and Java?)
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("LinkedIn password") # opens dialog to enter password

linkedin_signin(browser = browser,
                page = "https://www.linkedin.com/company/64851099/admin/",
                username = "ht@heatherturner.net",
                key = "LinkedIn password")

description <- "Join the #RStats Europe, Middle East, Asia and Asia-Pacific Office Hour to
- discuss how to get started contributing to R
- get help/feedback on contributions you are working on
- look at open bugs/work on message translations together
"

postcontent <- list(
    "Join the #RStats Europe, Middle East, Asia and Asia-Pacific Office Hour to",
    key = "enter", "- discuss how to get started contributing to R",
    key = "enter", "- get help/feedback on contributions you are working on",
    key = "enter", "- look at open bugs/work on message translations together")


linkedin_createevent(browser = browser,
                     image = normalizePath("admin/brooke-cagle-g1Kr4Ozfoac-unsplash.jpg"),
                     alttext = "Three people laughing together, as they sit around a table with laptops, notebooks and drinks.",
                     eventtype = "^External event link",
                     name = "R Contributor Office Hour (EMEA)",
                     tz = "(UTC+00:00) Coordinated Universal Time",
                     startday = day[1],
                     startmonth = month,
                     starttime = "10:00", #UTC time
                     endtime = "11:00",
                     eventlink = meetup["emea"],
                     description = description,
                     postcontent = postcontent)

description <- "Join the #RStats Americas Office Hour to
- discuss how to get started contributing to R
- get help/feedback on contributions you are working on
- look at open bugs/work on message translations together
"

postcontent <- list(
    "Join the #RStats Americas Office Hour to",
    key = "enter", "- discuss how to get started contributing to R",
    key = "enter", "- get help/feedback on contributions you are working on",
    key = "enter", "- look at open bugs/work on message translations together")

linkedin_createevent(browser = browser,
                     image = normalizePath("admin/brooke-cagle-g1Kr4Ozfoac-unsplash.jpg"),
                     alttext = "Three people laughing together, as they sit around a table with laptops, notebooks and drinks.",
                     eventtype = "^External event link",
                     name = "R Contributor Office Hour (AMER)",
                     #tz = "(UTC-07:00) Pacific Time (US and Canada)", # during summer
                     tz = "(UTC-08:00) Pacific Time (US and Canada), Tijuana",
                     startday = day[2],
                     startmonth = month,
                     starttime = "12:00",
                     endtime = "13:00",
                     eventlink = meetup["amer"],
                     description = description,
                     postcontent = postcontent)

description <- "Join the #RStats Asia-Pacific Office Hour to
- discuss how to get started contributing to R
- get help/feedback on contributions you are working on
- look at open bugs/work on message translations together
"

postcontent <- list(
    "Join the #RStats Asia-Pacific Office Hour to",
    key = "enter", "- discuss how to get started contributing to R",
    key = "enter", "- get help/feedback on contributions you are working on",
    key = "enter", "- look at open bugs/work on message translations together")

linkedin_createevent(browser = browser,
                     image = normalizePath("admin/brooke-cagle-g1Kr4Ozfoac-unsplash.jpg"),
                     alttext = "Three people laughing together, as they sit around a table with laptops, notebooks and drinks.",
                     eventtype = "^External event link",
                     name = "R Contributor Office Hour (APAC)",
                     tz = "(UTC-08:00) Pacific Time (US and Canada), Tijuana",
                     startday = day[3],
                     startmonth = month,
                     starttime = "15:00",
                     endtime = "16:00",
                     eventlink = meetup["apac"],
                     description = description,
                     postcontent = postcontent)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))


