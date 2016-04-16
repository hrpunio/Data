komisje <- read.csv("komisje-frekwencja.csv", sep = ';',  header=T, na.string="NA");
str(komisje);

fivenum(komisje$lkw);

hist(komisje$lkw, breaks=seq(0, 1250, by=10),
       freq=TRUE,col="orange",main="Wybory2014: komisje wg liczby oddanych głosów ważnych",
       xlab="# głosów",ylab="# komisji (N = 27664)",yaxs="i",xaxs="i")

mtext(text="https://github.com/hrpunio/Data/tree/master/sejm", 4, cex=0.7)
text(1200,100, "Me = 220\nQ1 = 112\nQ3 = 377\n0 głosów -- 14 komisje\n5 i mniej -- 125 komisji\n1000 i więcej -- 32 komisje", 2, cex=0.7,  adj=c(0,0));

## 0  112  220  377 1213
quantile(komisje$lkw, c(.10));
quantile(komisje$lkw, c(.05));
quantile(komisje$lkw, c(.90));
quantile(komisje$lkw, c(.95));

#is.na(komisje$lkw);
#
#is.nan(komisje$lkw);
