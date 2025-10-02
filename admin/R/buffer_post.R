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
        elem <- browser$findElement(using = 'xpath',
                                    "//button[@aria-label='mastodon channel (selected)']")
        elem$clickElement()
    }

    if (!"twitter" %in% venue) {
        elem <- browser$findElement(using = 'xpath',
                                    "//button[@aria-label='twitter channel (selected)']")
        elem$clickElement()
    }

    elem <- browser$findElement(using = 'xpath',
                                "//button[@aria-label='linkedin channel (selected)']")
    elem$clickElement()

    elem <- browser$findElement(using = 'xpath',
                                "//div[@role='textbox']")

    sendChar(elem, postcontent)

    # fragile (which number element to click?) - clicking on drop down arrow
    elem <- browser$findElements(using = 'xpath',
                                "//div[@role='button']")
    elem[[length(elem)]]$clickElement()

    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Next Available']")
    elem$clickElement()
    elem <- browser$findElement(using = 'xpath',
                                "//p[text()='Set Date and Time']")
    elem$clickElement()

    # select dates and times
    addmonth <- match(month, month.name) -
        match(format(Sys.Date(), "%B"), month.name)
    selectDate(day, addmonth)
    selectTime(time)

    elem <- browser$findElement(using = 'xpath',
                                "//button[text()='Apply']")
    elem$clickElement()

    elem <- browser$findElement(using = 'xpath',
                                "//button[text()='Schedule Post']")
    elem$clickElement()
}

sendChar <- function(elem, text){
    text <- as.list(strsplit(text, "", useBytes = TRUE)[[1]])
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
    # click right arrow button add month times
    elem <- browser$findElement(using = 'xpath',
                                "//button[@aria-label='Go to the Next Month']")
    # click right arrow button add month times
    for (i in seq_len(addmonth)) elem$clickElement()

    # pick day
    xpath <- paste0("//button[text()='", as.numeric(daynum), "']")
    elem <- browser$findElement(using = 'xpath', xpath)
    elem$clickElement()
}

selectTime <- function(time = "9:30"){
    # convert time to date to be able to use formatting (Europe/London)
    date <- as.POSIXct(paste(Sys.Date(), time), tz = "UTC")
    date <- lubridate::with_tz(date, "Europe/London")

    # hour
    elem <- browser$findElement(using = "xpath",
                                "//div[@aria-label='hour, Time selector']")
    elem$sendKeysToElement(list(format(date, "%I")))

    # minute
    elem <- browser$findElement(using = "xpath",
                                "//div[@aria-label='minute, Time selector']")
    elem$sendKeysToElement(list(format(date, "%M")))

    # am/pm
    elem <- browser$findElement(using = "xpath",
                                "//div[@aria-label='AM/PM, Time selector']")
    elem$sendKeysToElement(list(format(date, "%p")))
}


