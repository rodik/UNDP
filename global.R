# read data
options(encoding = 'latin1')

measures <- read.csv2(file = "data//measures.csv", stringsAsFactors = FALSE)
countries <- read.csv2(file = "data//countries.csv", stringsAsFactors = FALSE)
indicators <- read.csv2(file = "data//indicators.csv", stringsAsFactors = FALSE)
