library(ggplot2)
ufo<-read.delim("ufo_awesome.tsv", sep="\t", stringsAsFactors=FALSE,
                header=FALSE, na.strings="")
summary(ufo)
head(ufo)
dim(ufo)
ncol(ufo)
nrow(ufo)
str(ufo)
sum(is.na(ufo[4])) #No hay muchos NA

#Vamos a limpiar los datos
names(ufo)<-c("DateOccurred","DateReported","Location","ShortDescription",
              "Duration","LongDescription")
head(ufo)

#Vamos a cambiar el formato de la fecha, porque de momento es una cadena.
ufo$DateOccurred<-as.Date(ufo$DateOccurred, format="%Y%m%d")
sum(is.na(ufo$DateOccurred))
#Hay NA por lo que la conversión falla. CUIDADO CON LA NUEVA VERSIÓN
# Que lo que ocurre es que te mete NA y no te falla
head(ufo[which(nchar(ufo$DateOccurred)!=8 | nchar(ufo$DateReported)!=8),1])
nchar(ufo$DateOccurred) #Nos dice la cantidad de chars
#Solución drástica ante el problema, nos cargamos esos registros
good.rows<-ifelse(nchar(ufo$DateOccurred)!=8 | nchar(ufo$DateReported)!=8,FALSE, TRUE)
length(which(!good.rows))

ufo<-ufo[good.rows,] #NOS LOS CARGAMOS
#Intentamos volver a convertirlo
ufo$DateOccurred<-as.Date(ufo$DateOccurred, format="%Y%m%d")
#ufo$DateReported<-as.Date(ufo$DateReported, format="%Y%m%d")
summary(ufo)
str(ufo)

#Creamos función que lo que hace es intentar extraer la localidad y el estado de un avistamiento
get.location<-function(l) {
  split.location<-tryCatch(strsplit(l,",")[[1]], error= function(e) return(c(NA, NA)))
  clean.location<-gsub("^ ","",split.location)
  if (length(clean.location)>2) {
    return(c(NA,NA))
  }
  else {
    return(clean.location)
  }
}

get.location(ufo[1,3])
city.state<-lapply(ufo$Location, get.location)
head(city.state)

#Vamos a incorporar esta información en la tabla
location.matrix<-do.call(rbind, city.state)
head(location.matrix)
ufo<-transform(ufo, USCity=location.matrix[,1], USState=tolower(location.matrix[,2]),
               stringsAsFactors=FALSE)
head(ufo)
summary(ufo)

#Vamos a marcar como NA los estados que no pertenezcan a estados unidos
unique(ufo[,"USState"])
ufo[which(ufo$USState == "alicante (spain)"),] #Curiosidad
us.states<-c("ak","al","ar","az","ca","co","ct","de","fl","ga","hi","ia","id","il",
             "in","ks","ky","la","ma","md","me","mi","mn","mo","ms","mt","nc","nd","ne","nh",
             "nj","nm","nv","ny","oh","ok","or","pa","ri","sc","sd","tn","tx","ut","va","vt",
             "wa","wi","wv","wy")
head(match(ufo$USState, us.states)) #Me devuelve el índice donde se encuentra en el vector us.states
ufo$USState<-us.states[match(ufo$USState,us.states)] #Los que no están en us.states les coloca un NA
ufo$USCity[is.na(ufo$USState)]<-NA
ufo.us<-subset(ufo, !is.na(USState))
head(ufo.us)

summary(ufo.us$DateOccurred)
ggplot(ufo.us, aes(x=DateOccurred))+geom_histogram()
ggplot(ufo.us, aes(x = 1 , y= DateOccurred)) + geom_boxplot()
ufo.us<-subset(ufo.us, DateOccurred>=as.Date("1990-01-01"))
nrow(ufo.us)
ggplot(ufo.us, aes(x=DateOccurred))+geom_histogram()


ufo.us$YearMonth<-strftime(ufo.us$DateOccurred, format="%Y-%m")
require (plyr)
#Coge todo el dataset y lo agrupa por el estado y por el yearmonth, y me cuenta el número de ocurrencias
sightings.counts<-ddply(ufo.us,.(USState,YearMonth), nrow)
head(sightings.counts)
max(sightings.counts["V1"])

#Creamos una secuencia desde la mínima fecha hasta la máxima mes a mes
date.range<-seq.Date(from=as.Date(min(ufo.us$DateOccurred)),
                     to=as.Date(max(ufo.us$DateOccurred)), by="month")
head(date.range)
date.strings<-strftime(date.range, "%Y-%m")
head(date.strings)

#Coge todas las fechas y se la pone en todos los estados.
states.dates<-lapply(us.states,function(s) cbind(s,date.strings))
head(states.dates)
states.dates<-data.frame(do.call(rbind, states.dates), stringsAsFactors=FALSE)


#Unificamos las tablas que me cuenta las vistas por mes y estado con la nueva que hemos creado
all.sightings<-merge(states.dates,sightings.counts,by.x=c("s","date.strings"),
                     by.y=c("USState","YearMonth"),all=TRUE)
head(all.sightings)
names(all.sightings)<-c("State","YearMonth","Sightings")
#Convertimos a 0 los NA
all.sightings$Sightings[is.na(all.sightings$Sightings)]<-0
all.sightings$YearMonth<-as.Date(rep(date.range,length(us.states)))
all.sightings$State<-as.factor(toupper(all.sightings$State))
summary(all.sightings)
#Representamos

pdf("ufoPlot.pdf")
ggplot(all.sightings, aes(x=YearMonth,y=Sightings))+
  geom_line(aes())+
  facet_wrap(~State,nrow=10,ncol=5)+ #partimos en 50 plots
  theme_bw()+ # tema
  xlab("Time")+ylab("Number of Sightings")
dev.off()


#Tidy Data otra librería para limpiar datos
