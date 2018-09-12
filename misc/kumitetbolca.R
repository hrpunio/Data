kb <- read.csv("kumitetbolca.csv", sep = ';',  header=T, na.string="NA");

fivenum(kb$age)

boxplot (kb$age)

# wykres słupkowy
h <- hist(kb$age, breaks=c(40,45,50,55,60,65,70,75,80,85,90), freq=TRUE, 
   col="orange", 
   main="", # tytuł
   xlab="wiek",ylab="liczba", labels=T  )
