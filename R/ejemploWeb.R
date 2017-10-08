
dat.csv <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")
nrow(dat.csv) #Elementos
dim(dat.csv)
length(dat.csv[,1])

dat.csv #No usar esto para verlo porque puede que tengamos muchos datos
dat.csv[1:10,]
head(dat.csv)
colnames(dat.csv)

dat.csv[1:2,]
dat.csv[1:10,2]
dat.csv[1:10,"female"]
dat.csv$female[1:10]
dat.csv[c(1,3,5),1]
dat.csv[1, c("female", "prog", "socst")]
write.csv(dat.csv, file = "/filename.csv")
d <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")
dim(d)
str(d)
plot(d)

pdf("cor.pdf") #Para los próximos plots se guarden en pdf
plot(d[,c("write", "math")])
plot(d[,c("read", "math")])
dev.off() #Para cerrar el pdf


plot(lm(write ~ read, data=d), ask=F)
methods(plot)
summary(d)

by(d[, 7:11], d$prog, colMeans)
colMeans(d[,7:11])
install.packages("ggplot2")
require("ggplot2")
ggplot(d, aes(x = write)) + geom_histogram()
ggplot(d, aes(x = math)) + geom_histogram()
ggplot(d, aes(x = 1, y = math)) + geom_boxplot()


xtabs( ~ female, data = d)
xtabs( ~ race, data = d)
xtabs( ~ prog, data = d)
xtabs( ~ ses + schtyp, data = d)
(tab3 <- xtabs( ~ ses + prog + schtyp, data = d))
cor(d[, 7:11])
ggpairs(d[, 7:11]) #Necesito cargar una librería que no se cual es
d <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")
library(dplyr)
d <- arrange(d, female, math) #Ordena primero por female, y luego por math
head(d)

d <- mutate(d,
            id = factor(id),
            female = factor(female, levels = 0:1, labels = c("male", "female")),
            race = factor(race, levels = 1:4, labels = c("Hispanic", "Asian", "African American", "White")),
            schtyp = factor(schtyp, levels = 1:2, labels = c("public", "private")),
            prog = factor(prog, levels = 1:3, labels = c("general", "academic", "vocational"))
)
head(d)
summary(d)
#Añadir dos columnas nuevas. Una la nota total, y otro que sea una visgerización de las variables
d <- mutate(d,
            total = read+write+math+science,
            grade = cut(total,
                        breaks = c(0, 140, 180, 210, 234, 300),
                        labels = c("F", "D", "C", "B", "A"))
)
summary(d[, c("total", "grade")])



#EJERCICIOS
#1
females <-subset(d, female="female")
summary(females["math"])
by(d[,8:9], d$female, colMeans)
head(d)
#2
which.max(by(d[,7:11], d$id, rowMeans))
#3
7 y 8
subset(d[,7:8], c(d$female=="female", d$race=="Asian"))
by(d[,7:8], d$female, rowMeans)
females<-filter(d, female == "female")
asians<-filter(d, race=="Asian")
asians
v<-merge(females,asians, by="id")
colMeans(v[,c("read.x", "write.y")])
#Solucion cesar
colMeans(subset(d, female=="female" & race=="Asian")[,c("read","write")])

#4
average<-rowMeans(d[,7:11])
d<-cbind(d,average)
lista<-by(d[,c("average")], list(d$race,d$female), mean)
mivec<-unlist(lista)
sort(mivec[seq(1, length(mivec), 2)])
