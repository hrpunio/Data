#
kandydaci <- read.csv("Mandaty_2015.csv", sep = ';',  header=T, na.string="NA");
kandydaci_all <- kandydaci;
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

kandydaci <- subset (kandydaci, subset=(numer < 10 ));
kandydaci <- subset (kandydaci, subset=(glosy < 200000));
boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

kandydaci <- kandydaci_all;
kandydaci <- subset (kandydaci, (komitet = "PETRU" | komitet == "KUKIZ" | komitet == "PSL" | komitet == "PO" | komitet == "PiS"  ));
str(kandydaci);

boxplot (glosy ~ komitet, kandydaci, xlab = "Komitet", ylab = "L.glosów", col = "yellow")

#aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)
#
#kandydaci <- subset (kandydaci, (wynik == "PX" ));
#
#hist(kandydaci$numer, breaks=40)
