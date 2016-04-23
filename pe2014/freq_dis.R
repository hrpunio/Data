d <- read.csv("komisje-frekwencja14_15.csv", sep = ';',  header=T, na.string="NA");
# Usuń zagraniczne (nietypowe):
d <- subset (d, ( teryt != 149901 ));

str(d);


hist(d$freq, breaks=seq(0, 100, by=5),
       freq=TRUE,col="orange",main="Wybory2014: komisje wg frekwencji",
       xlab="# głosów",ylab="# komisji (N = 27664)",yaxs="i",xaxs="i")

hist(d$freq15, breaks=seq(0, 100, by=5),
       freq=TRUE,col="orange",main="Wybory2015: komisje wg frekwencji",
       xlab="# głosów",ylab="# komisji (N = 27664)",yaxs="i",xaxs="i")


d <- subset (d, ( pgnw < 50 & pgnw15 < 50 ));
str(d);
hist(d$pgnw, breaks=seq(0, 50, by=1),
       freq=TRUE,col="orange",main="Wybory2014: komisje wg % głosów nieważnych",
       xlab="# głosów",ylab="# komisji (N = 27664)",yaxs="i",xaxs="i")

hist(d$pgnw15, breaks=seq(0, 50, by=1),
       freq=TRUE,col="orange",main="Wybory2015: komisje wg % głosów nieważnych",
       xlab="# głosów",ylab="# komisji (N = 27664)",yaxs="i",xaxs="i")
