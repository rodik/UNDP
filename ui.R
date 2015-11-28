library(shiny)
library(plotly)

shinyUI(fluidPage(
    titlePanel("UNDP - Human Development Report"),    
    sidebarPanel(helpText(a("Get the code from GitHub", href="https://github.com/rodik/UNDP", target="_blank")),
                 helpText("- Select a couple of countries to display",
                          "and choose an indicator for comparison.",
                          "Some data is missing."
                 ),
                 helpText("- Y axis shows the score of a certain country which is actually its reverse rank for the specific indicator. A score of 95 means that there are 94 countries which are ranked lower."
                 ),
                 helpText("- X axis is the year of measurement. Not all years are available."
                 )
    ),
    mainPanel(
        fluidRow(
            column(6,
                selectInput("countries.dropdown", label = h3("Countries"), 
                   choices = setNames(as.list(countries$id), countries$name),
                   multiple = TRUE,
                   width = "80%"
                )
            ),  
            column(6,
                selectInput("indicator.dropdown", label = h3("Indicator"), 
                   choices = setNames(as.list(indicators$id), indicators$name),
                   multiple = FALSE,
                   selected = 306,
                   width = "80%"
                )
            )
        ),
        fluidRow(
            plotlyOutput("trendPlot")
        )
    )
))