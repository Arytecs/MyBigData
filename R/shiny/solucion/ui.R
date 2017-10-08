library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tráfico en Valencia"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Zoom:",
                  min = 1,
                  max = 20,
                  value = 13),
      radioButtons("col", "Color:",
                   c("Rojo" = "red",
                      "Verde"="green",
                     "Negro"="black"  ,
                      "Amarillo"="yellow")),
      
      numericInput("lat", label = h3("Lat"), value = 39.475,step=0.01),
      
      numericInput("lon", label = h3("Lon"), value = -0.38,step=0.01)
      
    ),
      # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
  
))