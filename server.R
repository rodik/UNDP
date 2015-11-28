library(shiny)
library(plotly)
library(ggplot2)
library(dplyr)



shinyServer(function(input, output) {
    
    ## Window functions in R
    # https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html
    
    # ranking function returns chosen countries ranked by selected indicator
    rank <- function(undp, indi, countries) {
        # filter by indicator
        filtered <- subset(undp, indicator == indi)
        # group by year
        grouped <- group_by(filtered, year)
        # add rank column
        ranked <- mutate(grouped, rnk = min_rank(value))
        
        # get min and max values for plotting limits
        min_rnk <- min(ranked$rnk)
        max_rnk <- max(ranked$rnk)        
        min_year <- min(ranked$year)
        max_year <- max(ranked$year)
        
        # keep only chosen countries
        ranked <- subset(ranked, country %in% countries)
        # return as list
        list(df = ranked, min_rnk = min_rnk, max_rnk = max_rnk, min_year = min_year, max_year = max_year)
    }
    
    output$trendPlot <- renderPlotly({
        # get inputs
        selected.countries <- as.vector(input$countries.dropdown)
        selected.indicator <- input$indicator.dropdown             

        # at least one country selected
        if (length(selected.countries) > 0){
            data <- rank(measures, indi = selected.indicator, countries = selected.countries)
            
            # at least one observation
            if (nrow(data$df) > 0) {
                # create ggplot
                gg <- ggplot(data$df, aes(x = year, y = rnk, colour = country)) +
                    geom_line() +
                    scale_y_discrete("score", lim=c(0, data$max)) +
                    scale_x_discrete(lim=c(data$min_year, data$max_year)) +
                    ggtitle(indicators[indicators$id == selected.indicator,"name"])
                                
                ## Plotly
                # https://plot.ly/r/
                p <- ggplotly(gg)
                p
            }
            
        }
    })
})