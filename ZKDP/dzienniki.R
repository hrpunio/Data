library("ggplot2")
library("dplyr")
library("tidyr")
library("scales")
library("ggthemes")
library("ggpubr")


NIKW <- "© NI-KW @ github.com/knsm-psw/NI-KW"
USC <- 'ZKDP | https://github.com/hrpunio/Data/tree/master/ZKDP'
source <- sprintf ("źródło: %s", USC)

z <- read.csv("dzienniki2015-2020.csv", sep = ';',  header=T, na.string="NA" )
z <- z %>% filter (wydawca == 'Polska Press Sp. z o.o.') %>% as.data.frame();

pp <- ggplot(z, aes(x= as.Date(date, format="%Y-%m-%d"), y=naklad )) +
 geom_line(size=.5 ) +
 geom_point(size=2.5, alpha=.3) +
 ##scale_y_continuous(breaks=seq(2500, 25000, by=2500)) +
 ##coord_cartesian(ylim = c(0, max(z$nn, na.rm = T))) +
 xlab(label="") +
 ylab(label="tys") +
 theme_nikw()+
 labs(caption=source, color='Rok') +
 facet_wrap( ~tytul, scales = "free_y") +
 ggtitle("Polska Press (2015--2020)")

ggsave(plot=pp, "dzienniki_pp.png", width=12, height = 12)

pp
##
