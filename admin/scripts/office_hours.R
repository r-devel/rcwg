# Data for next office hours ----------------------------------------------

# Apr 10
# May 8
# June 12
# July 10
# Aug 14
# Sep 11 - move to Sep 4, week before RSECon, note Gabe will be with me, possibly just do one?
# Oct 9


day <- 13
month <- "March"
emea <- "https://www.meetup.com/r-contributors/events/306322148/"
amer <- "https://www.meetup.com/r-contributors/events/305506314/"
emea_zoom <- "https://us02web.zoom.us/j/88093117300?pwd=bFlTWENoY2U2bW40SHFLcWxxTHp5Zz09"
amer_zoom <- "https://us02web.zoom.us/j/85668115902?pwd=Z0NtN3hMOGZmaU9EcWx1SWE2ZUwzUT09"

# ensure office hour annouced on meetup (see rcwg_tasks.md)

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: email, slack, R weekly
# use "office_hour" for main post,
# "office_hour_reminder" for twitter/mastodon/slack reminders
post <- office_hour_post(month, day, c("10:00", "17:30"), # UTC times
                         c(emea, amer), c(emea_zoom, amer_zoom),
                         venue = "slack",
                         templates = "admin/posts/office_hour")

# Email r-contribution-wg@r-project.org -----------------------------------

# Mastodon via Buffer ------------------------------------

# Also Bluesky by bridging. No longer post on Twitter.
# This could replaced by rtoot now, but won't schedule in advance

post <- office_hour_post(month, day, c("10:00", "17:30"), # UTC times
                         c(emea, amer), c(emea_zoom, amer_zoom),
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
buffer_createpost(browser = browser,
                  day = NULL, # day number of month, e.g. 10
                  month = NULL,
                  time = NULL, # 24 hour clock, e.g. "09:00"
                  postcontent = post[[1]],
                  venue = "mastodon")

buffer_createpost(browser = browser,
                  day = 7,
                  month = NULL,
                  time = "17:30",
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
                     name = "R Contributor Office Hour (EMEA/APAC)",
                     tz = "(UTC+00:00) Coordinated Universal Time",
                     startday = day,
                     startmonth = month,
                     starttime = "10:00", #UTC time
                     endtime = "11:00",
                     eventlink = emea,
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
                     startday = day,
                     startmonth = month,
                     starttime = "09:30",
                     endtime = "10:30",
                     eventlink = amer,
                     description = description,
                     postcontent = postcontent)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))


