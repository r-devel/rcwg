# Required libraries
library(keyring)
library(here)
library(httr)
library(jsonlite)
library(readr)

# key_set("Weblate") # get personal API from account settings in Weblate
key <- key_get("Weblate")

action <- character(100)
for (i in 1:100){
  url <- paste0("https://translate.rx.studio/api/changes/?action=", i)
  response <- GET(url, add_headers(Authorization = paste("Token", key)))
  changes <- rawToChar(response$content)
  changes <- fromJSON(changes)
  if (!is.null(changes$count) && changes$count)
    action[i] <- changes$results$action_name[1]
}

write_csv(data.frame(action = 1:100, action_name = action),
          here("r_project_sprint", "actions.csv"))
