library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(data.table)
options(dplyr.print_max = 1e9)

okr.Fscale <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
"22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32",
"33", "34", "35", "36", "37", "38", "39", "40", "41");
okr.FscaleLabs <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
"22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32",
"33", "34", "35", "36", "37", "38", "39", "40", "41");

kk <- read.csv("kandydaci_wyniki_2015_2019.csv", sep = ';',  header=T, na.string="NA");
## kk <- kk[complete.cases(kk), ] ## 

kk.total <- group_by (kk, rok) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 
kk.total
## dokładniej
group_by (kk, rok, komitet) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 

kk <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet=="SLD" | komitet=="PSL" 
  | komitet == "PETRU" | komitet == "KUKIZ" | komitet == "PRAZEM"
  | komitet == "KONFEDERACJA" | komitet == "KO")  %>% as.data.frame
## ile teraz?
group_by (kk, rok) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 
group_by (kk, rok, komitet) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 

kk50 <- kk %>% filter(glosy < 50000);
kk25 <- kk %>% filter(glosy < 25000);

str(kk)

kk.pispo <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet == "KO")  %>% as.data.frame
kk.sldpsl <- kk %>% filter(komitet=="SLD" | komitet == "PSL")  %>% as.data.frame

ggplot(kk.pispo, aes(x=procent, colour=as.factor(rok), fill=as.factor(rok) )) +
  ggtitle("Wybory 2015/2019: Kandydaci wg % głosów w okręgu (PiS vs PO)") +
  xlab(label="% głosów zdobytych") + ylab(label="liczba kandydatów") +
  theme(legend.position="top") +
  theme(legend.title=element_blank()) +
  geom_histogram(binwidth=.5, alpha=.5, position="identity") +
  scale_color_manual(values=c("coral3", "darkcyan"))  +
  geom_freqpoly(binwidth=.5, size=1, position="identity")	


ggplot(kk.sldpsl, aes(x=procent, colour=as.factor(rok), fill=as.factor(rok))) +
  ggtitle("Wybory 2015/2019: Kandydaci wg % głosów w okręgu (SLD vs PSL)") +
  ##xlab(label="x") + ylab(label="N") +
  xlab(label="% głosów zdobytych") + ylab(label="liczba kandydatów") +
  theme(legend.position="top") +
  theme(legend.title=element_blank()) +
  geom_histogram(binwidth=.5, alpha=.5, position="identity") +
  scale_color_manual(values=c("coral3", "darkcyan"))  +
  geom_freqpoly(binwidth=.5, size=1, position="identity")	

##kk <- mutate (partia = recode(partia, "" = 3, "neutral" = 2))
kk <- kk %>% mutate(partia=str_replace(partia, "Polska Razem Zjednoczona Prawica", "PJGowina")) %>% as.data.frame()
kk <- kk %>% mutate(komitet=str_replace(komitet, "KO", "PO")) %>% as.data.frame()
kk <- kk %>% mutate(partia=str_replace(partia, "SolidarnaPolska", "SPZZ")) %>% as.data.frame()
kk <- kk %>% mutate(partia=str_replace(partia, "LewicaRazem", "Razem")) %>% as.data.frame()
kk <- kk %>% mutate(partia=str_replace(partia, "PRAZEM", "Razem")) %>% as.data.frame()

## Pomijamy BEZPARTYJNY
kk.bzp <- kk %>% filter(partia=="PiS" | partia=="PO" | partia=="SLD" | partia=="PSL" 
  | partia=="PJGowina" | partia=="SPZZ" | partia=="Wiosna" | partia == "Twój Ruch"
  | partia=="PJGowina" | partia=="ZIELONI" | partia == "Zieloni"
  | partia=="Nowoczesna" | partia=="Razem" 
  | partia == "xxBEZPARTYJNY")  %>% as.data.frame
#group_by (kk, rok, komitet, partia) %>% summarise( n = n()) %>% as.data.frame 
kk.p <- group_by (kk.bzp, rok, partia) %>% summarise( n = n()) %>% as.data.frame 

