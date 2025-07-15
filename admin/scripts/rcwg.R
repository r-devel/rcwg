# Update meeting dates in README

source("admin/R/update_readme_dates.R")

### 2025 dates
# Fri 15:00 UK
# Jul 18, Sep 26 (moved from Sep 19 due to posit::conf),
# Nov 21 (May need to change time to AU/UK friendlyish time)
#
# Tues 19:30 UK:
# Jun 17, Aug 19 (may skip, but see who signs up),
# Oct 21, (May need to change time to AU/US friendlyish time)
# Dec 16, (May need to change time to NZ/US friendlyish time)

# times here are UK times!
# second number is n'th 'day' of the month, e.g. `3, "Friday"` = 3rd Friday
# !! Think I have inconsistency here: Slack message and Twitter/Mastodon were wrong last time
update_readme_dates(1, "July", 3, "Friday", "15:00", 2025)
update_readme_dates(2, "August", 3, "Tuesday", "19:30", 2025)


# Update RCWG contacts ---------------------------------------------------------

## RCWG have been sent invite to recurring meeting
## - maybe send from something other than work outlook so don't get links expanded

## Send update to contacts for this event only:

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
## (use one on R Contribution Working Group Calendar, so it shows as this when email)
## (paste and enter for comma-separated list to be added in bulk)
## - add specific agenda items to Google calendar invite (RCWG calendar)

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")
source("admin/R/buffer_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# slack announcement
month <- "July"
day <- 18
time <- "14:00" # UTC !!
weekday <- get_weekday(day, month, abbreviate = TRUE)
agenda = c(
"  - Updates on Google Summer of Code projects
 - Plans for R Dev Days
 - News from Office Hours"
)
zoom <- "https://us02web.zoom.us/j/83915338079?pwd=247q7Xbbpa7ZqlQ0bsDVUIFSyzcBWB.1"
post <- social_post(weekday = weekday,
                    day = day,
                    month = month,
                    time = time,
                    agenda = agenda,
                    venue = "mastodon", # "slack"/"mastodon"
                    templates = "admin/posts/rcwg",
                    ask = TRUE)

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

# note posting day different from event day!
# If NULL, will post this day, this month, next hour
buffer_createpost(browser = browser,
                  day = NULL, # number, day of month
                  month = NULL, # month number
                  time = NULL, # UTC
                  venue = "mastodon",
                  postcontent = post)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))
