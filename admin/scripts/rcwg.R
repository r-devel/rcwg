# Update meeting dates in README

source("admin/R/update_readme_dates.R")

### Usual times
# 3rd Fri 15:00 UK
# 3rd Tue 19:30 UK

### 2026 dates

# Jan 28 20:00 UTC
# Feb 20 19:30 UTC
# Mar 20 15:00 UTC

month <- "January"
day <- 28
time <- "20:00" # UTC !!
zoom <- "https://us02web.zoom.us/j/83792625860?pwd=yYHf1VHqBVxM9luqOYQ7ACIma2dlBJ.1"

# times here are UK times!
# second number is n'th 'day' of the month, e.g. `3, "Friday"` = 3rd Friday
# !! Think I have inconsistency here: Slack message and Twitter/Mastodon were wrong last time
update_readme_dates(1, "January", 4, "Wednesday", "20:00", 2026)
update_readme_dates(2, "February", 3, "Tuesday", "19:30", 2026)

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
## - turn off option for people to see full guest list
## - add unsubscribe notice
You are being invited as a subscriber to the R-Contribution-WG mailing list, please visit
https://stat.ethz.ch/mailman/listinfo/r-contribution-wg if you wish to unsubscribe.
## - add specific agenda items to Google calendar invite (RCWG calendar)

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")
source("admin/R/buffer_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# slack announcement
weekday <- get_weekday(day, month, abbreviate = TRUE)
agenda = c(
" - Draft community playbook
 - R Dev Days 2026"
)

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
                  time = time, # UTC
                  venue = "mastodon",
                  postcontent = post)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))

