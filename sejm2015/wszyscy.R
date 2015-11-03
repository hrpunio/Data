kandydaci <- read.csv("kandydaci_obwody_wyniki.csv", sep = ';',  header=T, na.string="NA");
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), na.rm=TRUE, sum);
