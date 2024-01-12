library(RSelenium)

google_signin <- function(browser, page, email,
                          key = "Forwards Google password"){
    browser$navigate(page)

    elem <- browser$findElement(using = 'xpath',
                                "//input[@type = 'email']")
    elem$sendKeysToElement(list(email))

    elem <- browser$findElement(using = 'xpath',
                                "//span[text()='Next']")
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

# keyring::key_set("Forwards Google password")
# blocks sign in, see https://support.google.com/accounts/answer/7675428
zoom_signin(browser = browser,
            page = "https://accounts.google.com/",
            email = "rowforwards@gmail.com",
            key = "Forwards Google password")

browser$close()

# stop server
pid <- system2("lsof", "-t -i :5556", stdout = TRUE)
system(paste("kill -1", pid))
