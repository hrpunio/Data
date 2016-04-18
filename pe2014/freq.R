## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
#library(reshape)
require(ggplot2)


d <- read.csv("komisje-frekwencja14_15.csv", sep = ';',  header=T, na.string="NA");
str(d)
# Usuń zagraniczne (nietypowe):
d <- subset (d, ( teryt != 149901 ));
str(d)

ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")

ggplot(d, aes(x = pgnw)) +
  geom_point(aes(y = pgnw15), colour = 'blue') +
  xlab(label="nonvalid 2014 (%)") +
  ylab(label="nonvalid 2015 (%)")

#
d <- subset (d, ( lkw > 20 & lkw15 > 20 ));
str(d)

ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")

d <- subset (d, ( freq > 60 & freq15 > 60 ));
str(d)
ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")

d;

ggplot(d, aes(x = pgnw)) +
  geom_point(aes(y = pgnw15), colour = 'blue') +
  xlab(label="nonvalid 2014 (%)") +
  ylab(label="nonvalid 2015 (%)")

d <- subset (d, !grepl("Dom pomocy|Domu Pomocy|Areszt", adres, ignore.case = TRUE));

d;
