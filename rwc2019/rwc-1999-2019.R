### RWC 1999-2019 players elementary statistical analysis
### tprzechlewski@gmail.com (CC by license)
### 
library(ggplot2)
library(dplyr)
options(dplyr.print_max = 1e9)

###############################
players <- read.csv("RWC_1999-2019.csv", sep = ';',  header=T, na.string="NA", colClasses=c( year ="factor"))
players$date <- as.Date(players$year, format = "%Y")
str(players)
###############################

aggregateByYr <- function(p, c) {
  ## https://stackoverflow.com/questions/49700912/why-is-enquo-preferable-to-substitute-eval
  colname <- enquo(c)
  group_by (p, year) %>%
  summarise(
    median = median(!! colname, na.rm=TRUE),
    mean = mean(!! colname, na.rm=TRUE),
    min = min(!! colname, na.rm=TRUE),
    max = max(!! colname, na.rm=TRUE)
  ) %>%
  as.data.frame %>%
  arrange(desc(median))
}
default.lab <- "Weight [kg]"
plotAgg <- function(p, co, coco, lab=default.lab ) {

  t <- sprintf("RWC 1999--2019: %s", co)

  ##if(missing(lab)) { lab <- "Weight [kg]" } 
   
  plot <- ggplot(p, aes(x = as.Date(year, format = "%Y"))) +
    ggtitle(t) + 
    geom_line(aes(y = mean, colour = 'mean'), size=2) +
    geom_line(aes(y = max, colour = "max"), size=.5) +
    geom_line(aes(y = min, colour = "min"), size=.5) +
    ##
    geom_point(aes(y = mean, colour = 'mean'), size=3) +
    geom_point(aes(y = max, colour = 'max'), size=1) +
    geom_point(aes(y = min, colour = 'min'), size=1) +
    ## labels
    geom_text(data=p, aes(label=sprintf("%.1f", mean), y= mean), vjust=-1.25 ) +
    geom_text(data=p, aes(label=sprintf("%.1f", max), y= max), vjust=-1.25, size=3 ) +
    geom_text(data=p, aes(label=sprintf("%.1f", min), y= min), vjust=-1.25, size=3 ) +
    ylab(label=lab) +
    xlab(label="Year") +
    scale_x_date(breaks = seq(as.Date("1999", format="%Y"), as.Date("2019", format="%Y"), by="4 years"), date_labels = "%Y" ) +
    labs(colour = "Year: ", caption = "Source: https://github.com/hrpunio/Data/tree/master/rwc2019") +
    theme(legend.position="top") +
    theme(legend.text=element_text(size=12));

    if  (missing(coco)) {    plot <- plot + ggtitle(t) }
    else { plot <- plot + ggtitle(t, subtitle=coco ) +
         theme(plot.subtitle=element_text(size=8)) }

    return (plot)

}

plotBoxWd <- function (p, co ){
  t <- sprintf("RWC 1999--2019: %s", co)
  s <- weight.scale 
  lab <- "Weight [kg]" 

  ggplot(p, aes(x=year, y=weight, fill=year)) + geom_boxplot() +
   scale_y_continuous(breaks=s) +
   ggtitle(t) +
   guides(fill=guide_legend("Year")) +
   ylab(label=lab) +
   labs(colour = "Year: ", caption = "Source: https://github.com/hrpunio/Data/tree/master/rwc2019") +
   xlab("");
}
plotBoxHt <- function (p, co ){
  t <- sprintf("RWC 1999--2019: %s", co)
  s <- height.scale 
  lab <- "Height [cm]" 

  ggplot(p, aes(x=year, y=height, fill=year)) + geom_boxplot() +
   scale_y_continuous(breaks=s) +
   ggtitle(t) +
   guides(fill=guide_legend("Year")) +
   ylab(label=lab) +
   labs(colour = "Year: ", caption = "Source: https://github.com/hrpunio/Data/tree/master/rwc2019") +
   xlab("");
}
###############################

weight.scale <- c(10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80,
    85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135, 140, 145 )
age.scale <- c(18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40 )
height.scale <- c(164, 166, 168, 170, 172, 174, 176, 178, 180, 182, 184, 186, 188, 
    190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212 )
caps.scale <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120 )

##All players weight and height

players.weight.year <- aggregateByYr (players, weight)
players.weight.year

players.height.year <- aggregateByYr (players, height)
players.height.year

### by pack x year
players.weight.pack.year <- players %>% group_by(pack, year) %>% 
  summarise(
   median = median(weight, na.rm=TRUE),
    mean = mean(weight, na.rm=TRUE),
    min = min(weight, na.rm=TRUE),
    max = max(weight, na.rm=TRUE)
  ) %>%
  as.data.frame

players.weight.pack.year

