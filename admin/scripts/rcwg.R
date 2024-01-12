# Update meeting dates in README

source("admin/R/update_readme_dates.R")

# 15 Mar
# 16 Apr: clashes with EPSRC Research Fellows Day, maybe move to Wed 17 Apr?
# 17 May
# 11 Jun
# 19 Jul
# (20 Aug)
# 20 Sep

update_readme_dates(1, "January", 3, "Friday", "15:00", 2024)
update_readme_dates(2, "February", 3, "Tuesday", "19:30", 2024)

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")
source("admin/R/buffer_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: mastodon, slack and twitter (currently all same content)
# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly

month <- "January"
day <- 19
time <- "15:00"
weekday <- get_weekday(day, month, abbreviate = TRUE)
agenda = c(
"- Activities at useR! 2024
- R Dev Days at useR!/posit::conf
- Ideas for Google Summer of Code/Season of Docs"
)
post <- social_post(weekday = weekday,
                    day = day,
                    month = month,
                    time = time,
                    agenda = agenda,
                    venue = "mastodon",
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
                  day = NULL,
                  month = NULL,
                  time = "15:00",
                  postcontent = post)

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))


# Gmail + Zoom ------------------------------------------------------

page <- "https://calendar.google.com"
