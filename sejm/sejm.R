poslowie <- read.csv("Sejm1-7.csv", sep = ';',  header=T, na.string="NA");

boxplot (wiek ~ kadencja, poslowie, xlab = "Kadencja", ylab = "Wiek", col='yellow')

aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), fivenum)
aggregate (poslowie$wiek, list(Kadencja = poslowie$kadencja), na.rm=TRUE, mean)
