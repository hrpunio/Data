#
kandydaci <- read.csv("Mandaty_2015.csv", sep = ';',  header=T, na.string="NA");

par(mfrow=c(2,1), mar=c(4,4,2,1))

hist(subset(kandydaci, komitet=="PiS")$numer, col="green", breaks=40)
hist(subset(kandydaci, komitet=="PO")$numer, col="green", breaks=40)
