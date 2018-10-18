require(ggplot2)
library(dplyr)


## https://stats.oecd.org/Index.aspx?DataSetCode=UN_DEN
g <- read.csv("gminy_kandydaci_2018_vs_2014_CC.csv", sep = ';',  header=T, 
   as.is=T, na.string="NA");

## tu.density = ratio of  wage and salary earners
## that are trade union members, divided by the total number of wage and salary earners:
## gdppc = GDP per capita
ggplot(g, aes(g$ognw, g$razem)) + geom_point() +
  ##geom_text(aes(label=g$razem),size=2.0, vjust=-0.35)  + 
  xlab("ognw (%)") + ylab("#") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)

ggplot(g, aes(g$ognw, g$popThs)) + geom_point() +
  xlab("ognw (%)") + ylab("#") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)

ggplot(g, aes(g$ognw, g$PSLp)) + geom_point() +
  xlab("ognw (%)") + ylab("PSLp") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)

ggplot(g, aes(g$ognw, g$PiSp)) + geom_point() +
  xlab("ognw (%)") + ylab("PiSp") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)
ggplot(g, aes(g$ognw, g$POp)) + geom_point() +
  xlab("ognw (%)") + ylab("POp") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)
##
ggplot(g, aes(g$ognw, g$SLDp)) + geom_point() +
  xlab("ognw (%)") + ylab("SLDp") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)
lm <- lm(data=g, ognw ~ PSLp ); summary(lm)
lm <- lm(data=g, ognw ~ PiSp ); summary(lm)
lm <- lm(data=g, ognw ~ POp ); summary(lm)
lm <- lm(data=g, ognw ~ SLDp ); summary(lm)

str(g)


boxplot (razem ~ type, g, xlab = "typ", ylab = "#kandydatów", col = "yellow")
boxplot (ognw ~ type, g, xlab = "typ", ylab = "%n-glosów", col = "yellow")

aggregate (g$razem, list(Numer = g$type), fivenum)

razem.type <- g %>% group_by(type) %>% summarise(V2=mean(razem))
print(razem.type, n=Inf)

ognw.type <- g %>% group_by(type) %>% summarise(V2=mean(ognw))
print(ognw.type, n=Inf)

g$kobietyP <- g$razemKobiety / g$razem

kobietyP.type <- g %>% group_by(type) %>% summarise(V2=mean(kobietyP))
print(kobietyP.type, n=Inf)

fivenum(g$popThs)

h <- hist(g$popThs, 
   breaks=seq(0, 1000000, by=5000),
   freq=TRUE,
   col="orange", main="", xlab="wiek", ylab="liczba kandydatów", labels=F, xaxt='n')
   #axis(side=1, at=wB)
   #text(80, 40, summary_label, cex = .8, adj=c(0,1))





