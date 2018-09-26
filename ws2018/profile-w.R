require(ggplot2)
#library(rtable)
#
co <- "Wiek kandydatów do sejmików wojewódzkich (2018 / Polska)"
wB <- c(18,20,25,30,35,40,45,50,55,60,65,70,75,80,95);
wD <- seq(18, 90, by=2);
summary_label <- "";

k <- read.csv("kandydaci_ws_2018_3.csv", sep = ';',  header=T, na.string="NA", dec=",");

with (k, table(komitet))

aggregate (k$wiek, list(Numer = k$komitet), fivenum)

kandydaci <- subset (k, (komitet == "SLD-LR" | komitet == "PiS" | komitet == "K15" | komitet == "PSL" |
                         komitet == "PO-N" | komitet == "WwS" | komitet == "RAZEM" |
                         komitet == "RN" | komitet == "WiS" | komitet == "BS" | komitet == "ZIELONI"));

with (kandydaci, table(komitet))

aggregate (kandydaci$wiek, list(Numer = kandydaci$komitet), fivenum)

sumS <- summary(kandydaci$wiek)

summary_label <- paste (sep='', "Średnia = ", sprintf("%.1f", sumS[["Mean"]]),
  "\nMediana = ", sumS[["Median"]],
  "\nQ1 = ", sumS[["1st Qu."]],  "\nQ3 = ", sumS[["3rd Qu."]] )

## wykres słupkowy
h <- hist(kandydaci$wiek, 
   breaks=wB, 
   freq=TRUE,
   col="orange", main=co, ylab="liczba kandydatów", xlab="wiek", labels=T, xaxt='n')
   axis(side=1, at=wB)
   text(80, 600, summary_label, cex = .8, adj=c(0,1))

h <- hist(kandydaci$wiek, 
   breaks=wD, 
   freq=TRUE,
   col="orange", main=co, ylab="liczba kandydatów", xlab="wiek", labels=T, xaxt='n')
   axis(side=1, at=wB)
   text(80, 600, summary_label, cex = .8, adj=c(0,1))


##str(kandydaci)
##
##str(kandydaci$komitet)

aggregate (kandydaci$wiek, list(Numer = kandydaci$nr), fivenum)

aggregate (kandydaci$wiek, list(Numer = kandydaci$komitet), fivenum)

#boxplot (wiek ~ komitet, kandydaci, xlab = "Komitet", ylab = "wiek", col = "yellow", main=co )

ggplot(kandydaci, aes(x=komitet, y=wiek, fill=komitet))  +
   geom_boxplot() +
   ylab("Wiek") +
   xlab("Komitet") +
   annotate(geom="text", x = 1, y = 90, hjust=0, size=3,
    label = "WwS = Wolność w Samorządzie | BS = Bezpartyjni Samorządowcy\nWiS = Wolni i Solidarni\n") +
   guides(fill=FALSE) ;

## Pomorskie TERYT=22
co <- "Wiek kandydatów do sejmików wojewódzkich (2018 / Pomorskie)"

kandydaci <- subset (kandydaci, (woj == "22" ))

aggregate (kandydaci$wiek, list(Numer = kandydaci$komitet), fivenum)

ggplot(kandydaci, aes(x=komitet, y=wiek, fill=komitet))  +
   geom_boxplot() +
   ylab("Wiek") +
   xlab("Komitet") +
   annotate(geom="text", x = 1, y = 90, hjust=0, size=3,
    label = "WwS = Wolność w Samorządzie | BS = Bezpartyjni Samorządowcy\nWiS = Wolni i Solidarni\n") +
   guides(fill=FALSE) ;

##
# wykres słupkowy
sumS <- summary(kandydaci$wiek)

summary_label <- paste (sep='', "Średnia = ", sprintf("%.1f", sumS[["Mean"]]),
  "\nMediana = ", sumS[["Median"]],
  "\nQ1 = ", sumS[["1st Qu."]],  "\nQ3 = ", sumS[["3rd Qu."]] )

h <- hist(kandydaci$wiek, 
   breaks=wB, 
   freq=TRUE,
   col="orange", main=co, xlab="wiek", ylab="liczba kandydatów", labels=T, xaxt='n')
   axis(side=1, at=wB)
   text(80, 40, summary_label, cex = .8, adj=c(0,1))


with (kandydaci, table(komitet))
