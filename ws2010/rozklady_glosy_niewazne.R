#!/usr/bin/Rscript
# Skrypt wykreśla histogramy dla danych z pliku ws2014_komisje.csv
# (więcej: https://github.com/hrpunio/Data/tree/master/ws2014_pobranie_2018)
#
par(ps=6,cex=1,cex.axis=1,cex.lab=1,cex.main=1.2)
komisje <- read.csv("ws2010_komisje.csv", sep = ';',
       header=T, na.string="NA");

komisje$ogn <- komisje$lgnw  / (komisje$lgw + komisje$lgnw) * 100;

summary(komisje$lgnw); fivenum(komisje$lgnw);
sX <- summary(komisje$ogn);
sF <- fivenum(komisje$ogn);
sV <- sd(komisje$ogn, na.rm=TRUE)
skewness <- 3 * (sX[["Mean"]] - sX[["Median"]])/sV

summary_label <- sprintf ("Śr = %.1f\nMe = %.1f\nq1 = %.1f\nq3 = %.1f\nW = %.2f", 
  sX[["Mean"]], sX[["Median"]], sX[["1st Qu."]], sX[["3rd Qu."]], skewness)

## ##
kpN <- seq(0, 100, by=2);
kpX <- c(0, 10,20,30,40,50,60,70,80,90, 100);
nn <- nrow(komisje)

h <- hist(komisje$ogn, breaks=kpN, freq=TRUE,
   col="orange", main=sprintf ("Rozkład odsetka głosów nieważnych\nPolska ogółem %i komisji", nn), 
   ylab="%", xlab="% nieważne", labels=F, xaxt='n' )
   axis(side=1, at=kpN, cex.axis=2, cex.lab=2)
   posX <- .5 * max(h$counts)
text(80, posX, summary_label, cex=1.4, adj=c(0,1))

## ## terytP = teryt powiatu
komisje$woj <- substr(komisje$terytP, start=1, stop=2)

komisjeW <- subset (komisje, woj == "22"); ## pomorskie
nn <- nrow(komisjeW)
sX <- summary(komisjeW$ogn); sF <- fivenum(komisjeW$ogn);
sV <- sd(komisjeW$ogn, na.rm=TRUE)
skewness <- 3 * (sX[["Mean"]] - sX[["Median"]])/sV

summary_label <- sprintf ("Śr = %.1f\nMe = %.1f\nq1 = %.1f\nq3 = %.1f\nW = %.2f", 
  sX[["Mean"]], sX[["Median"]], sX[["1st Qu."]], sX[["3rd Qu."]], skewness)

h <- hist(komisjeW$ogn, breaks=kpN, freq=TRUE,
   col="orange", main=sprintf("Rozkład odsetka głosów nieważnych\nPomorskie %i komisji", nn), 
   ylab="%", xlab="% nieważne", labels=T, xaxt='n' )
   axis(side=1, at=kpX, cex.axis=2, cex.lab=2)
   posX <- .5 * max(h$counts)
text(80, posX, summary_label, cex=1.4, adj=c(0,1))

komisjeW <- subset (komisje, woj == "14"); ## mazowieckie
nn <- nrow(komisjeW)
sX <- summary(komisjeW$ogn); sF <- fivenum(komisjeW$ogn);
sV <- sd(komisjeW$ogn, na.rm=TRUE)
skewness <- 3 * (sX[["Mean"]] - sX[["Median"]])/sV

summary_label <- sprintf ("Śr = %.1f\nMe = %.1f\nq1 = %.1f\nq3 = %.1f\nW = %.2f", 
  sX[["Mean"]], sX[["Median"]], sX[["1st Qu."]], sX[["3rd Qu."]], skewness)

h <- hist(komisjeW$ogn, breaks=kpN, freq=TRUE,
   col="orange", main=sprintf("Rozkład odsetka głosów nieważnych\nMazowieckie %i komisji", nn), 
   ylab="%", xlab="% nieważne", labels=T, xaxt='n' )
   axis(side=1, at=kpX, cex.axis=2, cex.lab=2)
   posX <- .5 * max(h$counts)
text(80, posX, summary_label, cex=1.4, adj=c(0,1))


