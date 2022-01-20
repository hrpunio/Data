library("dplyr")
library("ggplot2")
library("ggpubr")
##
today <- Sys.Date()
lastDay <- format(today, "%Y-%m-%d")

d <- read.csv("ppw.csv", sep = ';',  header=T, na.string="NA");

## Ostattnie 5 lat
d <- d %>% filter(as.Date(d1) > "2014-12-31") %>% as.data.frame

## data;interwencje;zgu;zp;znk;wypadki;zabici;ranni
##
maxY <- max (d$zabici)
pz <- ggplot(d, aes(x= as.Date(d1), y=zabici)) + 
 geom_line(color="steelblue", size=.4) +
 geom_point(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  ##annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2021-06-01"), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5, alpha=.4) +
  annotate("rect", xmin = as.Date("2021-06-01"), xmax = as.Date("2021-06-01"), ymin = 0, ymax = maxY, color = "green4", size=1.5, alpha=.4) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Wypadki/zabici (wg tygodni/Polska)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$wypadki)
pw <- ggplot(d, aes(x= as.Date(d1), y=wypadki)) + 
 geom_line(color="steelblue", size=.4) +
 geom_point(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  ##annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5, alpha=.4) +
  annotate("rect", xmin = as.Date("2021-06-01"), xmax = as.Date("2021-06-01"), ymin = 0, ymax = maxY, color = "green4", size=1.5, alpha=.4) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/03", vjust = 1.2, size=3, color="darkblue") +
  annotate("text", x = as.Date("2021-06-01"), y=0, label = "01/06", vjust = 1.2, size=3, color="green4") +
 ggtitle("Wypadki (wg tygodni/Polska)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$ranni)
pr <- ggplot(d, aes(x= as.Date(d1), y=ranni)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/03", vjust = 1.2, size=3, color="darkblue") +
  annotate("text", x = as.Date("2021-06-01"), y=0, label = "01/06", vjust = 1.2, size=3, color="green4") +
 ggtitle("Wypadki/ranni (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$znk)
pznk <- ggplot(d, aes(x= as.Date(d1), y=znk)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  ##
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  ## niedziele i święta
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Zatrzymani nietrzeźwi kierujący (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

p1 <- ggarrange(pw,pznk, ncol=2, nrow=1)
p2 <- ggarrange(pr,pz, ncol=2, nrow=1)
p3 <- ggarrange(pw, pr, pz, ncol=3, nrow=1)
ggsave(plot=p1, "PPW_1.png", width=15)
ggsave(plot=p2, "PPW_2.png", width=15)
ggsave(plot=p3, "PPW_w.png", width=15)

ggsave(plot=pw, "PPW_w1w.png", width=15)
ggsave(plot=pz, "PPW_w1z.png", width=15)

