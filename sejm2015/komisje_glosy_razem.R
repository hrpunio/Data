komisje <- read.csv("komisje_glosy_razem.csv", sep = ';',  header=T, na.string="NA");
str(komisje);

hist(komisje$glosy, breaks=seq(0, 3200, by=25),
       freq=TRUE,col="orange",main="Liczba głosów w komisjach obwodowych",
       xlab="# głosów",ylab="# komisji",yaxs="i",xaxs="i")

fivenum(komisje$glosy);

quantile(komisje$glosy, c(.10));

quantile(komisje$glosy, c(.05));
quantile(komisje$glosy, c(.90));

