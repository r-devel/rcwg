# Data for next office hours ----------------------------------------------

day <- 12
month <- "October"
emea <- "https://www.meetup.com/r-contributors/events/296272398/"
amer <- "https://www.meetup.com/r-contributors/events/296278616/"
emea_zoom <- "https://us02web.zoom.us/j/85095818373?pwd=d2xUalQ5bXA4a0JCRGxJUUNkYityUT09"
amer_zoom <- "https://us02web.zoom.us/j/85424493663?pwd=L3hjVGo2MW9TcVlsTVZUREEvYWVwUT09"

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: email, twitter, mastodon, slack, R weekly
# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly
# use "office_hour" for main post,
# "office_hour_reminder" for twitter/mastodon/slack reminders
office_hour_post(month, day, c("09:00", "16:30"), # UTC times
                 c(emea, amer), c(emea_zoom, amer_zoom),
                 venue = "email",
                 templates = "admin/posts/office_hour",
                 ask = TRUE)

# Email r-contribution-wg@r-project.org -----------------------------------

# can unsubscribe info be added to footer of each email?
# couldn't log in as admin just now

# LinkedIn event ----------------------------------------------------------

# WIP: currently very specific to my machine
# Setup for MacOS: https://rpubs.com/grahamplace/rseleniumonmac
# Using firefox with geckodriver

source("admin/R/linkedin_event.R")

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("LinkedIn password")

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
                     starttime = "09:00",
                     endtime = "10:00",
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
                     tz = "(UTC-07:00) Pacific Time (US and Canada)",
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
