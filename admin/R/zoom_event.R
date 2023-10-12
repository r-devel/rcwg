library(RSelenium)

zoom_signin <- function(browser, page, email, key = "Zoom password"){
    browser$navigate(page)

    # cookie control
    Sys.sleep(1) # pause for dialog to load
    elem <- browser$findElement(using = 'id',
                                "onetrust-reject-all-handler")
    elem$clickElement()

    # sign in
    # keyring::key_set("Zoom password")
    elem <- browser$findElement(using = 'id', "email")
    elem$sendKeysToElement(list(email))
    elem <- browser$findElement(using = 'id', "password")
    elem$sendKeysToElement(list(keyring::key_get(key)))
    elem <- browser$findElement(using = 'id', "js_btn_login")
    elem$clickElement()
}

# start Selenium server on my machine
# using ~ rather than ${HOME} here does not work!
system("java -Dwebdriver.gecko.driver=${HOME}/Selenium/geckodriver \\
       -jar ~/Selenium/selenium-server-standalone-3.9.1.jar -port 5556 \\
       &>/dev/null &")

# start firefox under remote control - this must work for the rest to work!
browser <- remoteDriver(port = 5556)
browser$open()

# keyring::key_set("Zoom password")
# never signs in - some block on remote control?
zoom_signin(browser = browser,
            page = "https://zoom.us/signin#/login",
            email = "rowforwards@gmail.com",
            key = "Zoom password")

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))
