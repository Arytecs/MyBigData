file<-"estacion_1_2011_2014.csv"
dat<-read.csv(file,sep=";")
head(dat)
str(dat)
numrows<-length(dat[,1])

print("num days")
print (numrows/24)

print("fecha inicial")
dat[1,2]

print("fecha final")
dat[numrows,2]

#Convertimos a fecha
as.Date(dat[1,2])
diasem<-as.POSIXlt(as.Date(dat[,2]))$wday #Mete el día de la semana

diasem[which(diasem==0)]<-7 #Al 0 le ponemos 7 (porque era el domingo)
unique(diasem)

dat$diasem<-diasem
head(dat)

xhoradia<-by(dat[,c("avg_available","med_available")],list(dat$hour,dat$diasem),colMeans)
xhora<-by(dat[,c("avg_available","med_available")],dat$hour,colMeans)
head(xhora)
xhora

#deshacemos la lista, tomando sólo avg_available
xhora<-unlist(xhora)[seq(1,48,2)] #Hay 48 porque hay dos variables, pero solo quiero una que está en las posiciones pares
xhora


xhoradia<-unlist(xhoradia)[seq(1,336,2)]
xhoradia

#trasnformo xhoradia matriz dia*hora
mhoradia<-matrix(xhoradia,24,7)
mhoradia

#imprime xhora, type=l es una linea, main=titulo
plot(xhora,lty=1,type="l", ylab="Free Bicycles", xlab="hours",xlim=c(0,24),main="Guillem de Castro. Day Average",col="red")

plot(mhoradia[,1],lty=1,type="l", ylab="Free Bicycles", xlab="hours", ylim=c(1,10), col=1,xlim=c(0,24),main="Day Average ")

for ( i in 2:7)
{
  #Me añade una linea sobre el plot existente
  lines(mhoradia[,i], lty=i,col=i,xlim=c(0,24),main="Guillem de Castro.01/01/2014-31/05/2014. Day Average ")          
}
legend('top',c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"), col=c(1:7), lty=1:7,cex=0.8)


#EJERCICIOS
#1-Cuál es el día con menos bicicletas libres?
head(dat)
xdia<-by(dat[, "avg_available"], dat$diasem, mean)
which.min(xdia)
##El día no de la semana
dat$fecha<-as.Date(dat[,2])
xfecha<-by(dat[, "avg_available"], dat$fecha, mean)
which.min(xfecha)
####El día con menos bicis libres es el sábado

#2-Cuál es el día con más bicicletas libres?
which.max(xdia)
which.max(xfecha)
####El día con más biciletas libres es el jueves

#3-Cuál es el mes con menos bicicletas libres?
months<-strftime(as.Date(dat[,2]), "%m")
dat$month<-months
head(dat)

xmonth<-by(dat[,"avg_available"], dat$month,mean)
which.min(xmonth)
####El mes con menos bicis libres es Marzo

#4-Cambia el uso de la estación entre verano e invierno?
esVerano<-ifelse(format(as.Date(dat[,2]), "%m-%d") >= "06-21" & format(as.Date(dat[,2]), "%m-%d") < "09-21", TRUE, FALSE)
head(esVerano)
dat$esVerano<-esVerano
esInvierno<-ifelse(format(as.Date(dat[,2]), "%m-%d") >= "12-21" & format(as.Date(dat[,2]), "%m-%d") < "03-21", TRUE, FALSE)
dat$esInvierno<-esInvierno
head(dat)
mean(diasVerano$avg_available)
diasInvierno<-subset(dat, esInvierno==T, c(date,avg_available))
mean(diasInvierno$avg_available)
par(mfrow=c(2,1))
plot(diasVerano, main="Dias de Verano", xlab="Dias", ylab="Bicis Disponibles")
plot(diasInvierno, main="Dias de Invierno",xlab="Dias", ylab="Bicis Disponibles")
plot(dat$date, dat$avg_available)

#5-Afectan las fallas al comportamiento de la estación?
#Casualmente es el mes con menos bicis disponibles en la estación, por lo que si estudiamos el mes sí que afecta. 
#Si ahora estudiamos por días:
esFallas<-ifelse(format(as.Date(dat[,2]), "%m-%d")>"03-13" & format(as.Date(dat[,2]), "%m-%d")<"03-20", TRUE, FALSE)
head(esFallas)
dat$esFallas<-esFallas
head(dat)
diasFallas<-subset(dat, esFallas==TRUE, c(date,avg_available))
diasFallas
dat[1612,]
diasNoFallas<-subset(dat,esFallas==FALSE, c(date,avg_available))
dim(dat)
dim(diasFallas)
dim(diasNoFallas)
nrow(diasFallas) + nrow(diasNoFallas)
plot(c(diasFallas,diasNoFallas))
par(mfrow=c(2,1))
plot(diasFallas, main="Dias de Fallas", xlab="Dias", ylab="Bicis Disponibles")
plot(diasNoFallas, main="Dias que no son Fallas",xlab="Dias", ylab="Bicis Disponibles")
mean(diasFallas$avg_available)
mean(diasNoFallas$avg_available)
plot(by(diasFallas[,"avg_available"], diasFallas$date, mean))
