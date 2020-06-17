library(shiny)

county.name = lapply(
  1:length(state.name),
  function(i) {
    sprintf("%s-County-%i",state.abb[i],1:5)
  }
)
names(county.name) = state.name

shinyApp(
  
  # --- User Interface --- #
  
  ui = fluidPage(
    
    sidebarPanel(
      selectInput(inputId = "state", label = "Choose a state:", choices = state.name),
      uiOutput("county")
    ),
    
    mainPanel(
      textOutput("choice")
    )
    
  ),
  
  # --- Server logic --- #
  
  server = function(input, output) {
    output$county = renderUI({
      req(input$state) # this makes sure Shiny waits until input$state has been supplied. Avoids nasty error messages
      selectInput(
        inputId = "county", label = "Choose a county:", choices = county.name[[input$state]] # condition on the state
      )
    })
    
    output$choice = renderText({
      req(input$state, input$county)
      sprintf("You've chosen %s in %s",
              input$county,
              input$state)
    })
  }
  
)