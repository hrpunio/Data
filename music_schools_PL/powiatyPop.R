library(ggplot2)

dd <- read.csv("powiatyBySzkolyT.csv", sep = ';',  header=T, na.string="NA", colClasses=c("teryt"="character"));

##ggplot(d, aes(woj)) + geom_bar(aes(fill=woj)) + coord_flip() + ggtitle("Liczba szkół")

fivenum(dd$ppp.p);

## https://sebastiansauer.github.io/ordering-bars/
d <- subset (dd, ppp.p< 16.0 );
ggplot(data=d, aes(x=reorder(nazwa,-ppp.p), y=ppp.p)) +  geom_bar(stat="identity", fill = "blue") + coord_flip() +
 ggtitle("Non-working age population (% of total population)") +
 ylab("%") + xlab("powiat (county)")

d <- subset (dd, ppp.p> 20.0 );
ggplot(data=d, aes(x=reorder(nazwa,-ppp.p), y=ppp.p)) +  geom_bar(stat="identity", fill = "blue") + coord_flip() +
 ggtitle("Non-working age population (% of total population)") +
 ylab("%") + xlab("powiat (county)")
