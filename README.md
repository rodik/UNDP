UNDP
========================================================

This project was designed to test several things:

* Reading a JSON dataset
* Window functions in R
* Creating a simple analysis tool using UNDP data
* Interactive graphs with Plotly
* Uploading the tool to Shinyapps.io

The app is available on [Shinyapps.io](https://frodik.shinyapps.io/UNDP)
Feel free to contact me if you have any questions or you just want to report a bug :)

Downloading and preparing data
----------------------------------------------------------
Data is first downloaded from [UNDP](http://hdr.undp.org/en/data) as a JSON file containing three datasets.
```
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
```
Ranking function
----------------------------------------------------------
The core of this ranking function is a concept I often use within TSQL, a [Window function](https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html).
```
# ranking function returns chosen countries ranked by selected indicator
rank <- function(undp, indi, countries) {
    # filter by indicator
    filtered <- subset(undp, indicator == indi)
    
    # group by year
    grouped <- group_by(filtered, year)
    
    # add rank column
    ranked <- mutate(grouped, rnk = min_rank(value))        
    
    # keep only chosen countries
    ranked <- subset(ranked, country %in% countries)
    
    # return df
    ranked
}
```
