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

#the la liga table dataframe
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
#this data frame has year range 2007-2017
with_players <-read_csv('data/fifa_player_data_07-17.csv') %>% 
  rename(season = Year, club = Club) %>% 
  filter(season >= 2007) %>% 
  inner_join(la_liga_2.0, by = c('club', 'season')) %>% 
  select(season, club, everything())

#create a variable of unique years for this new data set
year_with_player <- with_players %>% 
  arrange(desc(season)) %>%
  pull(season) %>%
  # pull grabs values in a vector as a array. so I want all the years, this way
  #the user can select each year
  unique()

#do the same for team
team_with_player <- with_players %>% 
  pull(club) %>% 
  unique()



###########



##my function 
#in the function the user puts a year and a team name and the the setdiff gives me the names
#of the plaeyrs that are in the year selected that are not in the previous year i.e. (year -1)
find_new_players <- function ( year, team) {
  
  
  A <- with_players %>% #A contains the playrs of the curret year selected i.e (year)
    filter(club == team & season == as.integer(year)) %>% 
    pull(Name)
  
  B <- with_players %>% #B contains the players from the current year minus 1 so 
    #if i selected year =2010, B would contain players that are in 2009
    filter(club == team & season == as.integer(year) -1) %>% 
    pull(Name)
  
  filter <- with_players %>% 
    filter(season == as.integer(year) -1) %>% 
    select(club) %>% unique() %>% 
    pull(club)
  
  if (year == 2007){
    difference <- 'The dataset for this section begins in 2007 and therefor is the benchmark. Please select a year above 2007. Thank you!'
    
  } else {
    
    
    if (team %in% filter){
      
      difference <- setdiff(A,B)#this is where A and B are compared and setdiff gives me 
      #unique players that are only in A and not in B so this mean i now have the new players
      #that team team singed in the year selecte ( i.e. year in the function)
      
    } else {
      
      difference <- 'Team was not in Leauge'
    }
    
  }
  
  return (difference)
}



###########################################Function for New Player percentage############################
#This function is very similar to the one above, Im just tryin to get the percent new players
#for each team for a specific season

#the data frame used for the function#
 df_percentage <-with_players %>%
   select(season, club, Name,Overall, matches_won, total_matches )

 #the function
find_new_pct <- function(team, year){
   previous_year_team <- df_percentage %>%
     filter(season == year -1) %>%
     pull(club)

   if( !(team %in% previous_year_team)) {
     return (NA)

   }
   A1 <- df_percentage %>%
     filter(club == team & season == year) %>%
     pull(Name)

   B1 <- df_percentage %>%
     filter(club == team & season == year -1) %>%
     pull(Name)

   difference1 <- setdiff(A1,B1)

   return ((length(difference1)/length(A1)) * 100)
 }

 new_player_pct <-df_percentage %>%
   rowwise() %>%
   #mutate(new_player_pct = find_new_pct('Real Madrid', 2016)) %>%
   mutate(new_player_pct = round(find_new_pct(club, season),2)) %>%
   ungroup()

 percent_colums_added <-new_player_pct %>%
   group_by(season,club) %>%
   mutate(win_percentage = round((matches_won/total_matches)*100,2),
          Overall_average = round(mean(Overall),2)) %>%
   ungroup() %>%
   select(season, club, new_player_pct, win_percentage, Overall_average) %>%
   group_by(season, club) %>%
   unique()





