library(shiny)
library(shinydashboard)
#library(httr)
#library(jsonlite)
#library(DT)
#library(shinyjs)
#library(stringr)
#library(shinyalert)
#library(shinyWidgets)

ui <- dashboardPage(
  skin = "blue",
  title = "Shiny Test",
  dashboardHeader(
    title = h3("Shiny Test", style="font-style: bold; align : top;"),
    titleWidth = "97%"
    
  ),
  dashboardSidebar(
    HTML('<center><img src="JKEBankLogonew.png" width="240"></center>'),
    br(),
    tags$hr(),
    sidebarMenu(
      menuItem(strong("Test"), tabName = "dashboard1", icon = icon("file-invoice-dollar"),badgeColor = "green")
    ),
    tags$hr(),
    br(),
    HTML('<center><font size="2"><b>This portal is a containerized shiny R application that consumes APIs from Mainframe CICS and integrates with other APIs. <a href="https://www.ibm.com/support/knowledgecenter/SSYMRC_5.0.2/com.ibm.help.common.jazz.calm.doc/topics/s_mtm_sample.html" target=_blank>JKE Banking</a> example project is shipped with Rational CLM.</b></font><width="150"></center>'),
    br(),
    HTML('<center><font size="2"><b>For more info, contact</b></font><width="150"></center>'),
    HTML('<center><font size="2"><b><a href="mailto:shami.gupta@in.ibm.com">Shami Gupta</a></b></font><width="150"></center>'),
    br()
  ),
  dashboardBody(
    tags$img(
      src = "Banking1.jpg",
      hspace = 0,
      vspace = 0,
      width = '86.5%',height = '91%',
      style = 'position: absolute '
    ),
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "United.css")
    ),
    tags$head( 
      tags$style(HTML(".main-sidebar { font-size: 16px; }")) #change the font size to 20
    ),
    tags$style(HTML("
        input[type=number] {
          -moz-appearance:textfield;
        }
        input[type=number]::{
          -moz-appearance:textfield;
        }
        input[type=number]::-webkit-outer-spin-button,
        input[type=number]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
        }"
      )
    ),
    tags$head(
      tags$style(HTML(
        '.box.box-solid.box-primary{border-bottom:none;border-left:none;border-right:none;border-top:none;}',
        '.box.box-solid.box-success{border-bottom:none;border-left:none;border-right:none;border-top:none;}',
        '.box.box-solid.box-danger{border-bottom:none;border-left:none;border-right:none;border-top:none;}',
        '.box.box-solid.box-warning{border-bottom:none;border-left:none;border-right:none;border-top:none;}',
        '.content-wrapper, .right-side {background-color: darkcyan;}',
        '.box.box-solid.box-primary>.box-header {
            background:rgba(0, 0, 54 ,0);
            background-image: linear-gradient(to right,rgba(0, 0, 139 ,1), rgba(0, 0, 139 ,0));
        }',
        '.box.box-solid.box-success>.box-header {
            background:rgba(20, 90, 50 ,0);
            background-image: linear-gradient(to right,rgba(20, 90, 50 ,1), rgba(20, 90, 50 ,0));
        }',
        '.box.box-solid.box-danger>.box-header {
            background:rgba(120, 40, 31 ,0);
            background-image: linear-gradient(to right,rgba(120, 40, 31 ,1), rgba(120, 40, 31 ,0));
        }',
        '.box.box-solid.box-warning>.box-header {
            background:rgba(126, 81, 9  ,0);
        background-image: linear-gradient(to right,rgba(126, 81, 9 ,1), rgba(126, 81, 9 ,0));
        }',
        '.box.box-solid.box-primary{
            background: linear-gradient(to right,rgba(174, 214, 241 ,1), rgba(174, 214, 241 ,0));
        }',
        '.box.box-solid.box-success{
            background: linear-gradient(to right,rgba(130, 224, 170 ,1), rgba(130, 224, 170 ,0));
        }',
        '.box.box-solid.box-danger{
            background: linear-gradient(to right,rgba(241, 148, 138 ,1), rgba(241, 148, 138 ,0));
        }',
        '.box.box-solid.box-warning{
            background: linear-gradient(to right,rgba(248, 196, 113 ,1), rgba(248, 196, 113 ,0));
        }'
        )
      )
    ),
    br(),
    tabItems(
      tabItem(tabName = "dashboard1",
              box (
                title = span(icon("edit","fa-2x"),strong("Test Information")), status = "success", width = 12,solidHeader = TRUE,collapsible=FALSE, 
                fluidRow(
                  column(2, actionButton("myTestButton", label = h4("Click me",style="font-weight: bold; color: yellow"),width='100%',style="background-color: darkgreen"))
                ),
                br(),
                br(),
                br(),
                fluidRow(
                  column(6,h2(strong(textOutput("myTestButton_message"),style="font-style: bold; color: darkblue; align:bottom")))
                )
              )
    )
  )
)
)

options(shiny.maxRequestSize = 9*1024^2)

server <- shinyServer(function(input, output) {

  output$myTestButton_message <- renderText({
    return(paste("Button clicked ",input$myTestButton," times",sep=""))
  })
  
    
})

shinyApp(ui = ui, server = server)