library(ggplot2)
ufo<-read.delim("ufo_awesome.tsv", sep="\t", stringsAsFactors=FALSE,
                header=FALSE, na.strings="")

head(ufo)

names(ufo)<-c("DateOccurred","DateReported","Location","ShortDescription",
              "Duration","LongDescription")


ufo$DateOccurred<-as.Date(ufo$DateOccurred, format="%Y%m%d")

head(ufo[which(nchar(ufo$DateOccurred)!=8 | nchar(ufo$DateReported)!=8),1])

good.rows<-ifelse(nchar(ufo$DateOccurred)!=8 | nchar(ufo$DateReported)!=8,FALSE, TRUE)


length(which(!good.rows))


ufo<-ufo[good.rows,]

ufo$DateOccurred<-as.Date(ufo$DateOccurred, format="%Y%m%d")



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


city.state<-lapply(ufo$Location, get.location)
head(city.state)

location.matrix<-do.call(rbind, city.state)
ufo<-transform(ufo, USCity=location.matrix[,1], USState=tolower(location.matrix[,2]),
               stringsAsFactors=FALSE)

us.states<-c("ak","al","ar","az","ca","co","ct","de","fl","ga","hi","ia","id","il",
             "in","ks","ky","la","ma","md","me","mi","mn","mo","ms","mt","nc","nd","ne","nh",
             "nj","nm","nv","ny","oh","ok","or","pa","ri","sc","sd","tn","tx","ut","va","vt",
             "wa","wi","wv","wy")

ufo$USState<-us.states[match(ufo$USState,us.states)]
ufo$USCity[is.na(ufo$USState)]<-NA

ufo.us<-subset(ufo, !is.na(USState))
head(ufo.us)

summary(ufo.us$DateOccurred)

quick.hist<-ggplot(ufo.us, aes(x=DateOccurred))+geom_histogram()
ggsave(plot=quick.hist, filename="quick_hist.png", height=6, width=8)

ufo.us<-subset(ufo.us, DateOccurred>=as.Date("1990-01-01"))
nrow(ufo.us)

quick.hist<-ggplot(ufo.us, aes(x=DateOccurred))+geom_histogram()
ggsave(plot=quick.hist, filename="quick_hist.png", height=6, width=8)

ufo.us$YearMonth<-strftime(ufo.us$DateOccurred, format="%Y-%m")

sightings.counts<-ddply(ufo.us,.(USState,YearMonth), nrow)
head(sightings.counts)

date.range<-seq.Date(from=as.Date(min(ufo.us$DateOccurred)),
                     to=as.Date(max(ufo.us$DateOccurred)), by="month")
date.strings<-strftime(date.range, "%Y-%m")

states.dates<-lapply(us.states,function(s) cbind(s,date.strings))
states.dates<-data.frame(do.call(rbind, states.dates), stringsAsFactors=FALSE)
head(states.dates)


all.sightings<-merge(states.dates,sightings.counts,by.x=c("s","date.strings"),
                     by.y=c("USState","YearMonth"),all=TRUE)
head(all.sightings)


names(all.sightings)<-c("State","YearMonth","Sightings")
all.sightings$Sightings[is.na(all.sightings$Sightings)]<-0
all.sightings$YearMonth<-as.Date(rep(date.range,length(us.states)))
all.sightings$State<-as.factor(toupper(all.sightings$State))


state.plot<-ggplot(all.sightings, aes(x=YearMonth,y=Sightings))+
  geom_line(aes(color="darkblue"))+
  facet_wrap(~State,nrow=10,ncol=5)+
  theme_bw()+
  scale_color_manual(values=c("darkblue"="darkblue"))+
   xlab("Time")+ylab("Number of Sightings")
ggsave(plot=state.plot, filename="ufo_sightings.pdf",width=14,height=8.5)



