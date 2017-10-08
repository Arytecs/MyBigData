a=3+3
print(a)
ls() #--> Muestra las variables que hay guardadas en memoria
getwd() #--> Muestra el directorio de trabajo
setwd() #--> Selecciona el directorio de trabajo
help("setwd") #--> Abre navegador con la ayuda
?setwd #--> Mismo de antes
#PAQUETES
#Comparando con python es más cómodo porque no es necesario tener la password de root
install.packages("ggplot2") #Instala paquete
#Introduction_R.pdf
a<-2
length(a) #Tamaño
typeof(a) #Tipo
Inf+1 #Valor Infinito
Inf/Inf
is.nan(Inf/Inf)
x<-c(1 , 2 , NA , 4 , NA , 5)
y<-c(" a " , NA , NA ," d " ," e " ," f ")
good<-complete.cases(x , y ) #Compara elemento a elemento, y si están los dos, devuelve true, si no devuelve false
good
x[good]
y[good]
#Vectores -> Tienen que ser del mismo tipo
a<-c(4,"hola")
a[0]
a[1]
a[2]
typeof(a)
as.numeric(a) #Devuelve error por coerción
b<-c(1,2)
b
as.character(b)

v<-c(2,3,4,6,8,1)
#Le añadimos un elemento
v<-c(v,5)
sum(v) 
mean(v)
v+1
v/2
v[1] #--> Los vectores empiezan por 1, no por 0
v[1:3]
v[-1]
max(v)
min(v)
median(v)
sort(v)
v
pet<-c("cat" ,"dog" ,"dog" ,"cat" ,"cat" ,"snake" , "parrot" ,"cat")
unique(pet) #Te saca los elementos pero sin repetir
Fpet<-factor(pet)
Fpet
levels(Fpet)
Fpet[1] #Internamente lo almacena como números.
#Si queremos añadir ahora elementos no es tan fácil como un vector

1:10
5:1
seq(1, 20, 0.5)
?seq

runif(1)
runif(5)
mean(runif(5))
rnorm(5, 0, 1)

M<-matrix(1:6, 2, 3, byrow = FALSE)
dim(M)
nrow(M)
ncol(M)
t(M)
M[1,]
M[,1]

animal<-list(order = "carnivore" , family = "feline" , species = "lynx")
animal
animal$family
animal[[1]]
animal[1]
v<-unlist(animal)
names(v)

#La función map es una función map que funciona de la siguiente manera:
#Tenemos un vector [1,2,3,4,5,6] y queremos sumar sus componetes (imaginamos que no sabemos hacerlo)
# map(vector, función) coge el vector y aplica a todos los componentes la función
#y así nos evitamos los loops. En R es sapply
myvector<-c(3.5 , 7.8 , 4.2 , 2.5)
sapply(myvector, round)
round(myvector)
which(myvector<5)
myvector[myvector<5]
myvector [ which ( myvector < 5)] <- myvector [ myvector < 5] + 1
myvector

d<-data.frame(name=c( "Anne", "Joe", "Mario", "Rose",  "Mary"),age = c (21 ,34 ,54 ,27 ,41))
d
d$name

city <- c( "Valencia" , "Barcelona" , "Madrid" , "Valencia" , "Valencia")
job <- c( "student" , "dealer" , "engineer" , "physician", "journalist")
d2 <- cbind ( city , job , d )
d2
d2$city
d2[d2$city=="Valencia", c("name", "age")]
d2[d2$age>35,]
subset(d2,city=="Valencia", job:age)
nrow(d2)
ncol(d2)
dim(d2)
names(d2)
x<-1:3
names(x)
names(x)<-c("first", "second", "third")
names(x)
x
typeof(x)
order(x)
duplicated(x)
unique(x)
myfun<-function(x,y){
  return (x+y)
}
myfun(4,5)
