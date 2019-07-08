## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
require(ggplot2)

d <- read.csv("mevo_daily_stat_occ.csv", sep = ';',  header=T, na.string="NA");

str(d)

p <- ggplot(d, aes(x = as.Date(date))) +
  ggtitle("MEVO: średnia liczba rowerów na stacji") +
  geom_point(aes(y = GA, colour = 'GA'), size=1) +
  geom_point(aes(y = GD, colour = 'GD'), size=1) +
  geom_point(aes(y = Sop, colour = 'Sop'), size=1) +
#####
  geom_smooth(aes(x = as.Date(date), y=GA, colour='GA'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(date), y=GD, colour='GD'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(date), y=Sop, colour='Sop'), method="loess", size=.5)

p

ggsave(file="mevo_daily_stat_occ.pdf", width=12)
