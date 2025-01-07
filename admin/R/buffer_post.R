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
    Sys.sleep(1) # pause for pop-up to load
    elem <- browser$findElement(using = 'css', "[aria-label='Close']")
    elem$clickElement()
}

buffer_createpost <- function(
        browser,
        day = NULL, month = NULL, time = NULL,
        postcontent,
        venue = c("mastodon", "twitter")){

    if (is.null(day)) day <- format(Sys.Date(), "%d")
    if (is.null(month)) month <- format(Sys.Date(), "%B")
    if (is.null(time)) time <- format(Sys.time() + 60*60, "%H:00")

    #browser$navigate("https://publish.buffer.com/calendar/week")
    #Sys.sleep(2) # pause for page to load

    elem <- browser$findElement(using = 'xpath',
                                "//button[text()=' New Post']")
    elem$clickElement()
    Sys.sleep(2) # pause for dialog to load

    # select outlets
    # all (mastodon, twitter and linked-in page) pre-selected by default

    if (!"mastodon" %in% venue) {
        elem <- browser$findElement(using = 'name',
                                    "mastodon-profile-button")
        elem$clickElement()
    }

    if (!"twitter" %in% venue) {
        elem <- browser$findElement(using = 'name',
                                    "twitter-profile-button")
        elem$clickElement()
    }

    elem <- browser$findElement(using = 'name',
                                "linkedin-profile-button")
    elem$clickElement()

    elem <- browser$findElement(using = 'xpath',
                                "//div[@role='textbox']")

    sendChar(elem, postcontent)

    # fragile (which number element to click?) - clicking on drop down arrow
    elem <- browser$findElements(using = 'xpath',
                                "//div[@role='button']")
    elem[[length(elem)]]$clickElement()

    elem <- browser$findElement(using = "id", "SCHEDULE_POST")
    elem$clickElement()

    # select dates and times
    addmonth <- match(month, month.name) -
        match(format(Sys.Date(), "%B"), month.name)
    selectDate(day, addmonth)
    selectTime(time)

    elem <- browser$findElement(using = 'xpath',
                                "//button[text()='Schedule']")
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
    # get left and right arrow buttons
    xpath <- "//div[@class='DayPicker-wrapper']//div//div//button[@type='button']"
    elem <- browser$findElements(using = 'xpath', xpath)
    # click right arrow button add month times
    for (i in seq_len(addmonth)) elem[[2]]$clickElement()

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


