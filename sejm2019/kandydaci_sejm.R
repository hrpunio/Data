require(ggplot2)
require(ggpubr)


#  dist.monthly <- ggplot(d, aes(month, dist)) +
#     ggtitle("MEVO: dystans miesięczny łącznie") +
#     ylab(label="tys km") +
#     scale_y_continuous(breaks=c(100000, 200000, 300000, 400000, 500000, 600000,700000, 800000, 900000),
#     labels=c("100", "200", "300", "400", "500", "600", "700", "800", "900")) +
#     stat_summary(fun.y = sum, geom = "bar", fill="steelblue")
#

kk <- read.csv("kandydaci_sejm.csv", sep = ';',  header=T, na.string="NA");
total <- 918
total5 <- 41 * 5

plec <- ggplot(kk) +  
ggtitle("Sejm 2019: kandydaci wg płci") +
 ylab(label="N") +
 geom_bar(aes(x = Plec), fill="#e2891d")

plecp <- ggplot(kk, aes(x = Plec)) + 
 ggtitle("Sejm 2019: kandydaci wg płci") +
 ylab(label="%") +
 scale_y_continuous(breaks=c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), labels=c("10", "20", "30", "40", "50", "60", "70", "80", "90")) +
 ##geom_bar(aes(y = (..count..)/total5), fill="steelblue")
 geom_bar(aes(y = (..count..)/sum(..count..)), fill="steelblue")

kx <-  subset(kk, (Pozycja < 6 ))
p5 <- ggplot(kx) + 
 ylab(label="N") +
 ggtitle("Sejm 2019: kandydaci wg płci (miejsca 1--5 na liście)") +
 geom_bar(aes(x = Plec), fill="#e2891d")

p5p <- ggplot(kx, aes(x = Plec)) + 
 ggtitle("Sejm 2019: kandydaci wg płci (miejsca 1--5 na liście)") +
 ylab(label="%") +
 scale_y_continuous(breaks=c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9),  labels=c("10", "20", "30", "40", "50", "60", "70", "80", "90")) +
 geom_bar(aes(y = (..count..)/sum(..count..)), fill="steelblue")

##partia <- ggplot(kk) +  geom_bar(aes(x = Partia))

kx <-  subset(kk, (Partia == "PiS" | Partia == "PORP" | Partia == "PSL" | Partia == "SLD" | Partia == "Nowoczesna" 
  | Partia == "LewicaRazem" | Partia == "Wiosna" | Partia == "LRazem" ))

partia6 <- ggplot(kx) +  
 ggtitle("Sejm 2019: partie wg liczby kandydatów") +
 ylab(label="N") +
 geom_bar(aes(x = Partia), fill="#e2891d")

partia6p <- ggplot(kx, aes(x = Partia)) + 
 ggtitle("Sejm 2019: partie wg udziałów w komitetach", subtitle="każdy komitet=100%") +
 ylab(label="%") +
 ##annotate("text", x=3, y=70, label="% kandydatów w komitecie (918)", size=3 ) +
 scale_y_continuous(breaks=c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), labels=c("10", "20", "30", "40", "50", "60", "70", "80", "90")) +
 ##geom_bar(aes(y = (..count..)/sum(..count..)), fill="steelblue")
 geom_bar(aes(y = (..count..)/total), fill="steelblue")

kx <-  subset(kx, (Pozycja <6 ))

partia66 <- ggplot(kx) + 
 ggtitle("Sejm 2019: partie wg liczby kandydatów (miejsca 1--5)") +
 ylab(label="N") +
 geom_bar(aes(x = Partia), fill="#e2891d")

partia66p <- ggplot(kx, aes(x = Partia)) + 
 ggtitle("Sejm 2019: partie wg udziałów w komitetach (miejsca 1--5)", subtitle="każdy komitet=100%") +
 ##annotate("text", x=3, y=70, label="% kandydatów w komitecie (205)", size=3 ) +
 ylab(label="%") +
 scale_y_continuous(breaks=c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9), labels=c("10", "20", "30", "40", "50", "60", "70", "80", "90")) +
 #scale_y_continuous(breaks=c(0.05, 0.1, 0.15, 0.20, 0.25, 0.30),  labels=c("5", "10", "15", "20", "25", "30")) +
 geom_bar(aes(y = (..count..)/total5), fill="steelblue")

kx <-  subset(kk, (Komitet == "PiS" | Komitet == "KOBW" | Komitet == "PSL" | Komitet == "SLD" | Komitet == "KONFEDERACJA" | Komitet == "BZPS" ))

komitet <- ggplot(kx) +  
 ggtitle("Sejm 2019: komitety wg liczby kandydatów") +
 ylab(label="N") +
 geom_bar(aes(x = Komitet), fill="#e2891d")

## Plec ##
#plec
#plecp
#p5
#p5p

## Partia ##
#partia
#partia6
#partia66
#partia6p
#partia66p

## komitet ##
#komitet

ggarrange(plecp, p5p, partia6p, partia66p, ncol = 2, nrow = 2)
##ggarrange(plec, p5, partia6, partia66, ncol = 2, nrow = 2)

ggsave(file="sejm_kandydaci2019.pdf", width=12)

