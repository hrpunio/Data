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
okr.scaleD <- seq(0, 42, by=1);
diff.scale <- seq(0, 20, by=2);
diffp.scale <- seq(0, 100, by=10);

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


oo <- read.csv("oo2015_2019.csv", sep = ';',  header=T, na.string="NA");

## https://wybory.gov.pl/sejmsenat2019/pl/wyniki/sejm/pl
##      ------ 2019 -------------+----- 2015 
## PiS  43.59 8051935 235  51.09  37.58  5711687 235
## PO   27.49 5060355 134  29.13  24.09  3661479 138
## SLD  12.56 2319946  49  10.65   7.55  1147102   0
## PSL   8.55 1578523  30   6.52   5.13   779875  16
## 
## KONF  6.81 1256953  11   2.39     --       --  --
## PETRU   NA      NA  NA     NA   7.60  1155370  28
## KUKIZ   NA      NA  NA     NA   8.81  1339094  42
## KORWIN  NA      NA  NA     NA   4.76   722999   0
## RAZEM   NA      NA  NA     NA   3.62   550349   0
oo$diffg <- oo$glosy2019 - oo$glosy2015
oo$diffp <- oo$p2019 - oo$p2015

##str(oo)
##
##cbind(oo$diffp, as.factor(oo$komitet), oo$okr)


oo.pis <- oo %>% filter(komitet=="PiS")  %>% as.data.frame
oo.po  <- oo %>% filter(komitet=="PO")   %>% as.data.frame
oo.sld <- oo %>% filter(komitet=="SLD")  %>% as.data.frame
oo.psl <- oo %>% filter(komitet=="PSL")  %>% as.data.frame
##
oo.pis$diffg

#ggplot(oo.pis, aes(x = okr)) +
#    ggtitle("??", subtitle="??") +
#    ###
#    geom_point(aes(y = p2019, colour = 'PiS'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.po$p2019, colour = 'PO'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.sld$p2019, colour = 'SLD'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.psl$p2019, colour = 'PSL'), size=2, alpha=.5) +
#    ## labels
#    geom_line(aes(y = p2019, colour = 'PiS'), size=.5, alpha=.5,  linetype = "dotted") +
#    geom_line(aes(y = oo.po$p2019, colour = 'PO'), size=.5, alpha=.5, linetype = "dotted") +
#    ylab(label="") +
#    xlab(label="okręg") +
#    labs(colour = "Partia: ") +
#    scale_x_continuous(breaks=okr.scale) +
#    ##scale_y_continuous(breaks=seq(0,8000,by=1000), limits = c(0,8000)) +
#    theme(legend.position="top") +
#    theme(legend.text=element_text(size=12));
#
#ggplot(oo.pis, aes(x = okr)) +
#    ggtitle("??", subtitle="??") +
#    ###
#    geom_point(aes(y = diffg, colour = 'PiS'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.po$diffg, colour = 'PO'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.sld$diffg, colour = 'SLD'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.psl$diffg, colour = 'PSL'), size=2, alpha=.5) +
#    ## labels
#    ylab(label="") +
#    xlab(label="okręg") +
#    labs(colour = "Partia: ") +
#    scale_x_continuous(breaks=okr.scale) +
#    ##scale_y_continuous(breaks=seq(0,8000,by=1000), limits = c(0,8000)) +
#    theme(legend.position="top") +
#    theme(legend.text=element_text(size=12));
#
#ggplot(oo.pis, aes(x = okr)) +
#    ggtitle("??", subtitle="??") +
#    ###
#    geom_point(aes(y = diffp, colour = 'PiS'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.po$diffp, colour = 'PO'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.sld$diffp, colour = 'SLD'), size=2, alpha=.5) +
#    geom_point(aes(y = oo.psl$diffp, colour = 'PSL'), size=2, alpha=.5) +
#    ## labels
#    geom_line(aes(y = diffp, colour = 'PiS'), size=.5, alpha=.5,  linetype = "dotted") +
#    geom_line(aes(y = oo.po$diffp, colour = 'PO'), size=.5, alpha=.5) +
#    ylab(label="") +
#    xlab(label="okręg") +
#    labs(colour = "Partia: ") +
#    scale_x_continuous(breaks=okr.scale) +
#    ##scale_y_continuous(breaks=seq(0,8000,by=1000), limits = c(0,8000)) +
#    theme(legend.position="top") +
#    theme(legend.text=element_text(size=12));
#
##ggplot(oo.pis, aes(x = reorder(okrnr, wyborcy2019), y=wyborcy2019 )) +
#ggplot(oo.pis, aes(x = okr, y=diffp)) +
#  ggtitle("Liczba wyborców: (PKW/2019)") +
#  geom_bar(stat="identity", fill=bar.color,  alpha=.5  ) +
#  scale_y_continuous(breaks=okr.scale) +
#  xlab(label="okręg") +
#  ylab(label="#") +
#  scale_x_continuous(breaks=okr.scale) +
#  ##coord_flip()+
#  theme(plot.title = element_text(hjust = 0.5))
#
#ggplot(oo.po, aes(x = okr, y=diffp)) +
#  ggtitle("Liczba wyborców: (PKW/2019)") +
#  geom_bar(stat="identity", fill=bar.color,  alpha=.5  ) +
#  scale_y_continuous(breaks=okr.scale) +
#  xlab(label="okręg") +
#  ylab(label="#") +
#  ##coord_flip()+
#  scale_x_continuous(breaks=okr.scale) +
#  theme(plot.title = element_text(hjust = 0.5))

