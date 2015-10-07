#
kandydaci <- read.csv("kandydaci_2005.csv", sep = ';',  header=T, na.string="NA");
kandydaci_all <- kandydaci;
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

kandydaci <- subset (kandydaci, subset=(numer < 10 ));
kandydaci <- subset (kandydaci, subset=(glosy < 200000));
boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

# k107 = PiS ;k9 = SlD; LPR = K106 ; PSL = k76 ; SamoObr = k5 ; PO =78 ; MnN = 75
kandydaci <- kandydaci_all;

kandydaci <- subset (kandydaci, (komitet == "K107" | komitet == "K106" | komitet == "K9" | komitet == "K76" | komitet == "K5" | komitet == "K78" | komitet == "K75"));
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$numer), fivenum)

boxplot (glosy ~ numer, kandydaci, xlab = "Nr", ylab = "L.glosów", col = "yellow")

piskandydaci <- subset (kandydaci, (komitet == "K107"));
pokandydaci <- subset (kandydaci, (komitet == "K107"));

