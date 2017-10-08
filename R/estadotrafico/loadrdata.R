
## toma un conjunto de rdatas y los fusiona
mdir<-"rdata/"

resd<-list.files(mdir, pattern="")
#almacenamos toda la info en una lista
l<-list()
for (id in 1:length(resd))
{
 fi<-(paste(mdir,resd[id],sep=""))
 load(fi)
 print(id)
 l[[id]]<-datos
 #if(id==1) totdata<-datos
 #else totdata<-rbind(totdata,datos)
}
library(plyr)
# esta operacion trasnforma la lista en un dataframe
tot<-ldply(l, data.frame)

save(tot,file="totr.Rdata")
