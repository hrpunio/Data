poslowie <- read.csv("Sejm_8_u.csv", sep = ';',  header=T, na.string="NA");

boxplot (wiek ~ klub, poslowie, xlab = "Klub", ylab = "Wiek", col='yellow')

aggregate (poslowie$wiek, list(Klub = poslowie$klub), fivenum)
aggregate (poslowie$wiek, list(Klub = poslowie$klub), na.rm=TRUE, mean)
