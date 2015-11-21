#
library(dplyr)
#

QD <- function(data){ IQR(data)/2 }
#NthDecile <- function(data){ ntile(data, 9) } # 9th decile
NthDecile <- function(data){ quantile(data, c(.90)) } # 9th decile
#
#kandydaci <- read.csv("Mandaty_2015.csv", sep = ';',  header=T, na.string="NA");
kandydaci <- read.csv("Kandydaci_2015.csv", sep = ';',  header=T, na.string="NA");
kandydaci_all <- kandydaci;
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

kandydaci <- subset (kandydaci, subset=(numer < 10 ));
kandydaci <- subset (kandydaci, subset=(glosy < 200000));
boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

kandydaci <- kandydaci_all;
kandydaci <- subset (kandydaci, (komitet == "PETRU" | komitet == "KUKIZ" | komitet == "PSL" | komitet == "PO" | komitet == "PiS"  ));
str(kandydaci);

boxplot (glosy ~ komitet, kandydaci, xlab = "Komitet", ylab = "L.glosów", col = "yellow")

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), fivenum)
aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), mean)

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), sd)

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), QD)

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), NthDecile );
