require(ggplot2)
require(plyr)
# http://www.cookbook-r.com/Graphs/Plotting_distributions_%28ggplot2%29/
# http://stackoverflow.com/questions/12371947/aggregate-ddply-by-factor-or-character

d <- read.csv("W7RR_podroze_by_podroz1.csv", sep = ';', dec = ",",  header=T, na.string="NA");
d[,"KlacznieT"] <- d$Klacznie / 1000 ;
d[,"KtranspT"] <- d$Ktransp / 1000 ;
d[,"DistT"] <- d$Dist / 1000 ;

d<-d[d$Ktransp > 0, ] ;

##d;
##posly <- unique(d$Posel);
##
##posly;

# http://r.789695.n4.nabble.com/concatenating-2-text-columns-in-a-data-frame-td881819.html
d[,"PosKlub"] <- do.call(paste, c(d[c("Posel", "Klub")], sep = "|"));

##d
##
##keeps <- c("Posel","KlacznieT", "Ktransp", "Dist");
keeps <- c("PosKlub", "KlacznieT", "KtranspT", "DistT");

d <- d[keeps];

PSums <- as.data.frame ( ddply(d, .(PosKlub), numcolwise(sum)) );

# http://stackoverflow.com/questions/7069076/split-column-at-delimiter-in-data-frame
#PSums <- data.frame(do.call('rbind', strsplit(as.character(PSums$PosKlub),'|', fixed=TRUE)))
PSums <- as.data.frame ( within(PSums, PosKlub<-data.frame( do.call('rbind', strsplit(as.character(PosKlub), '|', fixed=TRUE))))  )


PSums;

summary(PSums);

## 
str(PSums);

##

ggplot(PSums, aes(x=PosKlub$X2, y=KlacznieT, fill=PosKlub$X2)) + geom_boxplot() + ylab("Łącznie [tys PLN]") + xlab("Klub") + guides(fill=FALSE) ;

ggplot(PSums, aes(x=PosKlub$X2, y=KtranspT, fill=PosKlub$X2)) + geom_boxplot() + ylab("Transport [tys PLN]") + xlab("Klub") + guides(fill=FALSE) ;

ggplot(PSums, aes(x=PosKlub$X2, y=DistT, fill=PosKlub$X2)) + geom_boxplot() + ylab("Dystans [tys km]") + xlab("Klub") + guides(fill=FALSE) ;
