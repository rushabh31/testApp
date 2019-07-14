library(shiny)
library(shiny.semantic)

ui <- basicPage(
  titlePanel("testApp mainpage"),
  
  sidebarLayout(
    sidebarPanel(h4("Select input params:"),
                 fileInput("file1", "Upload data file (csv/txt/tsv):",
                           accept = c(
                             "text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")
                 ),
                 selectInput(inputId = "selectX", label = "Select X-axis variable:", choices = ''),
                 selectInput(inputId = "selectY", label = "Select Y-axis variable:", choices = '')
                 ),
    mainPanel("Resulting Data with Plot",
              tableOutput("tabout"))
    
  ) # end of sidebarLayout
  
) # end of ui

server <- function(input, output,session) {
  
  data <-  reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    # read table
    read.csv(inFile$datapath) 
    
  })
  
  # to update selectInputs
  observeEvent(data(), {
    updateSelectInput(session, inputId = "selectX", choices=colnames(data()))
    updateSelectInput(session, inputId = "selectY", choices=colnames(data()))
  })
 
  # showing table (sanity check!)
  output$tabout <- renderTable({

    if(is.null(data())){
      return()
    }
    data()
  })
  
  
}# end of server

runApp(list(ui = ui, server = server))