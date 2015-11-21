komisje <- read.csv("komisje_glosy_razem.csv", sep = ';',  header=T, na.string="NA");
str(komisje);

hist(komisje$glosy, breaks=seq(0, 3200, by=25),
       freq=TRUE,col="orange",main="Wybory2015: komisje wg liczby oddanych głosów",
       xlab="# głosów",ylab="# komisji (N = 27859)",yaxs="i",xaxs="i")

mtext(text="https://github.com/hrpunio/Data/tree/master/sejm", 4, cex=0.7)
text(3200,100, "Me = 495\nQ1 = 265\nQ3 = 782\n0 głosów -- 2 komisje\n5 i mniej -- 48 komisji\n1500 i więcej -- 164 komisje", 2, cex=0.7,  adj=c(0,0));

##
fivenum(komisje$glosy);
##
quantile(komisje$glosy, c(.10));
quantile(komisje$glosy, c(.05));
quantile(komisje$glosy, c(.90));

