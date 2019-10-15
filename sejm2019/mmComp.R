library(ggplot2)
library(dplyr)
library(data.table)
options(dplyr.print_max = 1e9)

##### TODO
## Dodać etykiety dla dużych wartości HH
## Sprawdzić pmax
##
## Wnioski:
## Zmniejszenie okręgów = wzrost rywalizacji na poziomie partii (wydaje się)

bar.color <- "blue";
okr.scale <- seq(0, 42, by=2);

okr.Fscale <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
"11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21",
"22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32",
"33", "34", "35", "36", "37", "38", "39", "40", "41");

okr.Flabels <- c( "1/Legnica", "2/Wałbrzych", "3/Wrocław",
"4/Bydgoszcz", "5/Toruń", "6/Lublin", "7/Chełm", "8/ZielonaG",
"9/Łódź", "10/PiotrkówT", "11/Sieradz", "12/Kraków", "13/Kraków",
"14/NowySącz", "15/Tarnów", "16/Płock", "17/Radom", "18/Siedlce",
"19/Warszawa", "20/Warszawa", "21/Opole", "22/Krosno", "23/Rzeszów",
"24/Białystok", "25/Gdańsk", "26/Słupsk", "27/Bielsko-B",
"28/Częstochowa", "29/Katowice", "30/Bielsko-B", "31/Katowice",
"32/Katowice", "33/Kielce", "34/Elbląg", "35/Olsztyn", "36/Kalisz",
"37/Konin", "38/Piła", "39/Poznań", "40/Koszalin", "41/Szczecin"
)

okr.scaleD <- seq(0, 42, by=1);
diff.scale <- seq(0, 20, by=2);
diffp.scale <- seq(0, 100, by=10);

# okr;komitet;nrk;glosy2015;p2015;Idk;empty;komitet2;kto;glosy2019
kk <- read.csv("mm2015_2019.csv", sep = ';',  header=T, na.string="NA");
kk <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet=="SLD" | komitet=="PSL" | komitet == "KONF")  %>% as.data.frame

okr.label <- sprintf ("%10.10s-%i", kk$okrname, kk$okr)

kk$diffm <- kk$glosy2019 - kk$glosy2015
kk$okr.label <- okr.label

kk.pis <- oo %>% filter(komitet=="PiS")  %>% as.data.frame
kk.po  <- oo %>% filter(komitet=="PO")   %>% as.data.frame
kk.sld <- oo %>% filter(komitet=="SLD")  %>% as.data.frame
kk.psl <- oo %>% filter(komitet=="PSL")  %>% as.data.frame
##
## okr/pis/po: 
### 12  Bochenek  Niedziela
### 19  Kaczyński Kidawa
###  3  Różycka Schetyna
### 33  Ziobro Sienkiewicz

### 33 
## okr
## ggplot(data=datn, aes(x=factor(dose), y=length, fill=supp)) +
##    geom_bar(stat="identity", position=position_dodge())
kk.pispo <- kk %>% filter(komitet=="PiS" | komitet == "PO")  %>% as.data.frame
kk.sldpsl <- kk %>% filter(komitet=="SLD" | komitet == "PSL" )  %>% as.data.frame

## https://www.r-bloggers.com/detailed-guide-to-the-bar-chart-in-r-with-ggplot/
##
##dev.size(10,8)
# options(width=10, height=10) 

p1 <- ggplot(data=kk, aes(x=as.factor(okr), y=diffm, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="2019 - 2015") +	       
  xlab(label="") +
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Głosy oddane na #1 listy  (2019/2015)", subtitle ="2019 - 2015 = różnica głosów")

p0 <- ggplot(data=kk, aes(x=as.factor(okr), y=diffm, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  scale_x_discrete("Okr", breaks=okr.Fscale, labels=okr.Flabels)+
  scale_y_continuous(breaks=seq(-50000, 180000, by=10000),
    labels=c("-50","-40", "-30", "-20","-10", "0","10","20", "30","40","50", "60","70","80", "90",
                "100","110", "120","130","140", "150","160","170", "180")) +
  ##
  annotate("text", x=19, y=-15000, label="Kaczyński/Kidawa/\nZandberg/Bartoszewski", size=2 ) +
  annotate("text", x=3,  y=-12000, label="Różycka/Schetyna", size=2 ) +
  annotate("text", x=25,  y=-16000, label="Sellin/Neumann", size=2 ) +	
  annotate("text", x=33, y=-19000, label="Ziobro/Sienkiewicz", size=2 ) +
  annotate("text", x=32, y=-20000, label="Malik/Saługa/Czarzasty", size=2 ) +	
  annotate("text", x=12, y=25000, label="Bochenek/Niedziela", size=2 ) +
  annotate("text", x=5,  y=-22000, label="Kwiatkowski/\nSzramka", size=2 ) +
  ##annotate("text", x=19, y=-50000, label="", size=2 ) +
  ##
  ##geom_abline(xintercept = 0, alpha=.25, size=1) +
  geom_hline(yintercept = 0, color="firebrick", alpha=.5, size=1.2) +
  theme(legend.position="top") +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ylab(label="Głosy w tys (różnica 2019 - 2015)") +	       
  xlab(label="") +
  coord_flip()+
  #### 
  #ggtitle("Głosy oddane na #1 listy  (2019/2015)", subtitle ="2019 - 2015 = różnica głosów")
  ggtitle("Głosy oddane na #1 listy  (2019 vs 2015)")

p2 <- ggplot(data=kk.pispo, aes(x=as.factor(okr), y=diffm, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="2019 - 2015") +	       
  xlab(label="") +
  annotate("text", x=3, y=65000, label="Różycka/\nSchetyna", size=2 ) +
  annotate("text", x=19, y=120000, label="Kaczyński/\nKidawa", size=2 ) +
  annotate("text", x=33, y=100000, label="Ziobro/\nSienkiewicz", size=2 ) +
  annotate("text", x=12, y=65000, label="Bochenek/\nNiedziela", size=2 ) +
  ggtitle("Głosy oddane na #1 listy  (2019/2015)", subtitle ="2019 - 2015 = różnica głosów")

p3 <- ggplot(data=kk.sldpsl, aes(x=as.factor(okr), y=diffm, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="2019 - 2015") +	       
  xlab(label="") +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  annotate("text", x=5, y=-6000, label="Kwiatkowski/\nSzramka", size=2 ) +
  annotate("text", x=19, y=50000, label="Zandberg/\nBartoszewski", size=2 ) +
  ggtitle("Głosy oddane na #1 listy  (2019/2015)", subtitle ="2019 - 2015 = różnica głosów")

##pdf(file="mygraphic.pdf",width=1000,height=800)

p1
ggsave(file="glosy-diff-jedynki-2019-2015_v.pdf", width=12, height=8)
p0
ggsave(file="glosy-diff-jedynki-2019-2015_h.pdf", width=10, height=10)

p2
p3
dev.off()
