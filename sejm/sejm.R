poslowie <- read.csv("Sejm1-8.csv", sep = ';',  header=T, na.string="NA");

boxplot (wiek ~ kadencja, poslowie, xlab = "Kadencja", ylab = "Wiek", col='yellow')
mtext(text="https://github.com/hrpunio/Data/tree/master/sejm", 4, cex=0.7)

aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), fivenum)
aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), na.rm=TRUE, mean)
