library(shiny)
library(shinyWidgets)

list1 = letters[1:3]
list2 = letters[4:6]
list3 = letters[7:9]
list4 = letters[10:12]

ui <- fluidPage(
  titlePanel("Dynamic Boxes"),
  fluidRow(
    prettyRadioButtons("check1", "Please Pick", c("Option 1" = "op1", "Option 2" = "op2"), selected=character(0), shape="square", outline = T, inline = T),
    checkboxGroupInput("check2", "Please Pick", c("Option 3" = "op3", "Option 4" = "op4"), inline = T),
    uiOutput("select")
  )
)


server <- function(input, output){
  
  output$select = renderUI({
    
    req(input$check1) 
    
    if (input$check1 == 'op1') {
      selectInput('select_1', 'No.1 Select',choices = list1)
    } 
    else if (input$check1 == 'op2') {
      req(input$check2)
      if (length(input$check2) == 1) {
        if(input$check2 == 'op3') {
          selectInput('select_2', 'No.2 Select',choices = list2)
        }
        else if (input$check2 == 'op4') {
          selectInput('select_3', 'No.3 Select',choices = list3)
        }
      } 
      else if(length(input$check2) == 2){
        selectInput('select_4', 'No.4 Select',choices = list4)
      }
    }
  })
  
}

shinyApp(ui, server)


# Continuing from above ----
ui <- fluidPage(
  titlePanel("Dynamic Boxes"),
  fluidRow(
    prettyRadioButtons("check1", "Please Pick", c("Option 1" = "op1", "Option 2" = "op2"), selected=character(0), shape="square", outline = T, inline = T),
    uiOutput("check2"),
    uiOutput("select")
  )
)


server <- function(input, output) {
  
  output$check2 = renderUI({
    req(input$check1)
    if (input$check1=='op2') {
      prettyRadioButtons("check2", "Please Pick", 
                         c("Option 2.1" = "op3", "Option 2.2" = "op4", "Option 2.3" = "op5"), 
                         selected=character(0), shape="square", outline = T, inline = T)
    }
  })
  
  output$select = renderUI({
    req(input$check1) 
    if (input$check1 == 'op1') {
      selectInput('select_1', 'No.1 Select',choices = list1)
    } 
    else if (input$check1 == 'op2') {
      req(input$check2)
      if (input$check2 == 'op3') {
        selectInput('select_2', 'No.2 Select',choices = list2)
      } else if (input$check2== 'op4') {
        selectInput('select_3', 'No.3 Select',choices = list3)
      } else {
        selectInput('select_4', 'No.4 Select',choices = list4)
      }
    }
  })
  
}

shinyApp(ui, server)

