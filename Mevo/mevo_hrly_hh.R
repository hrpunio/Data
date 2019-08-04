## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
require(ggplot2)
require(ggpubr)

# dt;bikes;zStations;sStats;allStats;p0;p1
d <- read.csv("MEVO_HH_AGGR_2019.csv", sep = ';',  header=T, na.string="NA");
m.gd <- mean(d$Gd)
m.ga <- mean(d$Ga)
m.sp <- mean(d$Sop)
m.tp <- mean(d$Tczew)

m.gd

m.ga

m.sp

m.tp

str(d$date);

d["hr"] <- substr(d$date, 12,13);

## względny HH w %
d["gdp"] = (d$Gd - m.gd)/m.gd * 100
d["gap"] = (d$Ga - m.ga)/m.ga * 100
d["sopp"] = (d$Sop - m.sp)/m.sp * 100
d["tczp"] = (d$Tczew - m.tp)/m.tp * 100

p11 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = Gd, colour = 'Gd'), size=.5) +
  ##geom_line(aes(y = S, colour = 'pm'), size=.5) +
  ##geom_smooth(aes(x = as.POSIXct(date), y=Gd, colour='Gd'), method="loess", size=1) +
  ##geom_smooth(aes(x = as.POSIXct(date), y=Ga, colour='Ga'), method="loess", size=1) +
  ##geom_smooth(aes(x = as.POSIXct(date), y=pm, colour='pm'), method="loess", size=1) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p12 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = Ga, colour = 'Ga'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p13 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = Sop, colour = 'Sop'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p14 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = Tczew, colour = 'Tczew'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p21 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = gdp, colour = 'gdp'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p22 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = gap, colour = 'gap'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p23 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = sopp, colour = 'sopp'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p24 <- ggplot(d, aes(x = as.POSIXct(date))) +
  ggtitle("MEVO: koncentracja rowerów na stacjach") +
  geom_line(aes(y = tczp, colour = 'tczp'), size=.5) +
  ylab(label="% (stacji)") +
  labs(colour = "Stacja:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

ggarrange(p11, p12, p13, p14, ncol = 2, nrow = 2)
ggsave(file="mevo_hrly_hh_gd_ga.pdf", width=12)

ggarrange(p21, p22, p23, p24, ncol = 2, nrow = 2)
ggsave(file="mevo_hrly_hhp.pdf", width=12)

dd <- d;

d <- subset(dd, (status < 6))

mean(d$Gd); mean(d$Ga); mean(d$Sop); mean(d$Tczew)

gd.ahr <- aggregate(Gd ~ hr, d, mean)
ga.ahr <- aggregate(Ga ~ hr, d, mean)
sp.ahr <- aggregate(Sop ~ hr, d, mean)
tc.ahr <- aggregate(Tczew ~ hr, d, mean)
##str(gd.ahr)

##gd.ahr$Gd
hr.data <- data.frame(gd.ahr$hr, gd.ahr$Gd, ga.ahr$Ga,  sp.ahr$Sop, tc.ahr$Tczew)

hr.data

# gd.ahr.hr gd.ahr.Gd ga.ahr.Ga sp.ahr.Sop
p91 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = gd.ahr.Gd, colour = 'gd.ahr.Gd', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w GD (pon-pn)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
# ##
## https://stackoverflow.com/questions/15978836/ggplot2-geom-line-for-single-observations-x-factor-y-numeric
p92 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = ga.ahr.Ga, colour = 'ga.ahr.Ga', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w GA (pon-pn)") +
  ##geom_line(aes(y = ga.ahr.Ga, colour = 'ga.ahr.Ga'), size=.5) +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p93 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = sp.ahr.Sop, colour = 'sp.ahr.Sop', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w SOP (pon-pn)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p94 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = tc.ahr.Tczew, colour = 'tc.ahr.Tczew', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w Tczew (pon-pn)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));


ggarrange(p91, p92,  ncol = 2, nrow = 1)
ggsave(file="mevo_hrly_hrly_gdga.pdf", width=12)

ggarrange(p93, p94, ncol = 2, nrow = 1)
ggsave(file="mevo_hrly_hrly_sptc.pdf", width=12)


###########

d <- subset(dd, (status > 7))

mean(d$Gd); mean(d$Ga); mean(d$Sop); mean(d$Tczew)

gd.ahr <- aggregate(Gd ~ hr, d, mean)
ga.ahr <- aggregate(Ga ~ hr, d, mean)
sp.ahr <- aggregate(Sop ~ hr, d, mean)
tc.ahr <- aggregate(Tczew ~ hr, d, mean)
##str(gd.ahr)

##gd.ahr$Gd
hr.data <- data.frame(gd.ahr$hr, gd.ahr$Gd, ga.ahr$Ga,  sp.ahr$Sop, tc.ahr$Tczew)

hr.data

# gd.ahr.hr gd.ahr.Gd ga.ahr.Ga sp.ahr.Sop
p91 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = gd.ahr.Gd, colour = 'gd.ahr.Gd', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w GD (so/nd/św)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
# ##
## https://stackoverflow.com/questions/15978836/ggplot2-geom-line-for-single-observations-x-factor-y-numeric
p92 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = ga.ahr.Ga, colour = 'ga.ahr.Ga', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w GA (so/nd/św)") +
  ##geom_line(aes(y = ga.ahr.Ga, colour = 'ga.ahr.Ga'), size=.5) +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p93 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = sp.ahr.Sop, colour = 'sp.ahr.Sop', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w SOP (so/nd/św)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));
p94 <- ggplot(hr.data, aes(x = gd.ahr.hr, y = tc.ahr.Tczew, colour = 'tc.ahr.Tczew', group=1)) +
  ggtitle("MEVO: koncentracja rowerów w Tczew (so/nd/św)") +
  geom_line(size=.5) +
  ylab(label="HH") +
  labs(colour = "Miasto:") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

ggarrange(p91, p92,  ncol = 2, nrow = 1)
ggsave(file="mevo_hrly_hrlySNS_gdga.pdf", width=12)

ggarrange(p93, p94, ncol = 2, nrow = 1)
ggsave(file="mevo_hrly_hrlySNS_sptc.pdf", width=12)
