#
kandydaci <- read.csv("kandydaci_2011.csv", sep = ';',  header=T, na.string="NA");
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

kandydaci <- subset (kandydaci, subset=(numer < 10 ));
kandydaci <- subset (kandydaci, subset=(glosy < 200000));
boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")
