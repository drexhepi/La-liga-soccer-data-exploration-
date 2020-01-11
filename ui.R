#what the user sees

# 
# fluidPage(
#   actionButton(inputId = 'clicks',
#                label = 'click me'),
#   
#   sliderInput(inputId = 'num',
#               labe = 'choose a number',
#               value = 25, 1,100),
#   
#   actionButton(inputId = 'go',
#                label = 'Update'
#                ),
#   
#   textInput(inputId = 'title',
#             label = 'write a title',#this makes an empty box that allows user
#             #to change the title if they want. however, the app always starts
#             #with this title below 'histogram of Random Normal Values'
#             value = 'histogram of Random Normal Values'),
#   plotOutput('hist'),#this adds the space in the app for the graphs. 
#   #however it does not run anything. to run is you have to call in in
#   #the server.R by calling output$hist
#   verbatimTextOutput('stats')
# )

dashboardPage(skin = 'yellow',
  ######HEADER##########            
  dashboardHeader(title = "LaLiga Soccer Data"
                  
                  ),
  
  ######SIDEBAR########
  dashboardSidebar(
    div(a(href = 'https://www.laliga.com/en-GB', img(src = 'spain.jpg',width = 140, height = 70))),
    sidebarMenu(id = 'menu',
      menuItem('Home', tabName = 'Home', icon = icon('home')),
      menuItem('Introduction', tabName = 'Introduction', icon = icon('futbol')),
      menuItem('League Table', tabName = 'League_Table', icon = icon('table')),
      menuItem('Overview',tabName = 'Overview', icon= icon('address-card')),
      menuItem('info box', tabName = 'info', icon = icon('cookie')),
      #menuItem('value box', tabName = 'value', icon = icon('chess')),
      menuItem('layout', tabName = 'layout', icon = icon('hourglass-start')),
      menuItem ('column layout', tabName = 'column', icon = icon('apple'))
    ),
    ###this adds tabs inside each menuItem
    conditionalPanel(condition = "input.menu == 'League_Table'",
                     selectInput("year", label = "Select Season:", choices = years,
                                 selected = 2010))#,
    
    # conditionalPanel(condition = "input.menu == 'Overview'",
    #                  selectInput('result', label = 'Select Year:', choices = years,
    #                              selected = 2012))
                    
  ),
  
  #########BODY#########
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Home",
              
              #img(src = "fun_soccer.jpg"),
              #setBackgroundImage(src = "fun_soccer.jpg"),
               tags$img(
                src ='laliga.jpg', #"fun_soccer.jpg",
                style = 'position: absolute',
                width = 1000,
                height = 600,
                position= 'center'
             
                
              ),### this puts the picture in the background 
              #img(src="src", height="50%", width="50%", align="right")
            # column(5,offset = 3, headerPanel('The Beautiful Game', windowTitle = 'The Beautiful Game'))
            
                # fluidRow(
                #   box(plotOutput("plot1", height = 200)),
                # 
                #   box(
                #     title = "Controls",
                #     sliderInput("slider", "Number of observations:", 1, 100, 50)
                #   )
                # )
      ),
      
      # Second tab content
      tabItem(tabName = "Introduction",
              h2("An Analysis of LaLiga Teams Performance"),
              h5('This app explores 47 years of soccer data from arguably the greatest league in the world: LaLiga, which is the most competitive league in spain.'),
              h5('The dataset is then broken down from 2007-2017, which also contains indivudial player data.\n\n'),
              h6('If interested on the website where the data was scraped from, please click on link below:'),
              h6(a(href = 'https://sofifa.com', img(src = 'fifa.jpg',width = 100, height = 50)))
              
              
              
              
      ),
      
      # Third tab content
      tabItem(tabName = 'League_Table',
              #h2('Final Table for The _____ Season'),
              fluidRow(
                
                #infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                infoBoxOutput("champ"),
                infoBoxOutput("lost")
              ),
              
              
              
               fluidRow(
               
                 
                   box(width = 10, gt_output(outputId = "table"))
                 
                 # box(title = 'Dibran',background = 'black', #status = 'primary',
                 #     solidHeader = TRUE,collapsible = TRUE,plotOutput("plot1", height = 250)),
                 # 
                 # box(#status = pirmary or warning just adds a highlighted color i.e. status='primary'
                 #   title = "Rexhepi",status = 'warning',solidHeader = TRUE,
                 #   'Box content here', br(), 'More box content',
                 #   sliderInput("slider", "Number of observations:", 1, 100, 50),
                 #   textInput('text', 'Text input:')
                 # )
               )
              
              
      
              
              
              
              
              
              ),
      # fourth tab
      tabItem(tabName = 'Overview',
              fluidRow(
                tabBox(
                  #title = "First tabBox",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1",width = 10,
                  tabPanel("Results", highchartOutput('team_results'),#,#,width = '10',height = '450px'),
                           # selectInput("year", label = "Select Season:", choices = years,
                           #             selected = 2010)
                           selectInput('result', label = 'Select Year:', choices = years,
                                       selected = 2012),
                           highchartOutput('goals')
                           
                           
                           
                           
                           
                           
                           
                           ),
                  tabPanel("Position",highchartOutput('compare'),
                           selectInput("team", label = "Select Team:", choices = team,
                                       selected = 'Real Madrid',multiple = TRUE),
                           
                           highchartOutput('winners_total')
                           )
                  
                  
                          
                  #highchartOutput('team_results') 
                                           #height = '450px')
                )
                # tabBox(
                #   side = "right", height = "250px",
                #   selected = "Tab3",
                #   tabPanel("Tab1", "Tab content 1"),
                #   tabPanel("Tab2", "Tab content 2"),
                #   tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
                # )
              )#,
              # fluidRow(
              #   tabBox(
              #     # Title can include an icon
              #     title = tagList(shiny::icon("gear"), "tabBox status"),
              #     tabPanel("Tab1",
              #              "Currently selected tab from first box:",
              #              verbatimTextOutput("tabset1Selected")
              #     ),
              #     tabPanel("Tab2", "Tab content 2")
              #   )
              # )
       ),
      #fifth tab
      tabItem(tabName = 'info',
              
              # infoBoxes with fill=FALSE
              fluidRow(
                # A static infoBox
                infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
                # Dynamic infoBoxes
                infoBoxOutput("progressBox"),
                infoBoxOutput("approvalBox")
              ),
              
              # infoBoxes with fill=TRUE
              fluidRow(
                infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                infoBoxOutput("progressBox2"),
                infoBoxOutput("approvalBox2")
              ),
              
              fluidRow(
                # Clicking this will increment the progress amount
                box(width = 4, actionButton("count", "Increment progress"))
              ) 
              
              
              ),
      
      #sevnth tab
      tabItem(tabName = 'layout',
              fluidRow(
                box(title = 'Box title', 'Box content'),
                box(status = 'warning', 'Box content')
              ),
              fluidRow(
                box(
                  title = 'Title 1', width = 4,height = 300, solidHeader = TRUE, status = 'primary','Box content'
                ),
                box(
                  title = 'Title 2', width = 4, solidHeader = TRUE, 'box content'
                ),
                box(
                  title = 'Title 1', width = 4, solidHeader = TRUE, status = 'warning', 'box content'
                )
                
              ),
              
              fluidRow(
                box(
                  width = 4, background = 'black',
                  'a box with a solid black background'
                ),
                box(
                  title = 'title 5', width = 4, background = 'light-blue',
                  'a box with a solid light-blue background'
                ),
                box(
                  title = 'title 6', width = 4, background = 'maroon',
                  'a box with a solid maroon background'
                )
              )
         ),
      
      tabItem(tabName = 'column',
              fluidRow(
                column(width = 4,
                       box(
                         title = "Box title", width = NULL, status = "primary",
                         "Box content"
                       ),
                       box(
                         title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                         "Box content"
                       ),
                       box(
                         width = NULL, background = "black",
                         "A box with a solid black background"
                       )
                ),
                
                column(width = 4,
                       box(
                         status = "warning", width = NULL,
                         "Box content"
                       ),
                       box(
                         title = "Title 3", width = NULL, solidHeader = TRUE, status = "warning",
                         "Box content"
                       ),
                       box(
                         title = "Title 5", width = NULL, background = "light-blue",
                         "A box with a solid light-blue background"
                       )
                ),
                
                column(width = 4,
                       box(
                         title = "Title 2", width = NULL, solidHeader = TRUE,
                         "Box content"
                       ),
                       box(
                         title = "Title 6", width = NULL, background = "maroon",
                         "A box with a solid maroon background"
                       )
                ))
              
              
              
              
              
              
              
              
              
              
              
              
              
              
              )
      
      #sixth tab
      # tabItem(tabName = 'value',
      # #The code to generate these valueBoxes is below. As with the infoBoxes above, some of these 
      # #valueBoxes are static and some are dynamic.
      # fluidRow(
      #   # A static valueBox
      #   valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
      #   
      #   # Dynamic valueBoxes
      #   valueBoxOutput("progressBox"),
      #   
      #   valueBoxOutput("approvalBox")
      # ),
      # fluidRow(
      #   # Clicking this will increment the progress amount
      #   box(width = 4, actionButton("count", "Increment progress"))
      # )
      # 
      # )
     
  )
)

)


