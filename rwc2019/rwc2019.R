## RWC 2019 players simple statistical analysis
## tprzechlewski@gmail.com
## CC by license
require(ggplot2)
require(dplyr)
## 

players <- read.csv("RWC_2019.csv", sep = ';', dec = ",",  header=T, na.string="--");

######################################################
## Forwards/Backs

f <- "forward"
b <- "back"

players <- mutate(players, bpos = recode(pos, PR = f, SR = f, HK = f, BR = b, CE = b, FB = b, FH = b, WI = b, SH = b ))

######################################################
# RWC semi-finalists    q-finalists
# =================== + ===============
# 1999 AUS FRA RSA NZL  WAL ENG SCO ARG
# 2003 ENG AUS NZL FRA  RSA SCO IRL WAL
# 2007 RSA ENG ARG FRA  AUS NZL FIJ SCO
# 2011 NZL FRA AUS WAL  IRL ENG RSA ARG
# 2015 NZL AUS RSA ARG  WAL FRA IRL SCO

t <- "top"
r <- "rest"
players <- mutate(players, sft = recode(team, 
ARG=t, AUS=t, CAN=r, ENG=t, FIJ=r, FRA=t, GEO=r, IRE=r, ITA=r, JPN=r, NAM=r, NZL=t, RSA=t, RUS=r, SCO=r, TON=r, URY=r, USA=r, WAL=t, WSA=r))

######################################################

