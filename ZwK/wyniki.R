#
co <- "Żuławy wKoło 2016"
#
z <- read.csv("wyniki_zulawy_2016_C.csv", sep = ';',  header=T, na.string="NA", dec=",");

aggregate (z$meanv, list(Numer = z$dist), fivenum)

boxplot (meanv ~ dist, z, xlab = "Dystans [km]",
    ylab = "Śr.prędkość [kmh]", col = "yellow", main=co )

## tylko dystans 140
z140 <- subset (z, ( dist == 140 ));

## statystyki zbiorcze
s140 <- summary(z140$meanv)
names(s140)

summary_label <- paste (sep='', "Średnia = ", s140[["Mean"]], 
  "\nMediana = ", s140[["Median"]],
  "\nQ1 = ", s140[["1st Qu."]],  "\nQ3 = ", s140[["3rd Qu."]],
  "\n\nMax = ", s140[["Max."]] )
# drukuje wartości kolumny meanv
# z140$meanv
# drukuje wartości statystyk zbiorczych
s140

# wykres słupkowy
h <- hist(z140$meanv, breaks=c(14,18,22,26,30,34,38), freq=TRUE, 
   col="orange", 
   main=paste (co, "[140km]"), # tytuł
   xlab="Prędkość [kmh]",ylab="L.kolarzy", labels=T, xaxt='n' )
# xaxt usuwa domyślną oś 
# axis definiuje lepiej oś OX
axis(side=1, at=c(14,18,22,26,30,34,38))
text(38, 37, summary_label, cex = .8, adj=c(1,1) )

# Drukuj liczebności (zbędne bo drukowane w polu wykresu)
#h$counts
