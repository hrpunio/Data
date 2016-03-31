## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
library(reshape)
require(ggplot2)
library(scales)
library(zoo)

# http://stackoverflow.com/questions/7381455/filtering-a-data-frame-by-values-in-a-column
d <- read.csv("paris-roubaix.csv", sep = ';',  header=T, na.string="NA");

fivenum(d$speed);

d$rok <- paste(d$rok, "-04-01", sep="");
d$rok

ggplot(d, aes(x = as.Date(rok))) +
#ggplot(d, aes(x = as.Date(rok, format="%Y-04-01"))) +
##ggplot(d, aes(x = rok)) +
  geom_line(aes(y = speed, colour = 'average speed (winner)', group = 1), size=2) +
  ylab(label="Average speed") +
  xlab(label="Year (1800/1900/2000+)") +
  scale_x_date(breaks = date_breaks("4 years"), labels = date_format("%y")) +
  annotate("text", x = as.Date("1990-04-01"), y = 25, 
    label = "Summary (1896--2015):\nmin = 22.857 kmph; median = 37.363 kmph;  max = 45.129 kmph") +
  labs(color = "Paris-Roubaix (http://www.bikeraceinfo.com/classics/paris-roubaix/paris-roubaix-index.html): ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

ggsave(file="paris-roubaix.pdf", width=15, height=8)
