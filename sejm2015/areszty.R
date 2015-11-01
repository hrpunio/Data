kandydaci <- read.csv("obwody_wyniki_areszty0.csv", sep = ';',  header=T, na.string="NA");
str(kandydaci);

aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), na.rm=TRUE, sum);

## ogółem ważne:
total <- sum (kandydaci$glosy, na.rm=TRUE);

total;

