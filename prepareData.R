# getting data
library(jsonlite)
library(plyr)
library(dplyr)
library(plotly)

# read data
json_file <- "http://ec2-52-1-168-42.compute-1.amazonaws.com"
json_data <- jsonlite::fromJSON(json_file)

# create countries data.frame
countries <- ldply(json_data$country_name)
names(countries) <- c("id","name")

# create indicators data.frame
indicators <- ldply(json_data$indicator_name)
names(indicators) <- c("id","name")
indicators$id <- as.integer(indicators$id)

# create main data.frame
data <- as.data.frame(json_data$indicator_value, stringsAsFactors = FALSE)
names(data) <- c("country","indicator","year","value")
data$indicator <- as.integer(data$indicator)
data$year <- as.integer(data$year)
data$value <- as.numeric(data$value)

# save to CSV
write.csv2(data, file = "measures.csv", row.names = F)
write.csv2(indicators, file = "indicators.csv", row.names = F)
write.csv2(countries, file = "countries.csv", row.names = F)