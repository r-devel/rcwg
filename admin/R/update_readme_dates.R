library(glue)
library(lubridate)
library(RcppBDT)

update_readme_dates <- function(id, # which number meeting to update? (1 or 2)
                                month, # month name in English
                                n, # will find n'th day name of the month
                                day, # day of the week name in English
                                time, # 24 hour clock, Europe/London time
                                year){
    day.name <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
                  "Saturday", "Sunday")
    # get the date for n'th day name of the month
    date <- getNthDayOfWeek(n, match(day, day.name),
                            match(month, month.name), year)
    # convert Europe/London time to UTC
    date <- as.POSIXct(paste(date, time), tz = "Europe/London")
    date <- with_tz(date, "UTC")
    # read in README
    md <- readLines("README.md")
    # update English meeting
    locale <- Sys.getlocale(category = "LC_TIME")
    on.exit(Sys.setlocale("LC_TIME", locale))
    Sys.setlocale("LC_TIME", "en_GB")
    pre <- grep("Next planned meeting(s):", md, fixed = TRUE)
    md[pre + id] <-
        glue(format(date, " - %A, %B %d, %Y, %H:%M-"),
             "{hour(date) + 1}", format(date, ":%M UTC "),
             "([find your local time](https://arewemeetingyet.com/UTC/",
             format(date, "%Y-%Om-%d/%H:%M/"),
             "R%20Contribution%20Working%20Group)).")
    # update Spanish meeting
    Sys.setlocale("LC_TIME", "es_ES")
    pre <- grep("Próximas reuniones planificadas:", md, fixed = TRUE)
    md[pre + id] <-
        glue(format(date, " - %A %d de %B de %Y, %H:%M-"),
             "{hour(date) + 1}", format(date, ":%M UTC "),
             "([encuentre su hora local](https://arewemeetingyet.com/UTC/",
             format(date, "%Y-%Om-%d/%H:%M/"),
             "Grupo%20de%20trabajo%20de%20contribución%20R)).")
    writeLines(md, "README.md")
}
