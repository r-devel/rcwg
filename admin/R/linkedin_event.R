library(RSelenium)

linkedin_signin <- function(browser, page, username, key = "LinkedIn password"){
    browser$navigate(page)

    # cookie control
    #elem <- browser$findElement(using = 'css',
    #                            "[data-control-name='ga-cookie.consent.deny.v4']")
    #elem$clickElement()

    # sign in
    # keyring::key_set("LinkedIn password")
    elem <- browser$findElement(using = 'id', "username")
    elem$sendKeysToElement(list(username))
    elem <- browser$findElement(using = 'id', "password")
    elem$sendKeysToElement(list(keyring::key_get(key)))
    elem <- browser$findElement(using = 'css',
                                "[aria-label='Sign in']")
    elem$clickElement()
}

# press enter in console to continue, don't click next button!
linkedin_createevent <- function(
        browser,
        image, alttext,
        eventtype = "^External event link",
        name, tz, startday, startmonth, starttime,
        endday = startday, endmonth = startmonth, endtime,
        eventlink, description, postcontent,
        ask = TRUE){ #ask before submitting each page
    url <- browser$getCurrentUrl()[[1]]
    browser$navigate(paste0(url, "/?createEvent=true"))
    Sys.sleep(4) # pause for page to load

    # Add image with alt text
    # actual <input id = "file-upload-input-background_edit" ... type="file">
    # element within hidden <div tabindex="-1" aria-hidden="true" ...>
    elem <- browser$findElement(using = "id",
                                "file-upload-input-background_edit")
    elem$sendKeysToElement(list(image))
    Sys.sleep(1) # pause for image to load

    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Alt text']")
    elem$clickElement()

    elem <- browser$findElement(using = 'id',
                                "ef-form__alt_text")
    elem$sendKeysToElement(list(alttext))
    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Apply']")
    elem$clickElement()
    Sys.sleep(1) # pause to go back to main dialog

    # define event type
    elem <- browser$findElement(using = 'id',
                                "ef-event-type-dropdown")
    elem$clickElement()
    Sys.sleep(1)  # pause for drop-down elements to appear
    # To find hidden elements in Chrome inspector tools (not sure how in firefox)
    # - Three dots menu > more tools > rendering
    # - Inspect element that you click on for drop down
    # - Click Event Listeners, expand focusout and click remove
    # - Click on element to open dropdown: code should no longer disappear
    # "//ul[@role='listbox']/li[@role='option']"
    elem <- browser$findElements(using = "xpath", "//li[@role='option']")
    options <- unlist(lapply(elem, function(x) {x$getElementText()}))
    elem <- elem[[grep(eventtype, options)]]
    elem$clickElement()

    # event name
    elem <- browser$findElement(using = 'id', "ef-form__name")
    elem$sendKeysToElement(list(name))

    # time zone
    elem <- browser$findElement(using = 'id', "timezone-picker-dropdown-trigger")
    elem$clickElement()
    Sys.sleep(1)  # pause for drop-down elements to appear

    elem <- browser$findElements(using = "xpath", "//div[@class='artdeco-dropdown__content-inner']/ul/li/div[@class='artdeco-dropdown__item artdeco-dropdown__item--is-dropdown ember-view']")
    options <- unlist(lapply(elem, function(x) {x$getElementText()}))
    elem <- elem[[pmatch(tz, options)]]
    elem$clickElement()

    # select dates and times
    addmonth <- match(startmonth, month.name) -
        match(format(Sys.Date(), "%B"), month.name)
    selectDate(startday, addmonth, type = "start")
    selectTime(starttime, type = "start")

    addmonth <- match(endmonth, month.name) -
        match(format(Sys.Date(), "%B"), month.name)
    selectDate(endday, type = "end")
    selectTime(endtime, type = "end")

    # external event link
    elem <- browser$findElement(using = 'xpath',
                                "//input[@id='ef-location-fields-external-url-form-control']")
    elem$sendKeysToElement(list(eventlink))

    # description
    elem <- browser$findElement(using = 'xpath',
                                "//textarea[@id='ef-form__description']")
    elem$sendKeysToElement(list(description))

    if (ask) readline(prompt="Press [enter] to continue")

    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Next']")
    elem$clickElement()
    Sys.sleep(1) # pause while draft post is loaded

    elem <- browser$findElement(using = 'xpath',
                                "//div[@role='textbox']")
    elem$sendKeysToElement(postcontent)

    if (ask) readline(prompt="Press [enter] to continue")

    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Post']")
    elem$clickElement()

    Sys.sleep(5) # pause while element created

    # don't invite my connections to the event
    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Not now']")
    elem$clickElement()
}

selectDate <- function(daynum = 1, addmonth = 0, type = "start"){
    aria <- sprintf("[aria-label='Select %s date']", type)
    elem <- browser$findElement(using = 'css', aria)
    elem$clickElement()

    # move to correct month
    elem <- browser$findElement(using = 'xpath',
                                "//li-icon[@type='arrow-right-icon']")
    for (i in seq_len(addmonth)) elem$clickElement()

    # same calendar widget used for both, assume start = 1st, end = 2nd
    id <- pmatch(type, c("start", "end"))

    ## first check we are in the right month (TODO: change month)
    #elem <- browser$findElements(using = 'xpath',
    #                             "//h1[@class='artdeco-calendar__month']")[[id]]
    #month <- elem$getElementText()[[1]] # "July 2023"

    # pick day (end date must be >= start date, else does nothing)
    xpath <- sprintf("//button[@data-daynum='%d']", daynum)
    elem <- browser$findElements(using = 'xpath', xpath)[[id]]
    elem$clickElement()
}

selectTime <- function(time = "9:30", type = "start"){
    aria <- sprintf("[aria-label='Select %s time']", type)
    elem <- browser$findElement(using = 'css', aria)
    elem$clickElement()

    # same calendar widget used for both, assume start = 1st, end = 2nd
    id <- pmatch(type, c("start", "end"))

    # convert time to date to be able to use formatting (Europe/London)
    date <- as.POSIXct(paste(Sys.Date(), time), tz = "UTC")
    date <- lubridate::with_tz(date, "UTC")

    elem <- browser$findElements(using = "xpath", "//li[@role='option']")
    options <- unlist(lapply(elem, function(x) {x$getElementText()}))
    elem <- elem[[match(format(date, "%H:%M AM"), options)]]
    elem$clickElement()
}


