library(RSelenium)

rcwg_subscribers <- function(browser, page, username, key = "R-contribution-wg password"){
    browser$navigate(page)

    # sign in
    # keyring::key_set("Buffer password")
    elem <- browser$findElement(using = 'name', "roster-email")
    elem$sendKeysToElement(list(username))
    elem <- browser$findElement(using = 'name', "roster-pw")
    elem$sendKeysToElement(list(keyring::key_get(key)))
    elem <- browser$findElement(using = 'name', "SubscriberRoster")
    elem$clickElement()

    # get emails from both lists (non-digested and digested)
    elem <- browser$findElements(using = "xpath", "//li")
    emails <- unlist(lapply(elem, function(x) {x$getElementText()}))

    # remove emails in brackets (have turned off email)
    emails <- emails[!grepl("^[(].*", emails)]

    # fix up
    cat(sub(" at ", "@", emails), sep = ", ")
}
