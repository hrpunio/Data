require(ggplot2)
# http://www.cookbook-r.com/Graphs/Plotting_distributions_%28ggplot2%29/

d <- read.csv("W7RR_podroze_by_podroz1.csv", sep = ';', dec = ",",  header=T, na.string="NA");
d[,"KlacznieT"] <- d$Klacznie / 1000 ;
d[,"KtranspT"] <- d$Ktransp / 1000 ;
d[,"DistT"] <- d$Dist / 1000 ;


##d;

ggplot(d, aes(x=Klub, y=KlacznieT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys PLN]") + xlab("Klub") + guides(fill=FALSE);

ggplot(d, aes(x=Klub, y=KtranspT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys PLN]") + xlab("Klub") + guides(fill=FALSE);

ggplot(d, aes(x=Klub, y=DistT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys km]") + xlab("Klub") + guides(fill=FALSE);

## Tylko jezeli koszty transportu były większe od 0
d<-d[d$Ktransp > 0, ] ;

summary(d);
nrow(d);

ggplot(d, aes(x=Klub, y=KlacznieT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys PLN]") + xlab("Klub") + guides(fill=FALSE);

ggplot(d, aes(x=Klub, y=KtranspT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys PLN]") + xlab("Klub") + guides(fill=FALSE);

ggplot(d, aes(x=Klub, y=DistT, fill=Klub)) + geom_boxplot() + ylab("Łącznie [tys km]") + xlab("Klub") + guides(fill=FALSE);


