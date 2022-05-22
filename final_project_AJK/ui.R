library(shiny)
library(shinythemes)
library(shinydashboard)
library(data.table)
library(DT)
library(plotly)
library(networkD3)
library(dplyr)

source('global.R')

ui <-dashboardPage(
    
    dashboardHeader(title = 'Football Transfers'),
    dashboardSidebar(
        sidebarMenu(
        menuItem("   Dashboard", tabName = "plot", icon = icon("dashboard")),
        menuItem("   Network", tabName = "network", icon = icon("random")),
        menuItem("   Data", tabName = "data", icon = icon("th")))
    ),
    dashboardBody(
        tags$head(tags$style(".sidebar li { 
                                margin-bottom: 10px; 
                                margin-top: 50px;
                             }")),
        tags$head(tags$style(HTML('
            
            .skin-blue .sidebar a {
                font-size: 25px;
                color: #ccff00;
                
            }'
        ))),
        
        tabItems(
            
            tabItem(tabName = "plot",
                    h1('Network characteristics of top-tier football teams'),
                    h2('European top 5 football leagues from 1993 to 2020'),
                    h3('Summer transfer windows'),
                    box(title = "Inputs", background = "aqua", solidHeader = TRUE,width = 400,
                    fluidRow(width=12,height = 105,
                             column(width=6,
                    uiOutput('my_ticker'),),
                    column(width=6,
                    uiOutput('my_ticker2')),
                    ),
                    
                    fluidRow(width=12,
                        column(width=6,
                    uiOutput('slider'),),
                    column(width=6,
                    uiOutput('metric')),),
                    ),
                    box(
                        title = "Bar chart of network metrics", background = "blue", solidHeader = TRUE,width = 400,
                        plotlyOutput('data_plot')),
                    box(title = "Facts", background = "light-blue", solidHeader = TRUE,width = 400,
                    fluidRow(
                           valueBoxOutput("progressBox1"),
                           infoBoxOutput("progressBox2"),
                           valueBoxOutput("progressBox3"))
                    
                    )
            ),
            
            tabItem(tabName = "network",
                    h1('Network of transfers between selected clubs on Dashboard tab'),
                    h5('Please click on node to show the name of club'),
                    box(
                        title = "Network", background = "light-blue", solidHeader = TRUE,width = 400,
                    forceNetworkOutput('fnetwork'))
            ),
            tabItem(tabName = "data",
                    h1('Network characteristics data'),
                    dataTableOutput('my_data'),
                    h1('Network data for visualization'),
                    dataTableOutput('my_data2')
                    
            )
        )
        
    )

)

