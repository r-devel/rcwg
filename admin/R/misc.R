library(glue)
library(lubridate)

get_weekday <- function(day, month, year = NULL, abbreviate){
    if (is.null(year))
        year <- year(Sys.Date())
    weekdays(ymd(glue("{year}-{match(month, month.name)}-{day}")),
             abbreviate)
}
