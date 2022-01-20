library("dplyr")
library("ggplot2")
library("ggpubr")
library("scales")
##
today <- Sys.Date()
lastDay <- format(today, "%Y-%m-%d")

d <- read.csv("ppw.csv", sep = ';',  header=T, na.string="NA");

### Wszystkie lata bo kolor są nieistotne
pw_b <- ggplot(d, aes(x= as.factor(rok), y= wypadki, fill=as.factor(rok))) + 
 geom_boxplot() +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black"), legend.position = "none") +
 scale_y_continuous(breaks=seq(0,1000, by=50)) +
 ggtitle("Wypadki wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

pz_b <- ggplot(d, aes(x= as.factor(rok), y= zabici, fill=as.factor(rok))) + 
 geom_boxplot() +
 xlab(label="") +
 scale_y_continuous(breaks=seq(0,100, by=10)) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black"), legend.position = "none") +
 ggtitle("Wypadki/zabici wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

p6 <- ggarrange(pw_b, pz_b, ncol=2, nrow=1)
ggsave(plot=p6, "PPW_wypadki_wB.png", width=15)

###

d <- d %>% filter(as.Date(d1) > "2015-12-31") %>% as.data.frame

## data;interwencje;zgu;zp;znk;wypadki;zabici;ranni
##rok;nrt;interwencje;in;zng;zngn;zp;zpn;znk;znkn;wypadki;wn;zabici;zn;ranni;rn;d1;d7
##2008;48;NA;NA;4542;6;2015;6;2183;6;789;6;77;6;739;6;2008-12-01;2008-12-06
##2008;49;NA;NA;5518;7;2670;7;2450;7;867;7;102;7;1035;7;2008-12-07;2008-12-13
##2008;50;NA;NA;4825;7;2485;7;2026;7;1011;7;86;7;1260;7;2008-12-15;2008-12-19
##2008;51;NA;NA;1357;2;489;2;692;2;174;2;26;2;243;2;2008-12-21;2008-12-27
##
maxY <- max (d$interwencje)
p.interwencje <- ggplot(d, aes(x= as.Date(d1), y=interwencje)) +
 geom_point(color="steelblue", size=.4) +
 geom_smooth(method="loess", color="red", size=1, se=F, span=.5) +
 geom_line(color="steelblue", size=.4, alpha=.4) +
 xlab(label="") +
 scale_x_date( labels = date_format("%Y"), breaks ="1 year") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Interwencje wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html")

maxY <- max (d$zng)
p.zng <- ggplot(d, aes(x= as.Date(d1), y=zng)) +
 geom_point(color="steelblue", size=.4) +
 geom_smooth(method="loess", color="red", size=1, se=F, span=.5) +
 geom_line(color="steelblue", size=.4, alpha=.4) +
 xlab(label="") +
 scale_x_date( labels = date_format("%Y"), breaks ="1 year") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Zatrzymani na gorącym uczynku wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html")


maxY <- max (d$zabici)
pz <- ggplot(d, aes(x= as.Date(d1), y=zabici)) + 
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

maxY <- max (d$wypadki)
pw <- ggplot(d, aes(x= as.Date(d1), y=wypadki)) + 
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
 ggtitle("Wypadki wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$ranni)
pr <- ggplot(d, aes(x= as.Date(d1), y=ranni)) + 
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
 ggtitle("Wypadki/ranni wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$znk)
pznk <- ggplot(d, aes(x= as.Date(d1), y=znk)) + 
 geom_point(color="steelblue", size=.4) +
 geom_smooth(method="loess", color="red", size=1, se=F, span=.5) +
 geom_line(color="steelblue", size=.4, alpha=.4) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  ##
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  ## niedziele i święta
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Zatrzymani nietrzeźwi kierujący wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

p1 <- ggarrange(pw,pznk, ncol=2, nrow=1)
p2 <- ggarrange(pr,pz, ncol=2, nrow=1)
##p3 <- ggarrange(pw, pr, pz, ncol=3, nrow=1)
p4 <- ggarrange(p.interwencje, p.zng, ncol=2, nrow=1)


ggsave(plot=p1, "PPW_wypadki_w.png", width=15)
ggsave(plot=p2, "PPW_zabici_w.png", width=15)
ggsave(plot=p4, "PPW_interwencje_w.png", width=15)
##
## 

##maxY <- max (d$wypadki)
pw_a <- ggplot(d, aes(x= nrt, y= wypadki, color=as.factor(rok))) + 
 geom_point(size=.4) +
 geom_smooth(method="loess", se=F, span=.25) +
 xlab(label="") +
 scale_x_continuous(breaks=seq(0,54, by=4)) +
 scale_y_continuous(breaks=seq(0,1000, by=50)) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 ggtitle("Wypadki wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 


pz_a <- ggplot(d, aes(x= nrt, y= zabici, color=as.factor(rok))) + 
 geom_point(size=.4) +
 geom_smooth(method="loess", se=F, span=.25) +
 xlab(label="") +
 scale_x_continuous(breaks=seq(0,54, by=4)) +
 scale_y_continuous(breaks=seq(0,100, by=10)) +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
 ggtitle("Wypadki/zabici wg tygodni", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

p5 <- ggarrange(pw_a, pz_a, ncol=2, nrow=1)

ggsave(plot=p5, "PPW_wypadki_wA.png", width=15)

