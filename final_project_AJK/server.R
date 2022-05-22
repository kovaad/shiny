library(shiny)
library(shinythemes)
library(shinydashboard)
library(data.table)
library(DT)
library(plotly)
library(networkD3)
library(dplyr)

source('global.R')

server <- function(input, output, session) {
    
    years <- seq(1993, 2020, 1)
    
    countries <- c("England", "Spain", "Germany", "Italy", "France")
    
    output$my_ticker <- renderUI({
        selectInput('ticker', label = 'Select season', choices = setNames(years, years), multiple = FALSE)
    })
    
    output$my_ticker2 <- renderUI({
        selectInput('ticker2', label = 'Select country', choices = setNames(countries, countries), multiple = FALSE)
    })
    
    output$slider <- renderUI({
        sliderInput('rank', label = 'Ranking on final table', min = 1, max = 22,step = 1, value = c(1,10))
    })
    
    output$metric <- renderPrint({
        radioButtons("radio", label = "Network metric",
                    choices = list("In-degree" = "in_degree", "Out-degree" = "out_degree", "Betweenness" = "betweenness", "In-coreness" = "in_coreness", "Out-coreness" = "out_coreness"))
    })
    
    my_reactive_df <- reactive({
        df<- get_data_by_ticker(input$ticker, input$ticker2, input$rank)
        return(df)
    })
    
    output$my_data <- DT::renderDataTable({
        my_reactive_df()[,c("club", "in_degree", "out_degree", "betweenness", "in_coreness", "out_coreness", "rk_final")]
    })
    
    output$data_plot <- renderPlotly({
        get_ggplot_plot(my_reactive_df(), input$radio)
    })
    
    my_reactive_df2 <- reactive({
        df<- get_edge_data_by_ticker(input$ticker, input$ticker2, input$rank)
        return(df)
    })
    
    output$my_data2 <- DT::renderDataTable({
        my_reactive_df2()[,c("club_2", "team_name2", "count")]
    })
    
    output$progressBox1 <- renderValueBox({
        valueBox(
            round(mean(my_reactive_df()[,c("rk_mid")][[1]]),2), "Avg ranking mid-season",  icon = icon("align-justify"),
            color = "purple"
        )
    })
    
    output$progressBox2 <- renderInfoBox({
        infoBox(
            "Average points", value = tags$p(style = "font-size: 35px;", paste0(round(mean(my_reactive_df()[,c("pts_final")][[1]]),2), " points")), icon = icon("list"),
            color = "purple", fill = TRUE
        )
    })
    
    output$progressBox3 <- renderValueBox({
        valueBox(
            round(mean(my_reactive_df()[,c("rk_final")][[1]]),2), "Avg ranking", icon = icon("align-justify"),
            color = "purple"
        )
    })
    
    
    output$fnetwork <- renderForceNetwork(
        forceNetwork(width = '1500px', height = '1800px', Links = my_reactive_df2(), Nodes = my_reactive_df()[,c("club", "rk_final")]|> mutate(club = as.factor(club)), Source = "index.x",
                     Target = "index.y",  Value = "count", NodeID = "club", Group = "rk_final",
                     opacity = 0.9, zoom = TRUE, fontSize = 25, linkColour = "black")
    )
}