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


kk <- read.csv("kk2015_2019.csv", sep = ';',  header=T, na.string="NA");
kk <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet=="SLD" | komitet=="PSL" | komitet == "KONF")  %>% as.data.frame
#kk <- kk %>% filter(komitet=="PiS" | komitet=="PO" | komitet=="SLD" | komitet=="PSL" | komitet == "KONF")  %>% as.data.frame

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

kk$diffm <- kk$m2019 - kk$m2015


kk.pis <- oo %>% filter(komitet=="PiS")  %>% as.data.frame
kk.po  <- oo %>% filter(komitet=="PO")   %>% as.data.frame
kk.sld <- oo %>% filter(komitet=="SLD")  %>% as.data.frame
kk.psl <- oo %>% filter(komitet=="PSL")  %>% as.data.frame
##

## ggplot(data=datn, aes(x=factor(dose), y=length, fill=supp)) +
##    geom_bar(stat="identity", position=position_dodge())
kk.pispo <- kk %>% filter(komitet=="PiS" | komitet == "PO")  %>% as.data.frame
kk.sldpsl <- kk %>% filter(komitet=="SLD" | komitet == "PSL" )  %>% as.data.frame

## https://www.r-bloggers.com/detailed-guide-to-the-bar-chart-in-r-with-ggplot/
##
p0 <- ggplot(data=kk, aes(x=as.factor(komitet), y=diffm, fill=komitet )) +
    geom_bar(stat="identity", position=position_dodge(width=.4), width=.8,  alpha=.5) +
  geom_text(data=kk, aes(label=sprintf("%s", diffm), y= diffm), vjust=-1.25, size=3 ) +
  #scale_x_continuous(breaks=seq(1,41,by=1), limits = c(1,41)) +
  #scale_y_continuous(breaks=seq(-8,18,by=2), limits = c(-3,15)) +
  theme(legend.position="top") +
  ylab(label="m2019 - m2015") +	       
  xlab(label="") +
  #annotate("text", x=3, y=10.5, label="Różycka/\nSchetyna", size=2 ) +
  #annotate("text", x=19, y=15.0, label="Kaczyński/\nKidawa", size=2 ) +
  #annotate("text", x=33, y=13.0, label="Ziobro/\nSienkiewicz", size=2 ) +
  #annotate("text", x=39, y=10.2, label="Emilewicz/\nJaśkowiak", size=2 ) +
  labs(caption = "Source: https://github.com/hrpunio/Data/tree/master/sejm2019") +
  ggtitle("Zdobyte mandaty (2019/2015)", subtitle ="2019 - 2015 = różnica liczby mandatów")

ggsave(file="mandaty-diff-komitety-2019-2015_v.pdf", width=6, height=6)