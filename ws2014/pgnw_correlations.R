require (ggplot2)
library(dplyr)

d <- read.csv("komisje_komitety7_wyniki.csv", 
  colClasses = c( "teryt"="character", "adres"="character"), sep = ';',  header=T, na.string="NA");

str(d);

## Tylko duże komisje 
d <- subset (d, ( lkw14 > 20 ));

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

powiat <- substr(d$teryt, 0, 4)

powiat

# http://stackoverflow.com/questions/16181750/correlation-of-subsets-of-dataframe-using-aggregate
d[,"powiat"] <- powiat;
p.psl <- d %>% group_by(powiat) %>% summarise(V1=cor(pgnw14,pslp))
p.pis <- d %>% group_by(powiat) %>% summarise(V1=cor(pgnw14,pis))
p.po  <- d %>% group_by(powiat) %>% summarise(V1=cor(pgnw14,po))

print(p.psl, n=Inf)
print(p.pis, n=Inf)
print(p.po, n=Inf)

m.pgnw <- d %>% group_by(powiat) %>% summarise(V2=mean(pgnw14))
m.psl <- d %>% group_by(powiat) %>% summarise(V2=mean(pslp))
m.pis <- d %>% group_by(powiat) %>% summarise(V2=mean(pisp))
m.po <- d %>% group_by(powiat) %>% summarise(V2=mean(pop))

print(m.pgnw, n=Inf)
print(m.psl, n=Inf)
print(m.pis, n=Inf)
print(m.po, n=Inf)

## ## ##
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
