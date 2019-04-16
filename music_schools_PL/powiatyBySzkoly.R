library(ggplot2)

d <- read.csv("powiatyBySzkolyT.csv", sep = ';',  header=T, na.string="NA", colClasses=c("teryt"="character"));

total <- d$L1 + d$L2;
d["total"] <- total;

woj <- substr(d$teryt, 1,2)
d["woj"] <- woj;

fivenum(d$total)
mean(d$total)


ggplot(d, aes(x=woj, y=total, fill=woj)) + geom_boxplot() + ylab("szkoły") + xlab("") + ggtitle("Średnie na województwo");

aggregate(total~woj, data=d, mean)

ggplot(d, aes(woj)) + geom_bar(aes(fill=woj)) + coord_flip() + ggtitle("Liczba szkół")

ggplot(d, aes(x = total)) + geom_histogram(binwidth = 1) + ggtitle("powiaty wg liczby szkół muzycznych")


powiatyA <- nrow(d)

## Tylko powiaty ze szkołami #### #### ###
do <- d;
d <- subset (d, total > 0);

##pppDens <- ifelse(d$total != 0, d$ppp/d$total, 0) 
pppDens <- d$ppp/d$total 

d["pppd"] <- pppDens

fivenum(d$pppd);

ggplot(d, aes(x=woj, y=pppd, fill=woj)) + geom_boxplot() + ylab("u/s") + xlab("") + ggtitle("Dzieci/szkołę");

aggregate(pppd~woj, data=d, mean)

powiatyS <- nrow(d)

powiatyS

powiatyA - powiatyS

ggplot(d, aes(x = pppd)) + geom_histogram(binwidth = 1000) + ggtitle("powiaty wg liczby szkół muzycznych")

d <- subset (d, total > 0);

##pppDens <- ifelse(d$total != 0, d$ppp/d$total, 0) 
pppDens <- d$ppp/d$total 

d["pppd"] <- pppDens
aggregate(pppd~teryt, data=d, fivenum)

### Tylko miejskie #############################
d <- subset (do, typ == "m");

nrow(d)

ggplot(d, aes(x = total)) + geom_histogram(binwidth = 1) + ggtitle("powiaty wg liczby szkół muzycznych")

d <- subset (d, total > 0);
##pppDens <- ifelse(d$total != 0, d$ppp/d$total, 0) 
pppDens <- d$ppp/d$total 
d["pppd"] <- pppDens

aggregate(pppd~teryt, data=d, fivenum)

### Tylko niemiejskie ########################
d <- subset (do, typ == "p");

ggplot(d, aes(x = total)) + geom_histogram(binwidth = 1) + ggtitle("powiaty wg liczby szkół muzycznych")

d <- subset (d, total > 0);
##pppDens <- ifelse(d$total != 0, d$ppp/d$total, 0) 
pppDens <- d$ppp/d$total 
d["pppd"] <- pppDens

a <- aggregate(pppd~teryt, data=d, fivenum)

order.pppd <- order(d$pppd)

list1 <- paste(d$pppd[order.pppd], d$nazwa[order.pppd], d$total[order.pppd])

head(list1, n=10)
tail(list1, n=10)

##a[order(a$pppd),]
