d <- read.csv("komisje-frekwencja-ws2014.csv", sep = ';',  header=T, na.string="NA");
str(d)

pdf(file="komisje-frekwencja-ws2014.pdf", onefile = TRUE);
hist(d$freq, breaks=seq(0, 100, by=5),
       freq=TRUE,col="orange",main="Wybory do Sejmików Woj. 2014: komisje wg frekwencji",
       xlab="# głosów",ylab="# komisji (N = 26495)",yaxs="i",xaxs="i")


hist(d$pgnw, breaks=seq(0, 100, by=2),
       freq=TRUE,col="orange",main="Wybory do Sejmików Woj. 2014: komisje wg % głosów nieważnych",
       xlab="# głosów",ylab="# komisji (N = 26495)",yaxs="i",xaxs="i")

dev.off()
