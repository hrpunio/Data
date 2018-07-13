require(ggplot2)

d <- read.csv("rus2018x.csv", sep = ';', dec = ",",  header=T, na.string="NA");
c <- read.csv("panstwa.csv", sep = ';', dec = ",",  header=T, na.string="NA");

d["state"] <- d$cityState

hist(d$age, breaks=seq(18, 46, by=2),
       freq=TRUE,col="orange",main="Wiek",
       xlab="# wiek",ylab="# N",yaxs="i",xaxs="i")

ggplot(d, aes(x=d$team, y=age, fill=d$team))  +
   geom_boxplot() +
   ylab("Lata") +
   xlab("Kraj") +
   guides(fill=FALSE) ;


###
d <- merge(d, c, by = "team")


d$perf1

ggplot(d, aes(x=as.factor(d$perf1), y=age, fill=as.factor(d$perf1)))  +
   geom_boxplot() +
   ylab("Lata") +
   xlab("Kraj") +
   guides(fill=FALSE) ;


##ggsave(file="FWC2018.pdf", width=15, height=8)
ggplot(d, aes(x=as.factor(d$continent), y=age, fill=as.factor(d$continent)))  +
   geom_boxplot() +
   ylab("Lata") +
   xlab("Kontynent") +
   guides(fill=FALSE) ;

## 16 która przeszła do drugiej rundy
d2 <- subset (d, (perf1 < 3))
hist(d2$age, breaks=seq(18, 46, by=2),
       freq=TRUE,col="orange",main="Wiek",
       xlab="# wiek",ylab="# N",yaxs="i",xaxs="i")

ggplot(d2, aes(x=as.factor(d2$continent), y=age, fill=as.factor(d2$continent)))  +
   geom_boxplot() +
   ylab("Lata") +
   xlab("Kontynent") +
   guides(fill=FALSE) ;


qplot(age, data=d, geom="histogram", facets=continent ~ .)
qplot(age, data=d2, geom="histogram", facets=continent ~ .)

###
aggregate (d$age, list(Team = d$team), fivenum)
aggregate (d$age, list(Team = d$team), mean)


mean(d$age)
mean(d2$age)

fivenum(d$age)
fivenum(d2$age)

