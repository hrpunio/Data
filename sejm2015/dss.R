kandydaci <- read.csv("obwody_wyniki_dss0.csv", sep = ';',  header=T, na.string="NA");
str(kandydaci);

partie <- aggregate (kandydaci$glosy, list(Numer = kandydaci$komitet), na.rm=TRUE, sum);
wojtotal <- aggregate (kandydaci$glosy, list(Numer = kandydaci$woj), na.rm=TRUE, sum);
wojtotal;

total <- sum (kandydaci$glosy, na.rm=TRUE);
total;

## ogółem
str(partie);

partie[,"Numer"];
partie[,"x"] / total * 100;

## ogółem ważne:

str(total);

#aggregate (kandydaci$glosy, list(Numer = kandydaci$kto), na.rm=TRUE, sum);
#
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/grep.html

pokandydaci <- subset(kandydaci, grepl("PO", komitet, ignore.case = TRUE) )
piskandydaci <- subset(kandydaci, grepl("PiS", komitet, ignore.case = TRUE) )
kkandydaci <- subset(kandydaci, grepl("KUKIZ", komitet, ignore.case = TRUE) )

str(kkandydaci)

pototal <- aggregate (pokandydaci$glosy, list(Numer = pokandydaci$woj), na.rm=TRUE, sum);
pistotal <- aggregate (piskandydaci$glosy, list(Numer = piskandydaci$woj), na.rm=TRUE, sum);
kuktotal <- aggregate (kkandydaci$glosy, list(Numer = kkandydaci$woj), na.rm=TRUE, sum);

str(kuktotal);

pototal[,"Numer"];
pototal[,"x"] / wojtotal[,"x"] * 100;
pistotal[,"x"] / wojtotal[,"x"] * 100;
kuktotal[,"x"] / wojtotal[,"x"] * 100;

