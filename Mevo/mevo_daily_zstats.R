## Odsetek stacji wg liczby dostępnych rowerów
require(ggplot2)
require(ggpubr)

d <- read.csv("MEVO_DAILY_BIKES.csv", sep = ';',  header=T, na.string="NA");
##rains <- read.csv("mevo_rains_daily.csv", sep = ';',  header=T, na.string="NA");

mstat <- 100 - d$sstat;
d["mstat"] <- mstat;
##d["rains"] <- rains$opad

p1 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO stacje: liczba dostępnych rowerów (zstat=0, sstat<2, mstat>1)") +
  geom_line(aes(y = zstat, colour = 'zstat'), size=.25) +
  geom_line(aes(y = sstat, colour = 'sstat'), size=.25) +
  geom_line(aes(y = mstat, colour = 'mstat'), size=.25) +
  geom_smooth(aes(x = as.Date(day), y=zstat, colour='zstat'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=sstat, colour='sstat'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=mstat, colour='mstat'), method="loess", size=.5) +
  ##geom_line(aes(y = rains, colour = 'rains'), size=1) +
  ylab(label="%") +
  ##theme(legend.title=element_blank()) +
  labs(colour = "Rowery: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p2 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO stacje: 0 dostępnych rowerów (ga =gdynia, gd =gdańsk)") +
  geom_line(aes(y = gd0p,  colour = 'gd0p'), size=.25) +
  geom_line(aes(y = ga0p,  colour = 'ga0p'), size=.25) +
  geom_smooth(aes(x = as.Date(day), y=gd0p, colour='gd0p'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=ga0p, colour='ga0p'), method="loess", size=.5) +
  ylab(label="%") +
  ##theme(legend.title=element_blank()) +
  labs(colour = "Rowery: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p3 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO stacje: max 1 dostępnych rowerów (ga=gdynia, gd=gdańsk)") +
  geom_line(aes(y = gd1p,  colour = 'gd1p'), size=.25) +
  geom_line(aes(y = ga1p,  colour = 'ga1p'), size=.25) +
  geom_smooth(aes(x = as.Date(day), y=gd1p, colour='gd1p'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=ga1p, colour='ga1p'), method="loess", size=.5) +
  ylab(label="%") +
  ##theme(legend.title=element_blank()) +
  labs(colour = "Rowery: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

p4 <- ggplot(d, aes(x = as.Date(day))) +
  ggtitle("MEVO stacje (Sopot): liczba dostępnych rowerów (sop0p=0 / sop1p <2)") +
  geom_line(aes(y = sop1p,  colour = 'sop1p'), size=0.25) +
  geom_line(aes(y = sop0p,  colour = 'sop0p'), size=0.25) +
  geom_smooth(aes(x = as.Date(day), y=sop1p, colour='sop1p'), method="loess", size=.5) +
  geom_smooth(aes(x = as.Date(day), y=sop0p, colour='sop0p'), method="loess", size=.5) +
  ylab(label="%") +
  ##theme(legend.title=element_blank()) +
  labs(colour = "Rowery: ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=10));

ggarrange(p1, p2, p3, p4, ncol = 2, nrow = 2)
ggsave(file="mevo_daily_zstats.pdf", width=12)
