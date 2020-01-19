#what the user sees



dashboardPage(skin = 'yellow',
  ###########################################HEADER########################################            
  dashboardHeader(title = "LaLiga Soccer Data"
                  
                  ),
  
  
  
  
  ###########################################SIDEBAR#######################################
  dashboardSidebar(
    
    div(a(href = 'https://www.laliga.com/en-GB', img(src = 'spain.jpg',width = 140, height = 70))),#this code
    #add the link and picture that takes you to the official la liga website
    sidebarMenu(id = 'menu',#this add all the tabs on the side of the app, and each menuItem
                #is a different tab that you crate and the tabName is how to select this
                #specific tab and add data within that tab
      menuItem('Home', tabName = 'Home', icon = icon('home')),
      menuItem('Introduction', tabName = 'Introduction', icon = icon('futbol')),
      menuItem('League Table', tabName = 'League_Table', icon = icon('table')),
      menuItem('Overview',tabName = 'Overview', icon= icon('address-card')),
      #menuItem('New Players', tabName = 'info', icon = icon('street-view')),
      #menuItem('value box', tabName = 'value', icon = icon('chess')),
      menuItem('Rating', tabName = 'layout', icon = icon('chess')),
      menuItem('New Players', tabName = 'info', icon = icon('street-view'))
      #menuItem ('column layout', tabName = 'column', icon = icon('apple'))
    ),
    ###this adds tabs inside each menuItem
    #the conditionalPanel adds a selector on the tab that you select, in this example i want
    #to add a year selector in the league_Table tab. this keep the selector in the sidebar area
    #and does not put it in the body area of the app.
    conditionalPanel(condition = "input.menu == 'League_Table'",
                     selectInput("year", label = "Select Season:", choices = years,
                                 selected = 2010))#,This gets used in the server so that users
    #can selected a specific year and the table will change with the year selected
  ),
  
  
  
  
  ###########################################BODY###########################################
  dashboardBody(
    tabItems(
      # The Home Tab. tabName = Home
      tabItem(tabName = "Home",
              
               #This is the big picture added to my home screen. make sure all pictures are
              #saved in a folder and name is www
               tags$img(
                src ='laliga.jpg',
                style = 'position: absolute',
                width = 1000,
                height = 600,
                position= 'center'
             
                
              )
      ),
      
      # The Introduction tab. tabName = Introduction
      tabItem(tabName = "Introduction",
              h2("An Analysis of LaLiga Teams Performance"),
              h5('This is my first attempt at making an R shiny app. The focus of this app is to explore LaLiga soccer data and find patterns that affect performance of a team. The dataset used contains over 45 years of league data ranging from 1971 to 2017. Enjoy! '),
              #h5('The dataset used contains over 45 years of league data ranging from 1971 to 2017.\n\n'),
              h6('If interested on the website where the data was scraped from, please click on link below:'),
              h6(a(href = 'https://sofifa.com', img(src = 'fifa.jpg',width = 100, height = 50)))
      ),
      
      # The League Table tab. tabName = League_Table
      tabItem(tabName = 'League_Table',
              fluidRow(
                infoBoxOutput("champ"),#this is the winner box in the app
                infoBoxOutput("lost")#this is the relegation box in the app
              ),
              
               fluidRow(
                   box(width = 10, gt_output(outputId = "table"))#this is(i.e outputId) what gets used in 
                   #the server side. as Output$table
               )
              
              ),
      
      
      
      
      
      # The Overview tab. tabName = Overview
      tabItem(tabName = 'Overview',
              fluidRow(
                tabBox(
                  id = "tabset1",width = 10,
                  tabPanel("Results", highchartOutput('team_results'),
                           selectInput('result', label = 'Select Year:', choices = years,
                                       selected = 2012),
                           highchartOutput('goals')
                           
                           ),
                  tabPanel("Position",highchartOutput('compare'),
                           selectInput("team", label = "Select Team:", choices = team,
                                       selected = 'Real Madrid',multiple = TRUE),
                           
                           highchartOutput('winners_total')
                           )
                )
               
              )
       ),
      # The New Players tab, tabName = 'info'
      tabItem(tabName = 'info',
              fluidRow(
                tabBox(width = 12,
                  
                  tabPanel('The Players',
                           
                           dataTableOutput("team_year"),
                           
                           
                           selectInput('the_year',label = 'Select Year:', choices = year_with_player,
                                       selected = 2008),
                           selectInput('the_team', label = 'Select Team:', choices = team_with_player,
                                       selected = 'Real Madrid'),
                        
                           highchartOutput('unique_players')
                           
                    
                  )
                )
              )
 
              
              ),
      
      # The Rating tab tabName = 'layout'
      tabItem(tabName = 'layout',
              fluidRow(
                tabBox(#
                  id = "tabset0",width = 12,
                  tabPanel("The Squad",
                           fluidRow(
                           column(width = 6,box(width = NULL,highchartOutput('player_rating'))),
                           column(width = 6,box(title = 'The Makeup of the Team',width = NULL, d3treeOutput('sunburst')))),
                           #,#,width = '10',height = '450px'),
                  #select year        
                  selectInput('rating', label = 'Select Year:', choices = year_with_player,
                                       selected = 2013),
                  #select team
                  selectInput('club_player_rating', label = 'Select Club:', choices = team_with_player,
                                       selected = 'FC Barcelona'),
                  
                  highchartOutput('boxplot')
                  
                  )
                )
                
                
              )
              
  
         )

     
     
  )
)

)


