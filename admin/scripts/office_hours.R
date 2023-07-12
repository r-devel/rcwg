
# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: twitter, mastodon, slack, R weekly
# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly
EMEA <- "https://www.meetup.com/r-contributors/events/cjsfftyfckbrb/"
AMER <- "https://www.meetup.com/r-contributors/events/sjsfftyfckbrb/"
month <- "July"
day <- 13
office_hour_toot(month, day, c("09:00", "16:30"), # UTC times
                 c(EMEA, AMER),
                 venue = "slack",
                 templates = "admin/posts/office_hour",
                 ask = TRUE)

# LinkedIn event ----------------------------------------------------------

# WIP: currently very specific to my machine
# Setup for MacOS: https://rpubs.com/grahamplace/rseleniumonmac
# Using firefox with geckodriver

source("R/linkedin_event.R")

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("LinkedIn password")

linkedin_signin(page = "https://www.linkedin.com/company/64851099/admin/",
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


linkedin_createevent(image = normalizePath("admin/brooke-cagle-g1Kr4Ozfoac-unsplash.jpg"),
                     alttext = "Three people laughing together, as they sit around a table with laptops, notebooks and drinks.",
                     eventtype = "^External event link",
                     name = "R Contributor Office Hour (EMEA/APAC)",
                     tz = "(UTC+00:00) Coordinated Universal Time",
                     startday = 13,
                     starttime = "09:00",
                     #endday = 13,
                     endtime = "10:00",
                     eventlink = "https://www.meetup.com/r-contributors/events/cjsfftyfckbrb/")

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

linkedin_createevent(image = normalizePath("admin/brooke-cagle-g1Kr4Ozfoac-unsplash.jpg"),
                     alttext = "Three people laughing together, as they sit around a table with laptops, notebooks and drinks.",
                     eventtype = "^External event link",
                     name = "R Contributor Office Hour (AMER)",
                     tz = "(UTC-07:00) Pacific Time (US and Canada)",
                     startday = 13,
                     starttime = "09:30",
                     #endday = 13,
                     endtime = "10:30",
                     eventlink = "https://www.meetup.com/r-contributors/events/sjsfftyfckbrb/",
                     description = description,
                     postcontent = postcontent)

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))
