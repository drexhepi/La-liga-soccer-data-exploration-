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
#bring in the data


la_liga_2.0 <- read_csv('data/la_liga_table.csv') %>% 
  group_by(season) %>% 
  mutate (pos = order(order(points, decreasing = TRUE))) %>%
  ungroup()

# order <- la_liga_2.0 %>% 
#   arrange(pos) %>% 
#   select(season,pos,Team = club,Played = total_matches,HW = home_win, HL = home_loss,HG = home_goals, 
#          AW = away_win, AL = away_loss, AG = away_goals, 
#          Wins = matches_won, Draws = matches_drawn, Losses = matches_lost,
#          For = goals_scored,Against = goals_conceded,
#          `Goal Diff` = goal_difference, Points = points)
# 
# order <- gt(order)
# 
# p <- order%>%
#   #gt(rowname_col = "season") %>%
#   
#   tab_spanner(
#     label = "HOME",
#     columns = vars(HW, HL, HG)
#   ) %>%
#   tab_spanner(
#     label = "AWAY",
#     columns = vars(AW, AL, AG)
#   ) %>% 
#   tab_spanner(
#     label = "TOTAL",
#     columns = vars(Wins,Draws,Losses,For,
#                    Against,`Goal Diff`,Points)
#   )%>%
#   tab_style(
#     style = list(
#       cell_fill(color = "red"),
#       cell_text(color = "black")
#     ),
#     locations = cells_body(
#       rows = pos >= 18)
#   ) %>% 
#   tab_style(
#     style= list(
#       cell_fill(color = 'lightgreen'),
#       cell_text(color = 'black')
#       
#     ),
#     locations = cells_body(
#       rows = pos == 1)
#   )





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



