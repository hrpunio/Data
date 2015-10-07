#
kandydaci <- read.csv("kandydaci_2007.csv", sep = ';',  header=T, na.string="NA");
kandydaci_all <- kandydaci;
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

kandydaci <- subset (kandydaci, subset=(numer < 10 ));
kandydaci <- subset (kandydaci, subset=(glosy < 200000));
boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

kandydaci <- kandydaci_all;

## PiS = 4; PO = 5 ; PSL = 6 ; SLD = 7 ; MnN = 10 
kandydaci <- subset (kandydaci, (komitet == "K4" | komitet == "K5" | komitet == "K6" | komitet == "K7" | komitet == "K10" ));
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

