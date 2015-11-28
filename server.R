library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)



shinyServer(function(input, output) {
    
    rank <- function(undp, indi, countries) {
        filtered <- subset(undp, indicator == indi)
        grouped <- group_by(filtered, year)
        ranked <- mutate(grouped, rnk = min_rank(value))
        
        min_rnk <- min(ranked$rnk)
        max_rnk <- max(ranked$rnk)
        
        min_year <- min(ranked$year)
        max_year <- max(ranked$year)
        
        ranked <- subset(ranked, country %in% countries)
        
        list(df = ranked, min_rnk = min_rnk, max_rnk = max_rnk, min_year = min_year, max_year = max_year)
    }
    
    output$trendPlot <- renderPlotly({
        # get inputs
        selected.countries <- as.vector(input$countries.dropdown)
        selected.indicator <- input$indicator.dropdown             

        if (length(selected.countries) > 0){
            data <- rank(measures, indi = selected.indicator, countries = selected.countries)
            
            if (nrow(data$df) > 0) {
                gg <- ggplot(data$df, aes(x = year, y = rnk, colour = country)) +
                    geom_line() +
                    scale_y_discrete("score", lim=c(0, data$max)) +
                    scale_x_discrete(lim=c(data$min_year, data$max_year)) +
                    ggtitle(indicators[indicators$id == selected.indicator,"name"])
                
                
                # Convert the ggplot to a plotly
                p <- ggplotly(gg)
                p
            }
            
        }
    })
})