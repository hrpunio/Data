poslowie <- read.csv("aktywnosc_07.csv", sep = ';',  header=T, na.string="NA");

boxplot ( l.wystap ~ klub, poslowie, xlab = "Klub", ylab = "L.wystapien", col='yellow')
##mtext(text="https://github.com/hrpunio/Data/tree/master/sejm", 4, cex=0.7)

# k20 <- subset (k, subset=(glosyr > 19 )); ## co najmniej 20 glosow w komisji
##aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), fivenum)
##aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), na.rm=TRUE, mean)
