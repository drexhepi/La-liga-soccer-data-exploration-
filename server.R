#what gets updated/run as the user interacts with the interface



##(code) function(input,output){
##  observeEvent(input$clicks, {
 #   print(as.numeric(input$clicks))
 # })


  #1 every output you want in teh graph needs to be saved as output$name of your
  #output from the ui.R so here the name is hist
  #2 you buid the actual plot that calling the renderPlot({}) and 
  #3in the code you used to build the actual output i.e. for this one its the 
  #sliderInput(InputId = 'num') to so accesss that you need to use 
  #input$num 
  
  #the renderPlot is the reactive function. this creates the interact graph
 
#(code) output$hist <- renderPlot({
 

   #title <- '100 random normal values'
    #hist(rnorm(100), main = title)#build objects to display with render()
    #or you can use it with the input name
    
#(code)hist(rnorm(input$num), main = isolate({input$title}) )#####input$title)#so this is connected with the inputId from the ui.R, whenever that changes input$num also changes 
#    })#this is how you access the input function
#(conde)  output$stats <- renderPrint({
#(code)    summary(rnorm(input$num))#this used the same input i.e. input$num as 
    #the hist so this is how to get two diff visualization for on specific
    #select by the user
#  })
#}

#what is reactivity? 
#input$x ------ > output$y(i.e. graphs, tables)
#sliders ect..

#reactive function toolkit
# there are 7
#### render*() function 
#first one is Display output with render*()
#to use it  renderPlot( { hist(rnorm(input$num)) })
#you can add hundreds of code and the brackets will run it as one 

#### modularize code with reactive()
#reactive() builds a reactive object called reactive expression
#ex. data <- reactive( {rnorm(input$num) })
#are technically functions  i.e. call it data()
#so the above can be rewriten as and still work the same way:
  #function(input,output){ 
    #data <- reactive({
      #rnorm(input$num)
   # })
    #output$hist <- renderPlot( {
      #hist(data())
    #})
   # output$stats <- renderPrint({
      #summary(data())
   #})
#}

####prevent reactions with isolate()
#prevent the app from responding the the title name
#isolate() returns the result as a non-racttive value
#isolate({ rnorm(input$num) })

###trigger code with observeEvent()
#Action button
#so observeEvent() works with the action button which is in the 
#ui.R page
# observeEvent(input$clicks, {print(input$clicks) })

###observe()
#also triggers code to run on server. uses same syntax as render*() and isolate()
# observe({print(input$clicks) })

###delay reactions with eventReactive()
# similare to isolate() but this just delays it.
#ex. i want the update button to change the graph 
# data <- eventReactive ( input$go, {rnorm(input$num) })
#so the above can be rewriten as and still work the same way:
#function(input,output){ 
#data <- eventReactive(input$go, {
      #rnorm(input$num)
# })
#output$hist <- renderPlot( {
#hist(data())
#})
#}

###mamage state with reactive values()
#creates a list of reactive values to manipulate programmatically
# rv <- reactiveValues(data = rnorm(100))

####in the ui.
# fluidPage(
#   actionButton(inputId = 'norm', label = 'Normal'),
#   actionButton(inputId = 'unif', label = 'Uniform'),
#   plotOutput('hist')
# )
# 
# ##### in the server
# function(input,output){
#   rv <- reactiveValues(data = rnorm(100))
#   
#   observeEvent(input$norm, {rv$data <- rnomr(100)})
#   observeEvent(input$unif, {rv$data <- runif(100)})
#   
#   output$hist <- renderPlot({
#     hist(rv$data)
#   })
# }


#how do you add content to a web page?
# tags object
# tags$h1()
# tags$a(href = 'www.rstudio.com', 'RStudio')

# a new paragrpah p()

####add images to the app
# img()
# fluidPage(
#   tags$img(height = 100,
#            width= 100,
#            src = 'http://www.rstudio.com/images/RStudio.2x.png')
# )#src stands for source 

