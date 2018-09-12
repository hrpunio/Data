## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
library(reshape)
require(ggplot2)
# http://stackoverflow.com/questions/11335836/increase-number-of-axis-ticks-in-ggplot2
number_ticks <- function(n) {function(limits) pretty(limits, n)}

d <- read.csv("fueldata.csv", sep = ';',  header=T, na.string="NA");
#d
#
#ggplot(d, aes(x = dlic)) +
#  geom_point(aes(y = fuel), size=2) +
#  ylab(label="paliwo/mieszkańca (galony)") +
#  ##scale_y_continuous(breaks=number_ticks(15)) +
#  ##scale_x_continuous(breaks=number_ticks(10)) +
#  ##theme(legend.title=element_blank()) +
#  ##labs(colour = "") +
#  theme(legend.position="top") +
#  geom_smooth(method=lm);
# theme(legend.text=element_text(size=12));
#

ggplot(d, aes(d$dlic,d$fuel)) + geom_point() +
  ##geom_text(aes(label=d$iso),size=2.0, vjust=-0.35)  +
  xlab("% z prawem jazdy dlic") + ylab("paliwo/mieszkańca (fuel)") +
  scale_colour_discrete(name="") +
  ##geom_smooth(method="lm", se=F, size=2);
  geom_smooth(method="lm", se=F, size=2);

lm <- lm(data=d, fuel ~ dlic ); summary(lm)