p0 <- ggplot(data=kk.p, aes(x=as.factor(partia), y=n, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=2.5 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  theme(legend.title=element_blank()) +
  ylab(label="liczba kandydatów") +
  xlab(label="") +
  annotate("text", x=10, y=710, label="SPZZ -- Solidarna Polska", size=3, alpha=.5 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Kandydujący członkowie partii",
    subtitle ="Bez kandydatów z partii ,egzotycznych'/bezpartyjnych (afiliacje podane przez PKW)")

kk.mm <- filter (kk.bzp, mandat == "t"); ## 
kk.mm.p <- group_by (kk.mm, rok, partia) %>% summarise( n = n()) %>% as.data.frame 

p1 <- ggplot(data=kk.mm.p, aes(x=as.factor(partia), y=n, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  geom_text(data=kk.mm.p, aes(label=sprintf("%s", n), y= n), alpha=.5, vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  theme(legend.title=element_blank()) +	
  ylab(label="Mandaty") +
  xlab(label="") +
  annotate("text", x=8.7, y=185, label="SPZZ -- Solidarna Polska", size=3, alpha=.5 ) +
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Mandaty wg afiliacji partyjnej (a nie komitetów wyborczych)",
    subtitle ="Bez kandydatów z partii ,egzotycznych'/bezpartyjnych (afiliacje podane przez PKW)")

p0
p1
## ## ##
kks <- group_by (kk, rok, nrk) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 
kks.total <- group_by (kks, rok) %>% summarise( sumg = sum(sumg)) %>% as.data.frame 

kks

kks.total

p2 <- ggplot(data=kks, aes(x=as.factor(nrk), y=sumg, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kks, aes(label=sprintf("%.2f", n), y= n), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  scale_y_continuous(breaks=seq(0,7000000,by=1000000), labels=c("0", "1","2","3","4","5","6","7"),
      limits = c(0,7000000)) +
  theme(legend.position="top") +
  ylab(label="głosy (mln)") +
  xlab(label="Numer miejsca") +
  theme(legend.title=element_blank()) +		
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Suma głosów wg miejsc na listach", subtitle ="")

p2

kk4 <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet=="SLD" | komitet=="PSL" | komitet == "KO")  %>% as.data.frame
kks4 <- group_by (kk4, rok, nrk) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 

p24 <- ggplot(data=kks4, aes(x=as.factor(nrk), y=sumg, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kks, aes(label=sprintf("%.2f", n), y= n), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
    scale_y_continuous(breaks=seq(0,7000000,by=1000000), labels=c("0", "1","2","3","4","5","6","7"),
      limits = c(0,7000000)) +
  theme(legend.position="top") +
  ylab(label="głosy (mln)") +
  xlab(label="Numer miejsca") +
  theme(legend.title=element_blank()) +	
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Suma głosów wg miejsc na listach (PiS/PO/SLD/PSL)", subtitle ="")

kk2 <- kk4 %>% filter(komitet=="PiS" | komitet=="PO" | komitet == "KO")  %>% as.data.frame
kks2 <- group_by (kk2, rok, nrk) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 

p22 <- ggplot(data=kks2, aes(x=as.factor(nrk), y=sumg, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kks, aes(label=sprintf("%.2f", n), y= n), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
      scale_y_continuous(breaks=seq(0,7000000,by=1000000), labels=c("0", "1","2","3","4","5","6","7"),
      limits = c(0,7000000)) +
  theme(legend.position="top") +
  ylab(label="głosy (mln)") +
  xlab(label="Numer miejsca") +
  theme(legend.title=element_blank()) +	
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Suma głosów wg miejsc na listach (PiS/PO)", subtitle ="")


p24
p22

###
kk.mm <- kk %>% filter(mandat=="t")  %>% as.data.frame
kk.mm.s <- group_by (kk.mm, rok, nrk) %>% summarise( sumg = sum(glosy, na.rm=T)) %>% as.data.frame 
kk.mm.n <- group_by (kk.mm, rok, nrk) %>% summarise( n = n()) %>% as.data.frame 

kk.mm.s
kk.mm.n

p10 <- ggplot(data=kk.mm.n, aes(x=as.factor(nrk), y=n, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  geom_text(data=kk.mm.n, aes(label=sprintf("%s", n), y= n), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="Mandaty") +
  xlab(label="Numer miejsca") +
  theme(legend.title=element_blank()) +	
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Mandaty wg numeru miejsca na liście", subtitle ="Bez kandydatów z partii ,egzotycznych' i bezpartyjnych")

p11 <- ggplot(data=kk.mm.s, aes(x=as.factor(nrk), y=sumg, fill=as.factor(rok) )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk.mm.s, aes(label=sprintf("%s", sumg), y= sumg), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  scale_y_continuous(breaks=seq(0,7000000,by=1000000), labels=c("0", "1","2","3","4","5","6","7"),
    limits = c(0,7000000)) +
  theme(legend.position="top") +
  ylab(label="głosy (mln)") +
  xlab(label="Numer miejsca") +
  theme(legend.title=element_blank()) +	
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Wybory 2015/2019: Głosy łącznie wg numeru miejsca na liście", subtitle ="Bez kandydatów z partii ,egzotycznych' i bezpartyjnych")

p10
p11

## ## ##

kk.mm.s

kk.mm.sumg <- spread(kk.mm.s, key=rok, value=sumg) %>% rename("y2015" = "2015", "y2019" = "2019") 
kk.mm.sumg

kk.mm.sumg$diff <- kk.mm.sumg$y2019 - kk.mm.sumg$y2015
kk.mm.sumg$wdiff <- (kk.mm.sumg$y2019 - kk.mm.sumg$y2015)/kk.mm.sumg$y2015 * 100

p45 <- ggplot(kk.mm.sumg) +  
 ggtitle("Wybory 2015/2019: różnice w liczbie głosów a miejsce na liście") +
 ylab(label="głosy (tys)") +
 xlab(label="numer na liście") +
   scale_y_continuous(breaks=seq(0,2200000,by=200000), labels=c("0", "200","400","600","800",
      "1000","1200","1400", "1600","1800", "2000","2200") ) +
 geom_bar(aes(y =kk.mm.sumg$diff, as.factor(nrk) ), stat="identity", fill="#e2891d")

p46 <- ggplot(kk.mm.sumg) +  
 ggtitle("Wybory 2015/2019: względne różnice w liczbie głosów a miejsce na liście", subtitle="różnica/r2015 (w %)") +
 ylab(label="%") +
 xlab(label="numer na liście") +
 geom_text(data=kk.mm.sumg, aes(label=sprintf("%i", as.integer(wdiff)), x=as.factor(nrk), y= wdiff), color="#e2891d", vjust=-1.25, size=3 ) +
 geom_text(data=kk.mm.sumg, aes(label=sprintf("%i", as.integer(wdiff)), x=as.factor(nrk), y= wdiff), color="#e2891d", vjust=+1.25, size=3 ) +
 scale_x_discrete (breaks=okr.Fscale, labels=okr.FscaleLabs) +
 scale_y_continuous(breaks=seq(-100,260,by=20)) +
 geom_bar(aes(y =kk.mm.sumg$wdiff, x=as.factor(nrk) ), stat="identity", fill="#e2891d")

p45 
p46
