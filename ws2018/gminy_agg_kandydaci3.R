require(ggplot2)

g <- read.csv("gminy_agg_kandydaci3.csv", sep = ';', header=T, as.is=T, na.string="NA");

str(g)

boxplot (razem ~ rok, g, xlab = "rok", ylab = "#kandydatów", col = "yellow")

aggregate (g$razem, list(Numer = g$rok), fivenum)
aggregate (g$razem, list(Numer = g$rok), mean)

gx <- subset (g, (rok == 2018))
bb <- c(0, 1, 2, 3, 4, 5,6,7,8,9,10,11,12,13,14, 15)
 
h <- hist(gx$razem,  breaks=bb,
   freq=T, col="orange", main="", xlab="lk", ylab="lg", labels=T, xaxt='n')

## histogram
gy <- subset (g, (rok == 2014))
h <- hist(gy$razem,  breaks=bb,
   freq=T, col="orange", main="", xlab="lk", ylab="lg", labels=T, xaxt='n')

gz <- subset (g, (rok == 2010))

h <- hist(gz$razem,  breaks=bb,
   freq=T, col="orange", main="", xlab="lk", ylab="lg", labels=T, xaxt='n')

#p <- ggplot(g, aes(x=razem)) + geom_density() + facet_grid(rok ~ .)
g$r <- as.factor(g$rok)
p <- ggplot(g, aes(x=razem, color=r)) + geom_density() +
 labs(title="Krzywa gęstości liczby kandydatów na urząd wójta/burmistrza/prezydenta",x="Liczba kandydatów", 
   y = "Gęstość", color="Rok")
p
