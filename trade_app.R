library(shiny)


#Define user input function
ui <- fluidPage(
  #sidebar layout with input and output definitions
  sidebarLayout(
    #input: select variables to plot
    sidebarPanel(
      
      # JRL --> Add a country selection box
      # Select education levels -------------------------------------
      checkboxGroupInput(inputId = "countries",
                         label = "Select Countries:",
                         choices = unique(Trade_SSA$Country),
                         selected = "India"),
      
      # Horizontal line for visual separation -----------------------
      hr(),
      
      
    #select variables for y axis
 
    #selectInput(inputId = "y",
    #            label = "Country:", 
    #            choices = c(Trade_SSA$Country),
    #            multiple = TRUE,
    #            selected = "India"),
    
    #select variable for x axis
    sliderInput(inputId = "x",
                label="Select Time Period:",
                min=1992, max= 2016,
                value = c(1999, 2005),
                step=1)
    ),
    #output: show line chart
    mainPanel(
      plotOutput(outputId = "linechart")
    )
  )
)

#define server function
server <- function(input, output) {
  
  # Create a subset of data filtering for selected countries ------
  Trade_subset <- reactive({
    req(input$countries) # # JRL --> Reactivity is set here
    filter(Trade_SSA, Country %in% input$countries)  # JRL --> filtering is set by the user input in line 52
  })
  
  # create the line chart object that plotOutput is expecting
  output$linechart <- renderPlot({
   # ggplot(data=Trade_SSA, aes_string(x=input$x, y=input$y))
    ggplot(data = Trade_subset(), aes(x=Years, y=Trade_Value)) + # JRL data from subset data: lines 48-51
    geom_line(aes(group = Country, color = Country), size =1) 
  })
}

#Create rhe shiny app object
shinyApp(ui=ui, server=server)