## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
require(ggplot2)
require(ggpubr)

d <- read.csv("MEVO_DAILY_BIKES.csv", sep = ';',  header=T, na.string="NA");
##rains <- read.csv("mevo_rains_daily.csv", sep = ';',  header=T, na.string="NA");
##
##d["rains"] <- rains$opad

nzb <- d$bikes - d$zb
d["nzb"] <- nzb

p1 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO: rowery jeżdżone (nzb) vs niejeżdżone (zb)") +
  geom_point(aes(y = bikes, colour = 'bikes'), size=1) +
  geom_point(aes(y = zb, colour = 'zb'), size=1) +
  geom_point(aes(y = nzb, colour = 'nzb'), size=1) +
  ##geom_line(aes(y = rains, colour = 'nzb'), size=1) +
  geom_smooth(aes(x = as.Date(day), y=bikes, colour='bikes'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=zb, colour='zb'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=nzb, colour='nzb'), method="loess", size=1) +
  ylab(label="#") +
  ##theme(legend.title=element_blank()) +
  labs(colour = "Rowery: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p2 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO: dzienny dystans (Gdańsk/Gdynia)") +
  geom_point(aes(y = ga, colour = 'ga'), size=1) +
  geom_point(aes(y = gd, colour = 'gd'), size=1) +
  geom_smooth(aes(x = as.Date(day), y=ga, colour='ga'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=gd, colour='gd'), method="loess", size=.5) +
  ylab(label="km") +
  labs(colour = "Miasta: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p3 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO: dzienny dystans (Tczew/Rumia/Sopot)") +
  geom_point(aes(y = sop, colour = 'sop'), size=1) +
  geom_point(aes(y = tczew, colour = 'tczew'), size=1) +
  geom_point(aes(y = rumia, colour = 'rumia'), size=1) +
  geom_smooth(aes(x = as.Date(day), y=sop, colour='sop'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=tczew, colour='tczew'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=rumia, colour='rumia'), method="loess", size=.5) +
  ylab(label="km") +
  labs(colour = "Miasta: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p4 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO: dzienny dystans łącznie") +
  geom_line(aes(y = dist.total, colour = 'dist.total'), size=.5) +
  geom_smooth(aes(x = as.Date(day), y=dist.total, colour='dist.total'), method="loess", size=1) +
  ylab(label="km") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p1;p2;p3;p4

ggarrange(p1, p2, p3, p4, ncol = 2, nrow = 2)
ggsave(file="mevo_daily_bikes.pdf", width=12)

# https://stackoverflow.com/questions/16652199/compute-monthly-averages-from-daily-data
d$day <- as.Date(d$day);

d$mm <- months(d$day)
d$yy <- format(d$day, format="%y")

aggregate(nzb ~ mm + yy, d, mean)
aggregate(zb ~ mm + yy, d, mean)
aggregate(bikes ~ mm + yy, d, mean)

d$nzbp <- d$nzb/d$bikes * 100

## udział średni jeżdżonych w całości
aggregate(nzbp ~ mm + yy, d, mean)

## gdańsk gdynia
aggregate(gd ~ mm + yy, d, mean)
aggregate(ga ~ mm + yy, d, mean)

##
mean(d$zstat)
mean(d$sstat)
mean(d$gd0p)
mean(d$ga0p)
mean(d$sop0p)
mean(d$tczew0p)
mean(d$rumia0p)
mean(d$gd1p)
mean(d$ga1p)
mean(d$sop1p)
mean(d$tczew1p)
mean(d$rumia1p)
