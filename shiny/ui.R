source('helper.R')

shinyUI(fluidPage(
  
  # Application title
  titlePanel("ATH by Month"),
  sidebarLayout(
    sidebarPanel(
      selectInput("mnth", "Select a month:", choices)
      #,
      #selectInput("channel", "Select a channel for Counts chart:", c('drummer','freeform',  
      #                                                               'ichiban', 'jm'), selected='freeform')
    ),
    mainPanel(
      plotlyOutput("ath.sum"),
      br(),br()
      #,
      #plotlyOutput("ath.counts")
    ))))
