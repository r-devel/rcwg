# Update meeting dates in README

source("admin/R/update_readme_dates.R")

# 15 Nov
# 17 Dec

# N.B. Set up meetings till Dec 2024 but Friday ones (now July onwards)
# not yet "announced" by inviting mailing list to this series!!!

# times here are UK times!
# !! Think I have inconsistency here: Slack message and Twitter/Mastodon were wrong last time
update_readme_dates(1, "November", 3, "Friday", "15:00", 2024)
update_readme_dates(2, "August", 3, "Tuesday", "19:30", 2024)


# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")
source("admin/R/buffer_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# slack announcement
month <- "November"
day <- 15
time <- "15:00" # UTC !!
weekday <- get_weekday(day, month, abbreviate = TRUE)
agenda = c(
"- Preparation for R Dev Day @ LatinR
- Planned work on R Dev Guide
- Updates on regular activities"
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
                  day = 12,
                  month = NULL,
                  time = "15:00", #UTC
                  postcontent = post)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))
