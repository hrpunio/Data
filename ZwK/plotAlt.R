## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
library(reshape)
require(ggplot2)
# library(scales)
# library(tidyr)
# http://stackoverflow.com/questions/11335836/increase-number-of-axis-ticks-in-ggplot2

graphWd <- 15
graphHt <- 5

args = commandArgs(trailingOnly = TRUE);

if (length(args)==0) { stop("Podaj nazwę pliku CSV", call.=FALSE) }

fileBase <- gsub(".csv", "", args[1]);
outFile1 <- paste (fileBase, "_1.pdf", sep = "");
outFile2 <- paste (fileBase, "_2.pdf", sep = "");

what <- args[2];

# http://stackoverflow.com/questions/7381455/filtering-a-data-frame-by-values-in-a-column
d <- read.csv(args[1], sep = ';',  header=T, na.string="NA");
coeff <- median(d$ele)/median(d$speed)
d$speed <- d$speed * coeff


#p1 <- ggplot(d, aes(x = as.POSIXct(daytime, format="%Y-%m-%dT%H:%M:%SZ"))) +
#  geom_line(aes(y = ele, colour = 'wysokość', group = 1), size=1.5) +
#  geom_line(aes(y = speed, colour = 'prędkość', group = 1), size=.5) +
#  ##geom_line(aes(y = srtms, colour = "srtm (wygładzona)", group = 1), size=.5) +
#  stat_smooth(aes(y=speed, x=as.POSIXct(daytime, format="%Y-%m-%dT%H:%M:%SZ"), colour ='prędkość wygładzona')) +
#  ylab(label="Wysokość [mnpm]") +
#  xlab(label="czas") +
#  ##scale_x_date(breaks = date_breaks("3 months"), labels = date_format("%y%m")) +
#  scale_y_continuous( sec.axis = sec_axis(name="Prędkość [kmh]",  ~./ coeff)) +
#  labs(colour = paste( what )) +
#  theme(legend.position="top") +
#  theme(legend.text=element_text(size=12));
#p1
#ggsave(file=outFile1, width=graphWd, height=graphHt )

p2 <- ggplot(d, aes(x = dist)) +
  geom_line(aes(y = ele, colour = 'wysokość', group = 1), size=1.5) +
  ##geom_line(aes(y = speed, colour = 'prędkość', group = 1), size=.5) +
  ##geom_smooth() +
  ##stat_smooth(aes(y=ele, x=dist, colour ='wysokość wygładzona')) +
  ylab(label="Wysokość [mnpm]") +
  xlab(label="dystans") +
  ##scale_y_continuous( sec.axis = sec_axis(name="Prędkość [kmh]",  ~./ coeff)) +
  labs(colour = paste( what )) +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));
p2

ps <- stat_smooth(aes(y=speed, x=dist));

ggsave(file=outFile2, width=graphWd, height=graphHt )
##