## ggplot(data=datn, aes(x=factor(dose), y=length, fill=supp)) +
##    geom_bar(stat="identity", position=position_dodge())
oo.pispo <- oo %>% filter(komitet=="PiS" | komitet == "PO")  %>% as.data.frame
oo.sldpsl <- oo %>% filter(komitet=="SLD" | komitet == "PSL" )  %>% as.data.frame

## https://www.r-bloggers.com/detailed-guide-to-the-bar-chart-in-r-with-ggplot/
##
p1 <- ggplot(data=oo.pispo, aes(x=as.factor(okr), y=diffp, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="p2019 - p2015") +	       
  xlab(label="okręg") +
  annotate("text", x=3, y=10.5, label="Różycka/\nSchetyna", size=2 ) +
  annotate("text", x=19, y=15.0, label="Kaczyński/\nKidawa", size=2 ) +
  annotate("text", x=33, y=13.0, label="Ziobro/\nSienkiewicz", size=2 ) +
  annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +		
  ggtitle("Różnica poparcia dla partii (2019/2015)", subtitle ="2019 - 2015 = różnica odsetka głosów uzyskanych przez komitet")


p2 <- ggplot(data=oo.sldpsl, aes(x=as.factor(okr), y=diffp, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8, alpha=.5) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="%2019 - %2015") +	       
  xlab(label="okręg") +
  annotate("text", x=7, y=-1, label="Sachajko/\nPawłowska", size=2 ) +
  scale_fill_manual(values=c("#999999", "#E69F00")) +
  ggtitle("Różnica poparcia dla partii (2019/2015)", subtitle ="2019 - 2015 = różnica odsetka głosów uzyskanych przez komitet")

p0 <- ggplot(data=oo, aes(x=as.factor(okr), y=diffp, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  #geom_text(data=kk, aes(label=sprintf("%s", diffp), y= diffp), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  scale_x_discrete("Okr", breaks=okr.Fscale, labels=okr.Flabels)+
  scale_y_continuous(breaks=seq(-5, 15, by=2)) +
  #  labels=c("-6","-4", "-2", "0","2", "4","6","8", "10","12","14", "16","18")) +
  ##
  annotate("text", x=19, y=13, label="Kaczyński/Kidawa/\n\nZandberg/Bartoszewski", size=2 ) +
  annotate("text", x=3,  y=-1.1, label="Różycka/Schetyna", size=2 ) +
  annotate("text", x=25, y=-0.9, label="Sellin/Neumann", size=2 ) +	
  annotate("text", x=33, y=-1.5, label="Ziobro/Sienkiewicz", size=2 ) +
  annotate("text", x=32, y=-1.0, label="Malik/Saługa/Czarzasty", size=2 ) +	
  annotate("text", x=12, y=-1.1, label="Bochenek/Niedziela", size=2 ) +
  annotate("text", x=5,  y=-1.1, label="Kwiatkowski/\nSzramka", size=2 ) +
  ##annotate("text", x=19, y=-50000, label="", size=2 ) +
  ##
  geom_hline(yintercept = 0, color="firebrick", alpha=.5, size=1.2) +
  theme(legend.position="top") +
  ylab(label="różnica 2019 - 2015") +	       
  xlab(label="") +
  coord_flip()+
  #### 
  #ggtitle("Głosy oddane na #1 listy  (2019/2015)", subtitle ="2019 - 2015 = różnica głosów")
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Różnica odsetka głosów oddanych na listę  (2019 vs 2015)")


p1
p2

p0
ggsave(file="glosy-diff-listy-2019-2015_h.pdf", width=10, height=10)
