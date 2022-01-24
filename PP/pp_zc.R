#! --- R ---
library("tidyverse")
library("ggplot2")
library(lubridate)
#

dd <- read.csv("pp.csv", sep = ';',  header=T, na.string="NA") %>%
  select(data, zabici) %>%
  arrange(data) %>%
  mutate(rok = substr(data, 1, 4),
         dzienrok = yday(as.Date(data))
         ) %>%
  ## rok 2008 jest niepełny
  filter (rok > 2008) 

d.cum <- dd %>%
  filter (rok > 2016) %>%
  group_by(rok) %>%
  mutate( zc =cumsum(zabici), lzc = last(zc) ) %>%
  ungroup() %>%
  mutate (lday=last(dzienrok)) %>%
  filter (dzienrok <= lday)

max.y <- max(d.cum$zc, na.rm = T)
last.y.day <- d.cum$lday

wd.y <- floor(max.y /10)

p2c <- ggplot(d.cum, aes(x= dzienrok, y=zc, color=as.factor(rok))) + 
  geom_point(size=.8) +
  #geom_smooth(method="loess", size=1, se=F, span=.5) +
  geom_line(size=.8, alpha=.4) +
  xlab(label="dzień roku") +
  ylab(label='liczba zabitych') +
  scale_y_continuous(breaks=seq(0, wd.y * 10 + wd.y, by=wd.y)) +
  scale_color_hue(name="rok") +
  ggtitle(sprintf("Wypadki/zabici (skumulowana suma | ostatni dzień roku: %i)", last.y.day), 
          subtitle="policja.pl/pol/form/1,Informacja-dzienna.html") 

ggsave(plot=p2c, "PPW_Zabici_Cum.png", width=12)
##p2c
##
##
