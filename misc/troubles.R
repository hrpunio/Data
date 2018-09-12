v <- read.csv("troubles.csv", sep = ',',  header=T, na.string="NA");

v <- subset (v, (vaffiliation == "Catholic" | vaffiliation == "Protestant" ));

boxplot ( age ~ vaffiliation, v, xlab = "Wyznanie", ylab = "Wiek", col = "yellow")

aggregate (v$age, list(Numer = v$vaffiliation), fivenum)
aggregate (v$age, list(Numer = v$vaffiliation), mean)