### Boxplot (weight / all players)
plotBoxWd(players, "players weight")
plot.players.weight.year <- plotAgg(players.weight.year, "players weight (all players)")

## Boxplot (height / all players)
plotBoxHt(players, "players height")
plot.players.height.year <-  plotAgg(players.height.year, "players height (all players)", lab="height [cm]")

plot.players.weight.year
plot.players.height.year
###############################
### 1999/2015/2019 players only
###############################
players  <- filter (players, year == 1999 | year == 2015 | year == 2019);
##str(players)
###############################
###
### Forwards ##################
fplayers <- filter(players, grepl("PR|SR|HK", players$poscode))
fplayers.weight.year <- aggregateByYr (fplayers, weight)
players.weight.year

f1players <- filter(players, grepl("PR|HK", players$poscode))
f1players.weight.year <- aggregateByYr (f1players, weight)
f1players.weight.year

f2players <- filter(players, grepl("SR", players$poscode))
f2players.weight.year <- aggregateByYr (f2players, weight)
f2players.weight.year

fpplayers <- filter(players, grepl("PR", players$poscode))
fpplayers.weight.year <- aggregateByYr (fpplayers, weight)
fpplayers.weight.year

plot.fplayers.weight.year <- plotAgg(fplayers.weight.year, "players weight (forwards)")
plot.f1players.weight.year <- plotAgg(f1players.weight.year, "players weight (1st row)")
plot.f2players.weight.year <- plotAgg(f2players.weight.year, "players weight (back rows)")
plot.fpplayers.weight.year <- plotAgg(fpplayers.weight.year, "players weight (props)")

plot.fplayers.weight.year
plot.f1players.weight.year 
plot.f2players.weight.year
plot.fpplayers.weight.year

### Backs #####################
bplayers <- filter(players, grepl ("BR|CE|FB|FH|WI|SH", players$poscode )  )
bplayers.weight.year <- aggregateByYr (bplayers, weight)
bplayers.weight.year
plotAgg(bplayers.weight.year, "players weight (backs)")

### Wings #####################
wplayers <- filter(players, grepl ("WI", players$poscode )  )
wplayers.weight.year <- aggregateByYr (wplayers, weight)
wplayers.weight.year
plotAgg(wplayers.weight.year, "players weight (wings)")

### Top-team players ie semi-finalist 1999-2015)
top.teams.note <- "Top-teams: NZL/AUS/ENG/FRA/ARG/WAL/RSA"

top.players <- filter(players, grepl ("NZL|AUS|ENG|FRA|ARG|WAL|RSA", players$pack )  )
##str(top.players)

### Forwards ##################
ftop.players <-  filter(top.players, grepl("PR|SR|HK", top.players$poscode))
### Backs #####################
btop.players <-  filter(top.players, grepl ("BR|CE|FB|FH|WI|SH", top.players$poscode )  )
### Wings #####################
wtop.players <-  filter(top.players, grepl ("W", top.players$poscode )  )

top.players.weight.year <- aggregateByYr (top.players, weight)

top.players.weight.year

plot.top.players.weight.year <- plotAgg(top.players.weight.year, "players weight (top teams)", top.teams.note)

ftop.players.weight.year <- aggregateByYr (ftop.players, weight)
plot.ftop.players.weight.year <- plotAgg(ftop.players.weight.year, "forwards weight (top teams)", top.teams.note )

btop.players.weight.year <- aggregateByYr (btop.players, weight)
plot.btop.players.weight.year <- plotAgg(btop.players.weight.year, "backs weight (top teams)", top.teams.note )

wtop.players.weight.year <- aggregateByYr (wtop.players, weight)
plot.wtop.players.weight.year <- plotAgg(wtop.players.weight.year, "wings weight (top teams)", top.teams.note )

plot.top.players.weight.year
plot.ftop.players.weight.year
plot.btop.players.weight.year
plot.wtop.players.weight.year

###############################
## BoxPlots ###################
## Position  ## ### ### #######

plotBoxWd(fplayers, "Forwards weight")
plotBoxHt(fplayers, "Forwards height")
plotBoxWd(bplayers, "Backs weight")

plotBoxWd(f1players, "Forwards weight (1st row)")

plotBoxWd(f2players, "Forwards weight (back rows)")
plotBoxWd(f2players, "Forwards weight (back rows)")

plotBoxHt(f2players, "Forwards height (back rows)")
plotBoxWd(wplayers, "Wings weight")

## Top-teams ## ### ### #######
plotBoxWd(top.players, "players weight (top teams)")
plotBoxWd(ftop.players, "forwards weight (top teams)")
plotBoxWd(btop.players, "backs weight (top teams)")
plotBoxWd(wtop.players, "wings weight (top teams)")

#### #### ####

