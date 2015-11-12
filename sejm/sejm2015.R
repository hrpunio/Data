poslowie <- read.csv("Sejm_8_u.csv", sep = ';',  header=T, na.string="NA");

boxplot (wiek ~ klub, poslowie, xlab = "Klub", ylab = "Wiek", col='yellow')
#text(4,10, "https://github.com/hrpunio/Data/tree/master/sejm" )
#text(4,15, "https://github.com/hrpunio/", font = 2 )
mtext(text="https://github.com/hrpunio/Data/tree/master/sejm", 4, cex=0.7)

aggregate (poslowie$wiek, list(Klub = poslowie$klub), fivenum)
aggregate (poslowie$wiek, list(Klub = poslowie$klub), na.rm=TRUE, mean)
