# Update meeting dates in README

source("admin/R/update_readme_dates.R")

update_readme_dates(1, "October", 3, "Tuesday", "19:30", 2023)
update_readme_dates(2, "November", 3, "Friday", "15:00", 2023)

# Social media posts ------------------------------------------------------

source("admin/R/social_post.R")

# auth_setup() # choose user token and login as RContributors on Mastodon

# venues: mastodon, slack and twitter (currently all same content)
# copy and paste output to Twitter
# - cut and re-paste meetup link to display card properly

month <- "September"
day <- 15
time <- "14:00"
weekday <- get_weekday(day, month, abbreviate = TRUE)
agenda = c(
"- Review of R Project Sprint 2023
- Follow-on work/keeping up the momentum
- Updates on GSoC projects"
)
social_post(weekday = weekday,
            day = day,
            month = month,
            time = "14:00",
            agenda = agenda,
            venue = "mastodon",
            templates = "admin/posts/rcwg",
            ask = TRUE)
