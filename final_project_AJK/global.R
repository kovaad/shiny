get_ggplot_plot <- function(df, radio) {
  ggplot(df, aes(reorder(club, -get(radio)), get(radio)))+
    geom_col(color = "black", fill = "blue")+
    theme_bw()+
    theme(axis.text.x=element_text(angle=90, hjust=1)) +
    labs(x='Club', y='Metric')
}

get_data_by_ticker  <- function(ticker, ticker2, rank) {
  
  tryCatch({
    my_data <- read_csv("../data/Node_final_sum_final.csv") #to be uploaded to github and query from there
    
    my_data <- data.table(my_data)
    
    my_data <- my_data[(season_now==ticker) & (country_now==ticker2) & (rk_final >= rank[1]) & (rk_final < rank[2])]
    
    if ( nrow(my_data[complete.cases(my_data)==F,])> 0)  {
      my_data <- my_data[complete.cases(my_data),]
      if(nrow(my_data)==0){
        text<- paste0('Error: ', my_ticker, ' # problem: empty dataframe ', ' time: ', Sys.time())
        stop(text)
      }
    }
    return(my_data)
  }, error=function(x) {
    print(x)
    return(data.table())
  })
  
}


get_edge_data_by_ticker  <- function(ticker, ticker2, rank) {
  
  tryCatch({
    my_data <- read_csv("../data/df_name_corr.csv") #to be uploaded to github and query from there
    my_data <- data.table(my_data)
    
    my_data2 <- read_csv("../data/Node_final_sum_final.csv") 
    my_data2 <- data.table(my_data2)
    my_data2 <- my_data2[(season_now==ticker) & (country_now==ticker2) & (rk_final >= rank[1]) & (rk_final < rank[2])]
    
    my_data <- my_data[(season==ticker) & (country==ticker2) & (window=="Summer")]
    my_data <- my_data |> group_by(team_name2, club_2) |> summarise(count = n()) |> filter((team_name2 %in% my_data2[,"club"][[1]])
                                                                                           & (club_2 %in% my_data2[,"club"][[1]]))
    
    my_data2$index <- 1:nrow(my_data2) - 1
    
    my_data <- merge(my_data,my_data2[,c("club","index")],by.x='team_name2', by.y='club')
    
    my_data <- merge(my_data,my_data2[,c("club","index")],by.x='club_2', by.y='club')
    
    my_data <- data.table(my_data)
    
    
    if ( nrow(my_data[complete.cases(my_data)==F,])> 0)  {
      my_data <- my_data[complete.cases(my_data),]
      if(nrow(my_data)==0){
        text<- paste0('Error: ', my_ticker, ' # problem: empty dataframe ', ' time: ', Sys.time())
        stop(text)
      }
    }
    return(my_data)
  }, error=function(x) {
    print(x)
 return(data.table())
  })
  
}


