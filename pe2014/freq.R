## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
#library(reshape)
require(ggplot2)


d <- read.csv("komisje-frekwencja14_15.csv", sep = ';',  header=T, na.string="NA");
str(d)

ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")

#
d <- subset (d, ( lkw > 20 & lkw15 > 20 ));
str(d)

ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")

d <- subset (d, ( freq > 40 & freq15 > 40 ));
str(d)
ggplot(d, aes(x = freq)) +
  geom_point(aes(y = freq15), colour = 'blue') +
  xlab(label="freq 2014") +
  ylab(label="freq 2015")
