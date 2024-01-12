library(RSelenium)

buffer_signin <- function(browser, page, username, key = "Buffer password"){
    browser$navigate(page)

    # cookie control
    #elem <- browser$findElement(using = 'id', "cky-btn-reject")
    #elem$clickElement()

    # sign in
    # keyring::key_set("Buffer password")
    elem <- browser$findElement(using = 'id', "email")
    elem$sendKeysToElement(list(username))
    elem <- browser$findElement(using = 'id', "password")
    elem$sendKeysToElement(list(keyring::key_get(key)))
    elem <- browser$findElement(using = 'id', "login-form-submit")
    elem$clickElement()

    # team plan promotion
    elem <- browser$findElement(using = 'css', "[aria-label='Close']")
    elem$clickElement()
}

buffer_createpost <- function(
        browser,
        day = NULL, month = NULL, time = NULL,
        postcontent){

    if (is.null(day)) day <- format(Sys.Date(), "%d")
    if (is.null(month)) month <- format(Sys.Date(), "%m")
    if (is.null(time)) time <- format(Sys.time() + 60*60, "%H:00")

    #browser$navigate("https://publish.buffer.com/calendar/week")
    #Sys.sleep(2) # pause for page to load

    elem <- browser$findElement(using = 'xpath',
                                "//div[text()='Create Post']")
    elem$clickElement()
    Sys.sleep(2) # pause for dialog to load

    # select outlets
    # all (mastodon, twitter and linked-in page) pre-selected by default

    #elem <- browser$findElement(using = 'name',
    #                            "mastodon-profile-button")
    #elem$clickElement()

    #elem <- browser$findElement(using = 'name',
    #                            "twitter-profile-button")
    #elem$clickElement()

    elem <- browser$findElement(using = 'name',
                                "linkedin-profile-button")
    elem$clickElement()

    elem <- browser$findElement(using = 'xpath',
                                "//div[@role='textbox']")

    sendChar(elem, postcontent)

    elem <- browser$findElement(using = 'xpath',
                                "//button[text()='Customize for each network']")
    elem$clickElement()

    # fragile - clicking on drop down arrow
    elem <- browser$findElements(using = 'xpath',
                                "//div[@role='button']")
    elem[[3]]$clickElement()

    elem <- browser$findElement(using = "id", "SCHEDULE_POST")
    elem$clickElement()

    # select dates and times
    ## TODO: work on add month
    #addmonth <- match(startmonth, month.name) -
    #    match(format(Sys.Date(), "%B"), month.name)
    addmonth <- 0
    selectDate(day, addmonth)
    selectTime(time)

    elem <- browser$findElement(using = 'xpath',
                                "//div[text()='Schedule']")
    elem$clickElement()
}

sendChar <- function(elem, text){
    text <- as.list(strsplit(text, "")[[1]])
    for (i in seq_along(text)){
        # emojis stop working if use new line
        if (text[i] == "\n") {
            elem$sendKeysToElement(list(key = "enter"))
            next
        }
        elem$sendKeysToElement(text[i])
    }
}

selectDate <- function(daynum = 1, addmonth = 0){
    # TODO: move to correct month

    # pick day
    xpath <- paste0("//div[text()='", as.numeric(daynum), "']")
    elem <- browser$findElement(using = 'xpath', xpath)
    elem$clickElement()
}

selectTime <- function(time = "9:30"){
    # convert time to date to be able to use formatting (Europe/London)
    date <- as.POSIXct(paste(Sys.Date(), time), tz = "UTC")
    date <- lubridate::with_tz(date, "Europe/London")

    hour <- paste0("//option[text()='", format(date, "%I"), "']")
    elem <- browser$findElements(using = "xpath", hour)[[1]]
    elem$clickElement()

    # small fudge: works as long as min not valid hour (1:12)
    min <- paste0("//option[text()='", format(date, "%M"), "']")
    elem <- browser$findElement(using = "xpath", min)
    elem$clickElement()

    am_pm <- paste0("//option[text()='", format(date, "%p"), "']")
    elem <- browser$findElement(using = "xpath", am_pm)
    elem$clickElement()
}


