#Ejercicio 1
x1<-1:12
x1
#Ejercicio 2
x2<-rep(c(6,2,4),4)
x2
#Ejercicio 3
x3<-matrix(c(rep(9,6), rep(2,5), rep(5,4)), 5,3, byrow = TRUE)
x3
#Ejercicio 4
x4<-rnorm(20)
set.seed(50) #Un azar controlado
mean(x4)
median(x4)
var(x4)
sd(x4)
#Ejercicio 5
#a)
students<-read.table(file = "data1.txt")
#b)
names(students)<-c("height", "shoesize", "gender", "population")
students
#d)
names(students)
#e)
students["height"]
#f)
levels(students$gender)
genderDist<-c(sum(students$gender == "female"), sum(students$gender == "male"))
genderDist
populationDist <- c(sum(students$population == "kuopio"), sum(students$population == "tampere"))
populationDist
#g)
gd<-matrix(c(genderDist, populationDist), 2, 2)
rownames(gd)<-c("female", "male")
colnames(gd)<-c("kuopio","tampere")
gd
gdt<-as.data.frame(gd)
gdt
#h)
femaleSet<-subset(students,gender=="female")
femaleSet
maleSet<-subset(students,gender=="male")
maleSet
students[students$gender == "female",]
students[students$gender == "male",]
students
#i)
media<-mean(students$height)
students[students$height < media,]
students[students$height > media,]
subset(students, height < media)
subset(students, height > media)

#j)
