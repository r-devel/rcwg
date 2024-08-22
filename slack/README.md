# Slack Export

This repository contains an export of public messages from the R Contributors Slack 
since it was set up in November 5, 2020.

The export will be updated every 12 weeks (this is a manual process, so the 
reality may differ from this intention!).

Aside from this README, files are in JSON format, organized by Slack channel 
where relevant.

Example R code to read in:

```r
library(dplyr)
library(jsonlite)

# Set the directory where the JSON files are located
data_directory <- "slack/c-study-group"

# List all JSON files in the directory
json_files <- list.files(path = data_directory, pattern = "*[0-9].json", full.names = TRUE)

# Initialize a list to store the combined data
n <- length(json_files)
combined_data <- list()

# Loop through the JSON files and combine the data
for (json_file in json_files) {
  # Extract the date from the filename
  date_str <- gsub(".json$", "", basename(json_file))
  date <- as.Date(date_str)
  
  # Read the JSON file into a data frame
  json_data <- fromJSON(json_file)
  
  # Add a date column to the data frame
  json_data$Date <- date
  
  # Combine the data with the existing data
  combined_data <- bind_rows(combined_data, json_data)
}

# Print the combined data
View(combined_data)

# Last 10 messages from Heather Turner
filter(combined_data, user_profile$display_name == "Heather Turner") |>
  pull(text) |>
  tail(10)
  
# Messages with specific text
grep("Dev Day", combined_data$text, value = TRUE)

# Save the combined data to a CSV file or do further analysis as needed
# write.csv(combined_data, file = "combined_data.csv")
```

