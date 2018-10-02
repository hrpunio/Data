##
par(ps=6,cex=1,cex.axis=1,cex.lab=1,cex.main=1.2)
komisje <- read.csv("ws2014_komisje.csv", sep = ';',  header=T, na.string="NA");
## ws2014_komisje.csv: glosy / glosyNiewazne

komisje$ogn <- komisje$glosyNiewazne  / (komisje$glosy + komisje$glosyNiewazne) * 100;

summary(komisje$glosyNiewazne);
fivenum(komisje$glosyNiewazne);

summary(komisje$ogn);
fivenum(komisje$ogn);

## ## ###
kpN <- seq(0, 100, by=2);
kpX <- c(0, 10,20,30,40,50,60,70,80,90, 100);

h <- hist(komisje$ogn, breaks=kpN, freq=TRUE,
   col="orange", main="Rozkład odsetka głosów nieważnych\nPolska ogółem +27 tys komisji", 
   ylab="%", xlab="% nieważne", labels=F, xaxt='n' )
   axis(side=1, at=kpN, cex.axis=2, cex.lab=2)

#kpN <- seq(0, 100, by=.5);
#h <- hist(komisje$ogn, breaks=kpN, freq=TRUE,
#   col="orange", main="Rozkład odsetka głosów nieważnych", 
#   ylab="%", xlab="% nieważne", labels=F, xaxt='n' )
#   axis(side=1, at=kpN, cex.axis=2, cex.lab=2)

## ##
komisje$woj <- substr(komisje$teryt, start=1, stop=2)

komisjeW <- subset (komisje, woj == "22"); ## pomorskie
h <- hist(komisjeW$ogn, breaks=kpN, freq=TRUE,
   col="orange", main="Rozkład odsetka głosów nieważnych", 
   ylab="%", xlab="% nieważne", labels=T, xaxt='n' )
   axis(side=1, at=kpX, cex.axis=2, cex.lab=2)

komisjeW <- subset (komisje, woj == "14"); ## mazowieckie
h <- hist(komisjeW$ogn, breaks=kpN, freq=TRUE,
   col="orange", main="Rozkład odsetka głosów nieważnych", 
   ylab="%", xlab="% nieważne", labels=T, xaxt='n' )
   axis(side=1, at=kpX, cex.axis=2, cex.lab=2)


