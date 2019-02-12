library(reshape)
require(ggplot2)

d <- read.csv("imdb_yr_g.csv", sep = ';',  header=T, na.string="NA");

d <- subset (d, (year < 2019 ));

## western production
ggplot(d, aes(x = year)) +
  geom_line(aes(y = Western, colour = 'Western'), size=2) +
  ylab(label="#Movies") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

## total movies production
ggplot(d, aes(x = year)) +
  geom_line(aes(y = Total, colour = 'Total'), size=2) +
  ylab(label="#Movies") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

## total movies production (logarithms)
lTotal <- log(d$Total);
lWestern <- log(d$Western);

d[,"lTotal"] <- lTotal
d[,"lWestern"] <- lWestern

ggplot(d, aes(x = year)) +
  geom_line(aes(y = lTotal, colour = 'lTotal'), size=2) +
  geom_line(aes(y = lWestern, colour = 'lWestern'), size=2) +
  ylab(label="log(#Movies)") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

pWestern <- d$Western / d$Total * 100;
d[,"pWestern"]  <- pWestern;
pComedy <- d$Comedy / d$Total * 100;
d[,"pComedy"]  <- pComedy;

pCrime <- d$Crime / d$Total * 100;
d[,"pCrime"]  <- pCrime;
pHorror <- d$Horror / d$Total * 100;
d[,"pHorror"]  <- pHorror;
pSciFi <- (d$Fantasy + d$SciFi) / d$Total * 100;
d[,"pSciFi"]  <- pSciFi;


ggplot(d, aes(x = year)) +
  geom_line(aes(y = pWestern, colour = 'pWestern'), size=2) +
  geom_line(aes(y = pComedy, colour = 'pComedy'), size=2) +
  geom_line(aes(y = pCrime, colour = 'pCrime'), size=2) +
  geom_line(aes(y = pHorror, colour = 'pHorror'), size=2) +
  geom_line(aes(y = pSciFi, colour = 'pSciFi'), size=2) +
  ylab(label="%Total") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