teams.weight <- group_by (players, team) %>%
  summarise( 
   median = median(weight, na.rm=TRUE), 
    mean = mean(weight, na.rm=TRUE), 
    min = min(weight, na.rm=TRUE), 
    max = max(weight, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

sft.weight <- group_by (players, sft) %>%
  summarise(
   median = median(weight, na.rm=TRUE), 
    mean = mean(weight, na.rm=TRUE), 
    min = min(weight, na.rm=TRUE), 
    max = max(weight, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

##str(sft.weight)
##
##sft.weight.top <- sft.weight %>% filter (sft == "top") %>% select(median) 
##sft.weight.rest <- sft.weight %>% filter (sft == "top") %>% select(median) 
sft.weight.top <- sft.weight %>% filter (sft == "top")  
sft.weight.rest <- sft.weight %>% filter (sft == "rest") 

sft.weight.top.mean <- sft.weight.top %>% select(mean) 
sft.weight.top.median <- sft.weight.top %>% select(median) 
sft.weight.rest.mean <- sft.weight.rest %>% select(mean) 
sft.weight.rest.median <- sft.weight.rest %>% select(median) 

##sft.weight.top.mean
##sft.weight.top.median

pos.weight <- group_by (players, bpos) %>%
  summarise(
   median = median(weight, na.rm=TRUE), 
    mean = mean(weight, na.rm=TRUE), 
    min = min(weight, na.rm=TRUE), 
    max = max(weight, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

pos.weight.fd <- pos.weight %>% filter (bpos == "forward")  
pos.weight.bk <- pos.weight %>% filter (bpos == "back") 

pos.weight.fd.mean <- pos.weight.fd %>% select(mean)
pos.weight.fd.median <- pos.weight.fd %>% select(median)
pos.weight.bk.mean <- pos.weight.bk %>% select(mean)
pos.weight.bk.median <- pos.weight.bk %>% select(median)

##pos.weight.fd.mean
##pos.weight.bk.mean

teams.weight
sft.weight
pos.weight

############################################
### Charts

weight.scale <- c(10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80,
        85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145 )
age.scale <- c(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 )
caps.scale <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120 )


## Histograms #########################
## All players ########################
mean.weight <- mean (players$weight)
median.weight <- median (players$weight)
min.weight <- min (players$weight)
max.weight <- max (players$weight)

ggplot(players, aes(x=weight)) +
  ggtitle("RWC 2019: player's weight",
   subtitle=sprintf("mean/median/min/max = %.1f / %.1f / %.1f / %.1f",   mean.weight, median.weight, min.weight, max.weight)) +
  xlab("weight [kg]") +
  geom_histogram(binwidth=2.5, alpha=.5, fill="steelblue")

## Forwards vs Backs ##################
ggplot(players, aes(x=weight, fill=bpos)) +
  ggtitle("RWC 2019: player's weight",
   subtitle=sprintf("Forwards: mean/median = %.1f / %.1f Backs m/m = %.1f / %.1f", pos.weight.fd.mean, pos.weight.fd.median,
              pos.weight.bk.mean, pos.weight.bk.median )) +
  xlab("weight [kg]") +
  guides(fill=guide_legend("Position")) +
  geom_histogram(binwidth=2.5, alpha=.5, position="identity")

#ggplot(players, aes(x=caps, fill=bpos)) +
#  ggtitle("RWC 2019: player's caps") +
#  geom_histogram(binwidth=5, alpha=.5, position="identity")
#
#ggplot(players, aes(x=height, fill=bpos)) +
#  ggtitle("RWC 2019: player's height") +
#  geom_histogram(binwidth=2.0, alpha=.5, position="identity")
#
## All players comparison (team) ###########################

ggplot(players, aes(x=team, y=weight, fill=team)) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 2019: players weight") +
 xlab("");

#ggplot(players, aes(x=team, y=age, fill=team)) + geom_boxplot() + ylab("years") +
# scale_y_continuous(breaks=c(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 )) +
# ggtitle("RWC 2019: Players age") +
# xlab("");
#
#ggplot(players, aes(x=team, y=caps, fill=team)) + geom_boxplot() + ylab("#") + 
# scale_y_continuous(breaks=caps.scale) +
# ggtitle("RWC 2019: caps") +
#  xlab("");
#
## Forwards comparison (team)
## PR = Prop SR = Lock HK = Hooker 

fplayers <-  filter(players, grepl("PR|SR|HK", players$pos))

#
#ggplot(fplayers, aes(x=team, y=age, fill=team)) + geom_boxplot() + ylab("years") +
# scale_y_continuous(breaks=age.scale) +
# ggtitle("RWC 2019: age of forwards") +
# xlab("");

ggplot(fplayers, aes(x=team, y=weight, fill=team)) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 2019: forwards weight") +
 xlab("");

#ggplot(fplayers, aes(x=team, y=caps, fill=team)) + geom_boxplot() + ylab("#") + 
# scale_y_continuous(breaks=caps.scale) +
# ggtitle("RWC 2019: caps of forwards") +
# xlab("");

## Backs comparions (team)  #####################
## BR = Back Row | CE = Centre | FB = Full Back | FH = Fly Half | WI = Wing | SH = Scrum Half

bplayers <- filter(players, grepl ("BR|CE|FB|FH|WI|SH", players$pos )  )

#ggplot(bplayers, aes(x=team, y=age, fill=team)) + geom_boxplot() + ylab("years") +
# scale_y_continuous(breaks=age.scale) +
# ggtitle("RWC 2019: age (Backs)") +
# xlab("");

ggplot(bplayers, aes(x=team, y=weight, fill=team)) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 2019: Backs weight") +
 xlab("");

#ggplot(bplayers, aes(x=team, y=caps, fill=team)) + geom_boxplot() + ylab("#") + 
# scale_y_continuous(breaks=caps.scale) +
# ggtitle("RWC 2019: Backs caps") +
# xlab("");
#

sft.age <- group_by (players, sft) %>%
  summarise(
   median = median(age, na.rm=TRUE), 
    mean = mean(age, na.rm=TRUE), 
    min = min(age, na.rm=TRUE), 
    max = max(age, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

sft.age.top <- sft.age %>% filter (sft == "top")  
sft.age.rest <- sft.age %>% filter (sft == "rest") 

sft.age.top.mean <- sft.age.top %>% select(mean) 
sft.age.top.median <- sft.age.top %>% select(median) 
sft.age.rest.mean <- sft.age.rest %>% select(mean) 
sft.age.rest.median <- sft.age.rest %>% select(median) 

# Top vs rest teams
ggplot(players, aes(x=sft, y=age, fill=sft)) + geom_boxplot() + ylab("years") +
 scale_y_continuous(breaks=age.scale) +
 ggtitle("RWC 2019: Players age",
   subtitle=sprintf("Top teams: mean/median = %.1f / %.1f Rest m/m = %.1f / %.1f", 
     sft.age.top.mean, sft.age.top.median, sft.age.rest.mean, sft.age.rest.median)) +
  guides(fill=guide_legend("Position")) +
  xlab("");

ggplot(players, aes(x=sft, y=weight, fill=sft)) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 2019: Players weight",
   subtitle=sprintf("Top teams: mean/median = %.1f / %.1f Rest m/m = %.1f / %.1f", 
     sft.weight.top.mean, sft.weight.top.median, sft.weight.rest.mean, sft.weight.rest.median)) +
  guides(fill=guide_legend("Position")) +
 xlab("");

sft.caps <- group_by (players, sft) %>%
  summarise(
   median = median(caps, na.rm=TRUE), 
    mean = mean(caps, na.rm=TRUE), 
    min = min(caps, na.rm=TRUE), 
    max = max(caps, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

sft.caps.top <- sft.caps %>% filter (sft == "top")  
sft.caps.rest <- sft.caps %>% filter (sft == "rest") 

sft.caps.top.mean <- sft.caps.top %>% select(mean) 
sft.caps.top.median <- sft.caps.top %>% select(median) 
sft.caps.rest.mean <- sft.caps.rest %>% select(mean) 
sft.caps.rest.median <- sft.caps.rest %>% select(median) 

ggplot(players, aes(x=sft, y=caps, fill=sft)) + geom_boxplot() + ylab("#") + 
 scale_y_continuous(breaks=caps.scale) +
 ggtitle("RWC 2019: Players caps",
   subtitle=sprintf("Top teams: mean/median = %.1f / %.1f Rest m/m = %.1f / %.1f", 
     sft.caps.top.mean, sft.caps.top.median, sft.caps.rest.mean, sft.caps.rest.median)) +
  guides(fill=guide_legend("Position")) +
 xlab("");

## Forwards 
## PR = Prop | SR = 2nd Row | HK = Hooker
fplayers <- filter(players, grepl("PR|SR|HK", players$pos))

#ggplot(fplayers, aes(x=sft, y=age, fill=sft)) + geom_boxplot() + ylab("years") +
# scale_y_continuous(breaks=age.scale) +
# ggtitle("RWC 2019: Forwards age") +
#  xlab("");

sft.weight.fp <- group_by (fplayers, sft) %>%
  summarise(
   median = median(weight, na.rm=TRUE), 
    mean = mean(weight, na.rm=TRUE), 
    min = min(weight, na.rm=TRUE), 
    max = max(weight, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))

sft.weight.fp.top <- sft.weight.fp %>% filter (sft == "top")  
sft.weight.fp.rest <- sft.weight.fp %>% filter (sft == "rest") 

sft.weight.fp.top.mean <- sft.weight.fp.top %>% select(mean) 
sft.weight.fp.top.median <- sft.weight.fp.top %>% select(median) 
sft.weight.fp.rest.mean <- sft.weight.fp.rest %>% select(mean) 
sft.weight.fp.rest.median <- sft.weight.fp.rest %>% select(median) 


ggplot(fplayers, aes(x=sft, y=weight, fill=sft)) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 2019: Forwards weight",
   subtitle=sprintf("Top teams: mean/median = %.1f / %.1f Rest m/m = %.1f / %.1f", 
     sft.weight.fp.top.mean, sft.weight.fp.top.median, sft.weight.fp.rest.mean, sft.weight.fp.rest.median)) +
  guides(fill=guide_legend("Position")) +
 xlab("");

#ggplot(fplayers, aes(x=sft, y=caps, fill=sft)) + geom_boxplot() + ylab("#") + 
# scale_y_continuous(breaks=caps.scale) +
# ggtitle("RWC 2019: Forwards caps") +
# xlab("");
##

