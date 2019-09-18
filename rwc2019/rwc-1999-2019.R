library(ggplot2)
library(dplyr)

options(dplyr.print_max = 1e9)

weight.scale <- c(10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80,
        85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145 )
age.scale <- c(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 )
caps.scale <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120 )


players <- read.csv("RWC_1999-2019.csv", sep = ';',  header=T, na.string="NA");

players.pack.year <- players %>% group_by(pack, year) %>% 
   summarise_at(vars("weight", "age"), mean)

str(players)

ggplot(players, aes(x=as.factor(year), y=weight, fill=as.factor(year))) + geom_boxplot() + ylab("kg") +
 scale_y_continuous(breaks=weight.scale) +
 ggtitle("RWC 1999--2019: players weight") +
 xlab("");


