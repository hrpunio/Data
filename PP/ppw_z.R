library("dplyr")
library("ggplot2")
library("ggpubr")
library("scales")
##
today <- Sys.Date()
lastDay <- format(today, "%Y-%m-%d")

d <- read.csv("ppw.csv", sep = ';',  header=T, na.string="NA") %>%
 select(rok, nrt, zabici, d1)

### Wszystkie lata bo kolor są nieistotne
p1 <- ggplot(d, aes(x= as.factor(rok), y= zabici, fill=as.factor(rok))) + 
 geom_boxplot() +
 xlab(label="") +
 scale_y_continuous(breaks=seq(0,100, by=10)) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black"), legend.position = "none") +
 ggtitle("Wypadki/zabici wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

ggsave(plot=p1, "PPW_Zabici_1.png", width=12)
p1
## Od 2016
d <- d %>% filter(as.Date(d1) > "2015-12-31") %>% as.data.frame

maxY <- max (d$zabici)
p2 <- ggplot(d, aes(x= as.Date(d1), y=zabici)) + 
 geom_point(color="steelblue", size=.4) +
 geom_smooth(method="loess", color="red", size=1, se=F, span=.5) +
 geom_line(color="steelblue", size=.4, alpha=.4) +
 xlab(label="") +
 scale_x_date( labels = date_format("%Y"), breaks ="1 year") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("rect", xmin = as.Date("2021-06-01"), xmax = as.Date("2021-06-01"), ymin = 0, ymax = maxY, color = "green4", size=1.5, alpha=.4) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
  annotate("text", x = as.Date("2021-06-01"), y=0, label = "01/06", vjust = 1.2, size=3, color="green4") +
 ggtitle("Wypadki/zabici wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

ggsave(plot=p2, "PPW_Zabici_2.png", width=12)
p2

#dz <- d %>% group_by(nrt) %>%
#  summarise (rok = 0, zt = mean(zabici))

p3 <- d %>% mutate (r=as.factor(rok)) %>%
  ggplot(aes(x= nrt, color=r,
             y=zabici, group=r)) + 
 geom_point(size=.4) +
 geom_smooth(se=F, span=.5 ) +
 #facet_wrap(~ rok, , scales = "fixed") +
 geom_line(size=.4, alpha=.9) +
 xlab(label="") +
 ##scale_x_date( labels = date_format("%Y"), breaks ="1 year") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 ggtitle("Wypadki/zabici wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") +
 geom_blank()


ggsave(plot=p3, "PPW_Zabici_3.png", width=12)
p3
