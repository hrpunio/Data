## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
library(reshape)
require(ggplot2)
library(scales)
library(zoo)

# http://stackoverflow.com/questions/7381455/filtering-a-data-frame-by-values-in-a-column
d <- read.csv("ToF.csv", sep = ';',  header=T, na.string="NA");

fivenum(d$speed);

d$rok <- paste(d$rok, "-04-01", sep="");
d$rok

ggplot(d, aes(x = as.Date(rok))) +
  geom_line(aes(y = speed, colour = 'average speed (winner)', group = 1), size=2) +
  ylab(label="Average speed") +
  xlab(label="Year (1900/2000+)") +
  scale_x_date(breaks = date_breaks("4 years"), labels = date_format("%y")) +
  annotate("text", x = as.Date("1990-04-01"), y = 25, 
    label = "Summary (1913--2015):min = 25.17 kmph; median = 38.55 kmph; max = 43.58 kmph\n") +
  labs(color = "rondevanVlaanderen (http://www.bikeraceinfo.com/classics/): ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
  ##geom_smooth(aes(x=time, y=speed), method=lm,se=T, size=2);

ggsave(file="rondevanVlaanderen.pdf", width=15, height=8)

d2 <- read.csv("paris-roubaix.csv", sep = ';',  header=T, na.string="NA");
d2$rok <- paste(d2$rok, "-04-01", sep="");


d3 <- merge(d,d2, by.x='rok', by.y='rok')

fivenum(d3$speed.y);

ggplot(d3, aes(x = as.Date(rok))) +
  geom_line(aes(y = speed.x, colour = 'winner (ronde vlaanderen)', group = 1), size=2) +
  geom_line(aes(y = speed.y, colour = 'winner (paris-roubaix)', group = 2), size=2) +
  ylab(label="Average speed") +
  xlab(label="Year (1900/2000+)") +
  scale_x_date(breaks = date_breaks("4 years"), labels = date_format("%y")) +
  annotate("text", x = as.Date("1990-04-01"), y = 25, 
    label = "Summary (1913--2015):\nR-V min = 25.17 kmph; median = 38.55 kmph; max = 43.58 kmph\nP-R min = 22.86 kmph; median = 39.12 kmph; max = 45.13 kmph") +
  labs(color = "Ronde Vlaanderen/Paris-Roubaix (http://www.bikeraceinfo.com/classics/): ") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

ggsave(file="ronde_roubaix.pdf", width=15, height=8)
