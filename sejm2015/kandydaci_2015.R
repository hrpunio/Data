#
#library(reshape);
require(ggplot2);
#library(dplyr)
#
kandydaci <- read.csv("Kandydaci_2015.csv", sep = ';',  header=T, na.string="NA");
kandydaci_all <- kandydaci;

## 90% kandydatów z każdej partii
## http://www.statmethods.net/management/subset.html
kandydaci <- subset (kandydaci, ( (komitet == "PETRU" & glosy < 2002) |
   (komitet == "KUKIZ" & glosy < 2748 ) | (komitet == "PSL" & glosy < 2218) | 
   (komitet == "PO" & glosy < 10238 )| (komitet == "PiS" & glosy < 16286) ));
##kandydaci <- subset (kandydaci, (glosy < 10000  ));

str(kandydaci);

#qplot(glosy, data=kandydaci, geom="histogram", binwidth=2000, facets=komitet ~ .)
qplot(glosy, data=kandydaci, geom="histogram", facets=komitet ~ .)

#temp$quartile <- ntile(temp$value, 4) 
# 9th decyl
#1 KUKIZ  2747.8
#2 PETRU  2001.8
#3   PiS 16285.0
#4    PO 10237.5
#5   PSL  2217.5

