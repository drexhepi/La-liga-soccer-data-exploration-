#what gets updated/run as the user interacts with the interface

####################the dashboard page##################


function(input, output) {
  
##################The League Table tab. tabName = League_Table ###################################

  output$table <- render_gt({ #output$table. the table is the name given in the ur side
    #so this is how the code is usually writen for all data visualization. 
    la_liga_2.0 %>% 
      arrange(pos) %>% 
      select(season,pos,Team = club,Played = total_matches,HW = home_win, HL = home_loss,HG = home_goals, 
             AW = away_win, AL = away_loss, AG = away_goals, 
             Wins = matches_won, Draws = matches_drawn, Losses = matches_lost,
             For = goals_scored,Against = goals_conceded,
             `Goal Diff` = goal_difference, Points = points) %>% 
      filter(season == input$year) %>% ###filter it before you make it into a gt() table
      #this input$year is the conditional panel that I and for this tab. it allows user to select
      # a year that they want. needs to be called like this (input$ then the name of your selector,
      # for this example its year. to input$year)
      
      gt() %>%#this fuction turns the data into a gt table
      tab_spanner(
        label = "HOME",
        columns = vars(HW, HL, HG)
      ) %>%
      tab_spanner(
        label = "AWAY",
        columns = vars(AW, AL, AG)
      ) %>% 
      tab_spanner(
        label = "TOTAL",
        columns = vars(Wins,Draws,Losses,For,
                       Against,`Goal Diff`,Points)
      )%>%
      tab_style(
        style = list(
          cell_fill(color = "red"),
          cell_text(color = "black")
        ),
        locations = cells_body(
          rows = pos >= 18)
      ) %>% 
      tab_style(
        style= list(
          cell_fill(color = 'lightgreen'),
          cell_text(color = 'black')
          
        ),
        locations = cells_body(
          rows = pos == 1)
      ) %>% 
      cols_hide(
        columns = vars(season)) %>%
      tab_header(
          title = paste('The League Table:',input$year))
  
    }) 
 

  # This is the green box that hows the team that won in that year 
  output$champ <- renderInfoBox({#need to use the renderInfoBox 
    winner <-la_liga_2.0 %>% 
      filter(season == input$year) %>% 
      filter(pos == 1) %>% 
      select(club)
    
    infoBox(
      "Winner", paste(winner), icon = icon("trophy"),
      color = "green", fill = TRUE
    )
  })
  
  #for the loser
  #this is the Relegation ,red box, that has the three teams that are relegated 
  output$lost <- renderInfoBox({
    loser <-la_liga_2.0 %>% 
      filter(season == input$year) %>% 
      filter(pos == 18 ) %>% 
      pull(club)
    
    loser1 <-la_liga_2.0 %>% 
      filter(season == input$year) %>% 
      filter(pos == 19 ) %>% 
      pull(club)
    
    loser2 <-la_liga_2.0 %>% 
      filter(season == input$year) %>% 
      filter(pos == 20 ) %>% 
      select(club)
    
    infoBox(#this got a little messi, but I had to do this to get the three teams to show
      #in the relegation box. I think the box could not fit all three names in a list so 
      #that to do it this way
     'Relegation', c(loser,",",loser1,",",loser2), icon = icon('window-close'),
      color = 'red', fill = TRUE
    )
  })
  

############################The Overview tab. tabName = Overview###################################  
  
  
### for the team wins/draws/losses chart
  output$team_results <- renderHighchart({
  #seems like you have to do data.frame() in order for highchart() to work, but isnt always
    #the case. because in the later figures in didnt have to do this part.
  chart <- data.frame(la_liga_2.0) %>% 
  filter(season == input$result)
  
  #team <- "club"
  matches <- c("matches_won","matches_drawn","matches_lost")
  
  highchart() %>% 
    hc_title(text = paste('Results per Team:',input$result)) %>% 
    hc_xAxis(categories = chart[,'club'],
             title = 'club') %>% 
    hc_add_series(name = 'Wins',
                  #type = 'column',
                  data = chart[,matches[1]]) %>% 
    hc_add_series(name = 'Draws',
                  #type = 'column',
                  data = chart[,matches[2]]) %>% 
    hc_add_series(name = 'Losses',
                  #type = 'column',
                  data = chart[,matches[3]]) %>% 
    hc_chart(type = "column") %>% 
    hc_colors(c('#90ed7d', '#cccccc', '#ff3333')) %>%
    hc_tooltip(crosshairs = TRUE, shared = TRUE)%>% 
    hc_yAxis(title = list(text = "Games Played"))
  
  
  })
  
  
#####for the goals graph within the same tab as the resluts
  output$goals <- renderHighchart({
  
  #seen like you have to do data.frame() in order for highchart() to work  
  goals_year <- data.frame(la_liga_2.0) %>% 
    filter(season == input$result)
  
  #team <- "club"
  var_goals <- c("goals_scored","goals_conceded","goal_difference")
  
  highchart() %>% 
    hc_title(text = paste('Goals per Season:', input$result)) %>% 
    hc_xAxis(categories = goals_year[,'club'],
             title = 'club') %>% 
    hc_add_series(name = 'Goals Scored',
                  type = 'column',
                  data = goals_year[,var_goals[1]]) %>% 
    hc_add_series(name = 'Goals Conceded',
                  type = 'column',
                  data = goals_year[,var_goals[2]]) %>% 
    hc_add_series(name = 'Goal Difference',
                  type = 'spline',
                  data = goals_year[,var_goals[3]]) %>% 
    #hc_chart(type = "column") %>% 
    hc_colors(c('#1aadce', '##2f7ed8', '#ff3333')) %>%
    hc_tooltip(crosshairs = TRUE, shared = TRUE)%>% 
    hc_yAxis(title = list(text = "Goal Distrbution"))
  })
  
  
  
  
  ######################################### 
  output$compare <- renderHighchart({
   # browser()
    la_liga_2.0 %>%
      filter(club %in% input$team ) %>% 
      count(season,club,pos) %>% 
      hchart('line', hcaes(x= 'season', y = 'pos', group = 'club')) %>%
      hc_title(text = paste('Overall Finish')) %>% 
      hc_yAxis(title = list(text = 'Final Position'))
      
  })
  
  
  #### ADD the tree map
  output$winners_total <- renderHighchart({  
  
  
  la_liga_2.0 %>%
    group_by(season, club) %>% 
    filter(pos == 1) %>%
    ungroup() %>%
    group_by(club) %>% 
    count() %>% 
    rename(champ = n) %>% 
    arrange(desc(champ)) %>% 
    ungroup() %>% 
    hchart('treemap', hcaes(x = 'club', value = 'champ', color = 'champ')) %>% 
    hc_colorAxis(
      minColor = "gray",
      maxColor = "orange"
    ) %>% 
      hc_title(text = paste('The winners and the number of times each team won the Leauge'))
  })
  
  
  
##########################  The Rating tab tabName = 'layout'  ##################################
  
 ################ the circle chart for player rating ########## 
   output$player_rating <- renderHighchart({
     
     rating <- with_players %>% 
       filter(season == input$rating & club == input$club_player_rating ) %>% 
       arrange(desc(Overall))
     
     
     highchart() %>% 
       hc_chart(polar = TRUE) %>% 
       hc_title(text = paste('Players Rating for',input$club_player_rating,'in',input$rating),
                style = list(fontWeight = 'bold', fontSize = '20px', align = 'center')) %>% 
       hc_subtitle(text = '85 or higher is considered Elite Player',
                   stype = list(fontWeight = 'bold'), align = 'center') %>% 
       hc_xAxis(categories = rating$Name, style = list(fontWeight = 'bold')) %>% 
       hc_legend(enabled = FALSE) %>% 
       hc_series(
         list(
           name = "Bars",
           data = rating$Overall,
           colorByPoint = TRUE,
           type = "column",
           colors = ifelse(rating$Overall >= 85, 'purple','light')
         ),
         list(
           name = 'Overall Rating',
           data = rating$Overall,
           pointPlacement = 'on',
           type = 'line'
         )
       )
   })
 
 ############# add the tree line  map#############
  
  output$sunburst <- renderD3tree({
    
    random_tree <- with_players %>%
      filter(season == input$rating & club == input$club_player_rating)
    
    random_tree <- random_tree %>%
      group_by(Nationality, Name, Position, Age) %>% 
      count()
    
    d3tree(list(root = df2tree(rootname = input$club_player_rating, struct = as.data.frame(random_tree)),
               layout = 'collapse'))
  })
      

##################box plot ##################
  output$boxplot <- renderHighchart({ 
    
    
    boxplot <- with_players %>% 
      filter(season == input$rating)
  
    highchart() %>% 
      hc_title(text = paste('Distribution of Age and Overall Rating per Team for the Year:',input$rating),
                             style = list(fontWeight = 'bold', fontSize = '20px', align = 'center')) %>% 
      hc_subtitle(text = 'Top performing teams have median Age between (23-26) and median Rating of 80 or greater',
                  stype = list(fontWeight = 'bold'), align = 'center') %>%
      hc_add_series_boxplot(x = boxplot$Age, by = boxplot$club, name = "Age") %>%
      #hc_yAxis(plotLines = list(plotline)) %>% 
      hc_add_series_boxplot(x = boxplot$Overall, by = boxplot$club, name = 'Overall Rating')
  
  })
  

  
###################### The New Players tab, tabName = 'info' #################################### 
  
  
  ########### unique player in one year and not the other ##########
  output$team_year <- renderDataTable({
    
   unique_players <- find_new_players(input$the_year, input$the_team)
   
  #browser()
   
   with_players %>% 
     filter( season == input$the_year & Name %in% unique_players & club == input$the_team ) %>% 
     select(Name, Nationality, Age, Position, Overall)
   
  



  })
  
############### server for the new player percentage  
  
output$unique_players <- renderHighchart({

  one_team <-percent_colums_added %>% filter(club == input$the_team)

  highchart() %>%
    hc_title(text = paste('How team performance is affected as new players join the roster')) %>%
    hc_subtitle(text = paste('Does this say anything about', input$the_team,'?'),
                 align = 'center') %>%
    hc_xAxis(categories =one_team$season,
             title = 'season') %>%
    hc_add_series(name = 'Win Percentage',
                  type = 'line',
                  data = one_team$win_percentage) %>%
    hc_add_series(name = 'Percent New Players',
                  type = 'line',
                  data = one_team$new_player_pct) %>%
    # hc_add_series(name = 'Win Percentage',
    #               type = 'line',
    #               data = one_team$win_percentage) %>%
    hc_tooltip(crosshairs = TRUE, shared = TRUE)%>%
    hc_yAxis(title = list(text = "Percent"))


})
  
  
}

















  