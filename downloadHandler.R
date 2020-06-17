library(shiny)

ui = fluidPage(
  
  sidebarPanel(
    actionButton(inputId = "uploadCsv", label = "Upload CSV:", icon = icon("upload")),
    selectInput(inputId = "preProc", label = "Pre-processing", choices = c("Mean"=1,"Sum"=2)),
    downloadButton("downloadData", label = "Download table")
  ),
  
  mainPanel(
    h4("My table:"),
    tableOutput("contents")
  )
  
)

server <- function(input, output) {
  
  rvals <- reactiveValues(
    csv=NULL,
    x=NULL
  )
  
  observeEvent(input$uploadCsv,{
    rvals$csv <- mtcars # using example data since I don't have your .csv
    # rvals$csv <- read.csv(input$file_1$datapath, header = TRUE) 
    #some data processing here
  })
  
  output$contents <- renderTable({
    # Assuing the below are functions applied to your data
    req(
      input$preProc,
      !is.null(rvals$csv)
    )
    if(input$preProc == 1){
      rvals$x <- data.frame(t(colMeans(mtcars)))
    }else {
      rvals$x <- data.frame(t(colSums(mtcars)))
    }
    
    return(rvals$x)
    
  },digits = 4)
  
  output$downloadData <- downloadHandler(
    filename = "myFile.csv",
    content = function(file){
      write.csv(rvals$x, file)
    }
  )
}

shinyApp(ui,server)