###create a layout
#use layout functions to position elements wthin you app

#the two main functions are fluidRow()  and column(width = 2)

#fluidRow() divides the app up into rows. it adds rows to the gird
#each new row goes below the previous rows

# fluidPage(
#   fluidRow(),#row 1
#   fluidRow() #row 2
# )

#the column()  adds columns within a row. each new column goes to the left
#of the previous column
##specify the width and offset of each column out of 12

# fluidPage(
#   fluidRow(
#     column(3),
#     column(5, sliderInput(...))#puts the slider in this column
#   ),
#   fluidRow(
#     column(4, offset = 8,
     # plotOutput('hist'))#offset column by 8 units,puts it to the right most side of the app
#   )#puts the histogram in this column
# )

###assembly layers of panels
#panels to group multiple elemets into a single unit with its own properties

###using wellPanel() i.e. groups things together
# fluidPage(
#   wellPanel(
#     sliderInput('num', 'choose a number',
#                 value=23,1,100),
#     textInput('title', value = 'histogram',
#               label = 'write a title'),
#   ),
#   plotOutput('hist')
# )

#tabsetPanel() conbines tabs into a single panel. use tabls to navigate btween tabs

# fluidPage(
#   tabsetPanel(
#     tabPanel('tab 1', 'contents'),
#     tabPanel('tab 2', 'contents'),
#     tabPanel( 'tab 3', 'contents')
#   )
# )

###same as above expcept adding more material
# fluidPage(title = 'Random generator',
#   tabsetPanel(
#     tabPanel(title = 'normal data',
#              plotOutput('norm'),
#              actionButton('renorm', 'resample')
#              ),
#     tabPanel(title = 'uniform data',
#              plotOutput('unif'),
#              actionButton('reunif','resample')
#              ),
#     tabPanel( title = 'chi squared data',
#               plotOutput('chisq'),
#               actionButton('rechisq', 'resample')
#               )
#   )
# )



###########use this ######

## navlistPanel() combines tabs into a single panel. use links to navigate between tabs
##very simialr to tabsetPanel excel it sets them up column wise 

# fluidPage(
#   navlistPanel(
#     tabPanel('tab 1', 'contents'),
#     tabPanel('tab 2', 'contents'),
#     tabPanel( 'tab 3', 'contents')
#   )
# )


###same as above expcept adding more material
# fluidPage(title = 'Random generator',
#   navlistPanel(
#     tabPanel(title = 'normal data',
#              plotOutput('norm'),
#              actionButton('renorm', 'resample')
#              ),
#     tabPanel(title = 'uniform data',
#              plotOutput('unif'),
#              actionButton('reunif','resample')
#              ),
#     tabPanel( title = 'chi squared data',
#               plotOutput('chisq'),
#               actionButton('rechisq', 'resample')
#               )
#   )
# )




###layouts
# sidebarLayout() use with sidebarPanel() and mainPanel() to divide app
#into two sectinos.

# fluidPage(
#   sidebarLayout(
#     sidebarPanel(),
#     mainPanel()
#   )
# )


### same as above with more features

# fludPage(
#   sidebarLayout(
#     sliderInput(inputId = 'num',
#                 label = 'choose a number',
#                 value =21,1,100),
#     testInput(inputId = 'title',
#               label = 'write a title',
#               value = 'histogram of random normal values')
#   ),
#   mainPanel(
#     plotOutput('hist')
#   )
# )

###### another good one to put on the app##

#navbaPage() combines tabs into a single page. navbarPage() replaces fluidPage().requires title

# navbarPage(title = 'Title',
#            tabPanel('tab 1', 'contents'),
#            tabPanel( 'tab 2', 'contents'),
#            tabPanel( 'tab 3', 'contents')
#            )


