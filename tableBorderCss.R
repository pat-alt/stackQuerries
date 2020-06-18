shinyApp(
  
  # --- User Interface --- #
  
  ui = fluidPage(
    
    # The below now creates a custum css class. 
    tags$head(
      tags$style(HTML("
      .my_table .table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
        padding: 8px;
        line-height: 1.42857143;
        vertical-align: top;
        border-top: 3px solid blue; 
      }
    "))
    ),
    
    mainPanel(
      h3("Custom style table:"),
      tags$div(
        class="my_table", # set to custom class
        tableOutput("custom_table")
      ),
      h3("Default style table:"),
      tableOutput("default_table"), # No class assigned
      h3("Another default style table:"),
      tableOutput("another_default_table") # No class assigned
    )
    
  ),
  
  # --- Server logic --- #
  
  server = function(input, output) {
    output$custom_table <- renderTable({  #
      df <- head(mtcars)
    })
    
    output$default_table <- renderTable({  #
      df <- head(iris)
    })
    
    output$another_default_table <- renderTable({  #
      df <- head(cars)
    })
  }
  
)