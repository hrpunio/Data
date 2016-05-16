require (ggplot2)

d <- read.csv("komisje_komitety7_wyniki.csv", sep = ';',  header=T, na.string="NA");

#nrk;teryt;nro;adres;lwug;lkw;lkwzu;lgnw;lgw;freq;pgnw;lwug15;lkw15;lkwzu15;lgnw15;lgw15;freq15;pgnw15;
#lwug14;lkw14;lkwzu14;lgnw14;lgw14;freq14;pgnw14;psl;dbezp;pis;po;rn;sld;npjkm

str(d);

pslp <- d$psl/d$lgw14 * 100;
pisp <- d$pis/d$lgw14 * 100;
pop <- d$po/d$lgw14 * 100;

summary(pslp)
summary(pisp)
summary(pop)

d[,"pslp"] <- pslp;
d[,"pisp"] <- pisp;
d[,"pop"] <- pop;

cor(d$pgnw14, d$pslp, use = "complete")
cor(d$pgnw14, d$pisp, use = "complete")
cor(d$pgnw14, d$pop, use = "complete")

cor(d$pgnw14, d$pgnw, use = "complete")
cor(d$pgnw14, d$pgnw15, use = "complete")

## Tylko duże komisje
d <- subset (d, ( lkw14 > 20 ));

ggplot(d, aes(x = pgnw14 )) +
  geom_point(aes(y = pslp), colour = 'blue') +
  xlab(label="pgnw") +
  ylab(label="pslp")

ggplot(d, aes(x = pgnw14 )) +
  geom_point(aes(y = pisp), colour = 'blue') +
  xlab(label="pgnw") +
  ylab(label="pisp")

ggplot(d, aes(x = pgnw14 )) +
  geom_point(aes(y = pop), colour = 'blue') +
  xlab(label="pgnw") +
  ylab(label="pop")
