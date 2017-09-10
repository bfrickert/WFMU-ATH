source('helper.R')

shinyServer(function(input, output) {
  
  getMonthlyAggr <- reactive({
    return(arrange(filter(aggr, dt == input$mnth), desc(channel)))
  })
  
  output$ath.sum <- renderPlotly({
    ax <- list(
      title = "channel",
      zeroline = FALSE,
      showline = FALSE,
      showticklabels = FALSE,
      showgrid = FALSE
    )
    yx <- list(
      title = "sum of ATH (in hours)"
    )
    
    plot_ly(arrange(aggr, channel), 
            x=~channel, y=~sum.ath, type='bar', 
            color=~channel) %>%
      layout(showlegend=F, yaxis=yx, xaxis=ax, title='')
  })
  
  # output$ath.counts <- renderPlotly({
  #   library(plotly)
  #   x <- list(
  #     title = "Date"
  #   )
  #   y <- list(
  #     title = "Listener Count"
  #   )
  #   library(dplyr)
  #   plot_ly(filter(counts.by.channel, as.numeric(cnt) > 0 & grepl(input$channel, channel) & yr.mnth == input$mnth), x = paste(dt, hr, sep=" "), y = as.numeric(cnt), color=channel) %>%
  #     layout(title="Listerner Count by Channel", xaxis=x, yaxis=y)
  # })
  
})
