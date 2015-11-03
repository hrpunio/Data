kandydaci <- read.csv("obwody_wyniki_areszty0.csv", sep = ';',  header=T, na.string="NA");
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
zkandydaci <- subset(kandydaci, grepl("karn", adres, ignore.case = TRUE) )

pokandydaci <- subset(kandydaci, grepl("PO", komitet, ignore.case = TRUE) )
piskandydaci <- subset(kandydaci, grepl("PiS", komitet, ignore.case = TRUE) )
kkandydaci <- subset(kandydaci, grepl("KUKIZ", komitet, ignore.case = TRUE) )

str(kkandydaci)

#head(zkandydaci, n=99)
pototal <- aggregate (pokandydaci$glosy, list(Numer = pokandydaci$woj), na.rm=TRUE, sum);
pistotal <- aggregate (piskandydaci$glosy, list(Numer = piskandydaci$woj), na.rm=TRUE, sum);
kuktotal <- aggregate (kkandydaci$glosy, list(Numer = kkandydaci$woj), na.rm=TRUE, sum);

str(kuktotal);

pototal[,"Numer"];
pototal[,"x"] / wojtotal[,"x"] * 100;
pistotal[,"x"] / wojtotal[,"x"] * 100;
kuktotal[,"x"] / wojtotal[,"x"] * 100;

aggregate (zkandydaci$glosy, list(Numer = zkandydaci$komitet), na.rm=TRUE, sum);
total <- sum (zkandydaci$glosy, na.rm=TRUE); total;

##
#Najpopularniejsi:
#-----------------
#Stefan Konstanty NIESIOŁOWSKI (PO) ... 179
#Jacek PROTAS (PO) ... 184
#Borys Piotr BUDKA (PO) ... 188
#Leszek Sylwester KORZENIOWSKI (PO) ... 215
#Marek BIERNACKI (PO) ... 218
#Paweł Piotr KUKIZ (KUKIZ) ... 234
#Jacek PROTASIEWICZ (PO) ... 241
#Adam Marek KOROL (PO) ... 279
#Alicja Paulina CHYBICKA (PO) ... 337
#Ewa Bożena KOPACZ (PO) ... 915
#
#