###same as above expcept adding more material
# navbarPage(title = 'Random generator',
#   
#     tabPanel(title = 'normal data',
#              plotOutput('norm'),
#              actionButton('renorm', 'resample')
#              ),
#     tabPanel(title = 'uniform data',
#              plotOutput('unif'),
#              actionButton('reunif','resample')
#              ),
#     tabPanel( title = 'chi squared data',
#               plotOutput('chisq'),
#               actionButton('rechisq', 'resample')
#               )
#   
# )


###########
#this one is a good one
#navbarMenu() combines 

# navbarPage(title = 'Random generator',
#   
#     tabPanel(title = 'normal data',
#              plotOutput('norm'),
#              actionButton('renorm', 'resample')
#              ),
#   navbarMenu(title = 'other data',###the menu puts the last two tabs in a group of their own 
#     tabPanel(title = 'uniform data',
#              plotOutput('unif'),
#              actionButton('reunif','resample')
#              ),
#     tabPanel( title = 'chi squared data',
#               plotOutput('chisq'),
#               actionButton('rechisq', 'resample')
#               )
#   )
# )



####################the dashboard page##################


#dashboardPage() comes in the shinydashboard package

##In the ui.R
# dashoardPage(
#   dashboardheader(),
#   dashboardSidbar(),
#   dashboardBody()
# )


###   CSS ####
#cascading style sheets CSS are a framework for customizing the 
#apprearance of elements in a web page


function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  #the currently selected tab from the first box
  output$tabset1Selected <- renderText({input$tabset1})
  
  
  #info box
  output$progressBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  output$approvalBox <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  # Same as above, but with fill=TRUE
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  output$approvalBox2 <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow", fill = TRUE
    )
  })
  
  
#for the value Box
  # output$progressBox <- renderValueBox({
  #   valueBox(
  #     paste0(25 + input$count, "%"), "Progress", icon = icon("list"),
  #     color = "purple"
  #   )
  # })
  # 
  # output$approvalBox <- renderValueBox({
  #   valueBox(
  #     "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
  #     color = "yellow"
  #   )
  # })
  ######################################
  
  #########################################
  output$table <- render_gt({ 
    la_liga_2.0 %>% 
      arrange(pos) %>% 
      select(season,pos,Team = club,Played = total_matches,HW = home_win, HL = home_loss,HG = home_goals, 
             AW = away_win, AL = away_loss, AG = away_goals, 
             Wins = matches_won, Draws = matches_drawn, Losses = matches_lost,
             For = goals_scored,Against = goals_conceded,
             `Goal Diff` = goal_difference, Points = points) %>% 
      filter(season == input$year) %>% ###filter it before you make it into a gt() table
      
      gt() %>%
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
 

  # Same as above, but with fill=TRUE
  output$champ <- renderInfoBox({
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
  output$lost <- renderInfoBox({
   
    
    #line <-c(18,19,20)
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
    
    infoBox(
     'Relegation', c(loser,",",loser1,",",loser2), icon = icon('window-close'),
      color = 'red', fill = TRUE
    )
  })
  
  
### for the team wins/draws/losses chart
  output$team_results <- renderHighchart({
  #seen like you have to do data.frame() in order for highchart() to work  
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
      hc_subtitle(text = 'Top performing teams have median Age between (24-27) and median Rating of 80 or greater',
                  stype = list(fontWeight = 'bold'), align = 'center') %>%
      hc_add_series_boxplot(x = boxplot$Age, by = boxplot$club, name = "Age") %>%
      #hc_yAxis(plotLines = list(plotline)) %>% 
      hc_add_series_boxplot(x = boxplot$Overall, by = boxplot$club, name = 'Overall Rating')
  
  })
  

  
  
  ########### unique player in one year and not the other ##########
  output$team_year <- renderDataTable({
    
   unique_players <- find_new_players(input$the_year, input$the_team)
   
  #browser()
   
   with_players %>% 
     filter( season == input$the_year & Name %in% unique_players) %>% 
     select(Name, Nationality, Age, Position, Overall)
   
  



  })
  
  
  
  
 
  
  
}

















  