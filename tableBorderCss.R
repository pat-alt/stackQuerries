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
      tags$div(
        class="my_table", # set to custom class
        tableOutput("retail_dashboard_ratios_table")
      ),
      tableOutput("another_table")
    )
    
  ),
  
  # --- Server logic --- #
  
  server = function(input, output) {
    output$retail_dashboard_ratios_table <- renderTable({  #
      df <- head(mtcars)
    })
    
    output$another_table <- renderTable({  #
      df <- head(iris)
    })
  }
  
)