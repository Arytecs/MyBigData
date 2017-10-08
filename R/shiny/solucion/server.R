library(shiny)
library(ggmap)
datval<-read.csv("http://mapas.valencia.es/lanzadera/opendata/tra_espiras_p/CSV",sep=";")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
 # output$value <- renderPrint({ input$num })
  
  output$distPlot <- renderPlot({
   # valencia <- get_map(location = 'valencia', zoom = input$bins)
    lat<- input$lat
    lon<- input$lon
    valencia <- get_map(location =c(lon=lon,lat=lat) , zoom = input$bins)
    #datval<-read.csv("/home//cesar/Dropbox/Docencia/R/mapas/traf_valencia.csv",sep=";")
    # contamos frecuencia de horas
    frecs<-table(as.character(datval[,"hora_actualizacion"]))
    #y seleccionamos la mayor
    pos<-which (frecs==max(frecs))
    hora<-names(pos)
    
    mi_tit<-paste("datos:", max(as.character(datval[,"fecha_actualizacion"])),hora)
    datvalf<-datval[complete.cases(datval),]
    ggmap(valencia) + geom_point(data = datvalf, aes(x = X, y = Y, alpha = ih),
                                 colour = input$col) + theme(axis.title.y = element_blank(), axis.title.x = element_blank())+labs(title=mi_tit)
  })
})