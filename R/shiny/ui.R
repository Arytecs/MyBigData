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
                      "Amarillo"="yellow"))
    ),
      # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
  
))