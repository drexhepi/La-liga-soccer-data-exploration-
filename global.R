#load libraries
library(shinydashboard)
library(tidyverse)
library(DT)
library(plotly)
library(ggplot2)
library(ggpubr)
library(ggthemes)
library(gganimate)
library(scales)
library(kableExtra)
library(shiny)
library(shinyWidgets)
library(gt)
library(highcharter)
library(d3Tree)
#bring in the data


la_liga_2.0 <- read_csv('data/la_liga_table.csv') %>% 
  group_by(season) %>% 
  mutate (pos = order(order(points, decreasing = TRUE))) %>%
  ungroup()



# Generate Options for dropdown menu in ui
years <- la_liga_2.0 %>% 
  arrange(desc(season)) %>%
  pull(season) %>%
   # pull grabs values in a vector as a array. so I want all the years, this way
  #the user can select each year
  unique()

### get the unique clubs 
team <- la_liga_2.0 %>%
  select(club) %>% 
  unique()



#bring in the player data and merge it to the la_liga_2.0
#this data frame has year range 2007-2016
with_players <-read_csv('data/fifa_player_data_07-17.csv') %>% 
  rename(season = Year, club = Club) %>% 
  filter(season >= 2007) %>% 
  inner_join(la_liga_2.0, by = c('club', 'season')) %>% 
  select(season, club, everything())

year_with_player <- with_players %>% 
  arrange(desc(season)) %>%
  pull(season) %>%
  # pull grabs values in a vector as a array. so I want all the years, this way
  #the user can select each year
  unique()

team_with_player <- with_players %>% 
  pull(club) %>% 
  unique()


####give it a try to make it that when a year is selected the teams for that year only appear 
# team_grouped <- with_players %>% 
#   group_by(season) %>% 
#   filter(season == year_with_player) %>% 
#   pull(club)

###########



##my function 
find_new_players <- function ( year, team) {
  
  
  A <- work_df %>% 
    filter(club == team & season == as.integer(year)) %>% 
    pull(Name)
  
  B <- work_df %>% 
    filter(club == team & season == as.integer(year) -1) %>% 
    pull(Name)
  
  filter <- work_df %>% 
    filter(season == as.integer(year) -1) %>% 
    select(club) %>% unique() %>% 
    pull(club)
  
  if (year == 2007){
    difference <- 'The dataset for this section begins in 2007 and therefor is the benchmark. Please select a year above 2007. Thank you!'
    
  } else {
    
    
    if (team %in% filter){
      
      difference <- setdiff(A,B)
      
    } else {
      
      difference <- 'Team was not in Leauge'
    }
    
  }
  
  return (difference)
}

