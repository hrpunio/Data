library("dplyr")
library("ggplot2")
library("ggpubr")
##
today <- Sys.Date()
lastDay <- format(today, "%Y-%m-%d")

d <- read.csv("pp.csv", sep = ';',  header=T, na.string="NA");

d <- d %>% filter(as.Date(data) > "2019-12-31") %>% as.data.frame

## data;interwencje;zgu;zp;znk;wypadki;zabici;ranni
##
maxY <- max (d$zabici)
pz <- ggplot(d, aes(x= as.Date(data), y=zabici)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Wypadki/zabici (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$wypadki)
pw <- ggplot(d, aes(x= as.Date(data), y=wypadki)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Wypadki (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$ranni)
pr <- ggplot(d, aes(x= as.Date(data), y=ranni)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Wypadki/ranni (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$interwencje)
pi <- ggplot(d, aes(x= as.Date(data), y=interwencje)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Interwencje (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

maxY <- max (d$znk)
pznk <- ggplot(d, aes(x= as.Date(data), y=znk)) + 
 geom_line(color="steelblue", size=1) +
 xlab(label="") +
 theme(plot.subtitle=element_text(size=8, hjust=0, color="black")) +
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date(lastDay), ymin = 0, ymax = maxY, alpha = .2) +
  ##
  annotate("rect", xmin = as.Date("2020-03-12"), xmax = as.Date("2020-03-12"), ymin = 0, ymax = maxY, color = "darkblue", size=1.5) +
  ## niedziele i święta
  #annotate("rect", xmin = as.Date("2020-01-01"), xmax = as.Date("2020-01-01"), ymin = 0, ymax = maxY, color = "red", size=.5) +
  #annotate("rect", xmin = as.Date("2020-01-06"), xmax = as.Date("2020-01-06"), ymin = 0, ymax = maxY, color = "red", size=.5) +
  #annotate("rect", xmin = as.Date("2020-03-22"), xmax = as.Date("2020-03-22"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-03-15"), xmax = as.Date("2020-03-15"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-03-08"), xmax = as.Date("2020-03-08"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-03-01"), xmax = as.Date("2020-03-01"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-02-23"), xmax = as.Date("2020-02-23"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-02-16"), xmax = as.Date("2020-02-16"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-02-09"), xmax = as.Date("2020-02-09"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-02-02"), xmax = as.Date("2020-02-02"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-01-26"), xmax = as.Date("2020-01-26"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-01-19"), xmax = as.Date("2020-01-19"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-01-12"), xmax = as.Date("2020-01-12"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  #annotate("rect", xmin = as.Date("2020-01-05"), xmax = as.Date("2020-01-05"), ymin = 0, ymax = maxY, color = "red", size=.2) +
  ##
  annotate("text", x = as.Date("2020-03-12"), y=0, label = "12/3", vjust = 1.2, size=3, color="darkblue") +
 ggtitle("Zatrzymani nietrzeźwi kierujący (Polska/2020)", subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

p1 <- ggarrange(pi,pw, ncol=2, nrow=1)
p2 <- ggarrange(pr,pz, ncol=2, nrow=1)
p3 <- ggarrange(pw, pr,pz, ncol=3, nrow=1)
ggsave(plot=p1, "PP_1.png", width=15)
ggsave(plot=p2, "PP_2.png", width=15)
ggsave(plot=p3, "PP_w.png", width=15)

ggsave(plot=pznk, "PP_pznk.png")
