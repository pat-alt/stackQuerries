library("shiny")

ui <- fluidPage(
  # The below now creates a custum css class. 
  tags$head(
    tags$style(HTML('
      .my_checkBox_red input[type="checkbox"]:before {
          border: 2px solid;
          color: red;
          background-color: white;
          content: "";
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
      
      .my_checkBox_red input[type="checkbox"]:checked:after {
          border: 2px solid;
          color: red;
          background-color: #ffcccc;
          content: "✓";
          font-size: smaller;
          vertical-align: middle;
          text-align: center;
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
      
      .my_checkBox_blue input[type="checkbox"]:before {
          border: 2px solid;
          color: blue;
          background-color: white;
          content: "";
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
      
      .my_checkBox_blue input[type="checkbox"]:checked:after {
          border: 2px solid;
          color: blue;
          background-color: #ccccff;
          content: "✓";
          font-size: smaller;
          vertical-align: middle;
          text-align: center;
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
      
      .my_checkBox_grey input[type="checkbox"]:before {
          border: 2px solid;
          color: grey;
          background-color: white;
          content: "";
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
      
      .my_checkBox_grey input[type="checkbox"]:checked:after {
          border: 2px solid;
          color: grey;
          background-color: #e6e6e6;
          content: "✓";
          font-size: smaller;
          vertical-align: middle;
          text-align: center;
          height: 15px;
          left: 0;
          position: absolute;
          top: 0;
          width: 15px;
      }
    '))
  ),
  tags$div(
    HTML(
      '<div id="my_cbgi" class="form-group shiny-input-checkboxgroup shiny-input-container">
        <label class="control-label" for="my_cbgi">Choose Something</label>
        <div class="shiny-options-group">
          <div class="my_checkBox_red">
            <div class="checkbox">
              <label>
                <input type="checkbox" name="my_cbgi" value="A"/>
                <span><span style="color: red;">A</span></span>
              </label>
            </div>
          </div>
          <div class="my_checkBox_red">
            <div class="checkbox">
              <label>
                <input type="checkbox" name="my_cbgi" value="B"/>
                <span><span style="color: red;">B</span></span>
              </label>
            </div>
          </div>
          <div class="my_checkBox_blue">
            <div class="checkbox">
              <label>
                <input type="checkbox" name="my_cbgi" value="C"/>
                <span><span style="color: blue;">C</span></span>
              </label>
            </div>
          </div>
          <div class="my_checkBox_grey">
            <div class="checkbox">
              <label>
                <input type="checkbox" name="my_cbgi" value="D"/>
                <span><span style="font-weight: bold;">D</span></span>
              </label>
            </div>
          </div>
        </div>
      </div>'
    )
  ),
  textOutput("choice")
)

server <- function(input, output) {
  output$choice = renderText({
    input$my_cbgi
  })
}

shinyApp(ui = ui, server = server)