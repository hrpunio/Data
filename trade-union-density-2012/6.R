require(ggplot2)

## https://stats.oecd.org/Index.aspx?DataSetCode=UN_DEN
## http://stats.oecd.org/Index.aspx?DatasetCode=STLABOUR
## employment rate Q42012
d <- read.csv("union_density_and_gdp.csv", sep = ';',  header=T, na.string="NA");

## tu.density = ratio of  wage and salary earners
## that are trade union members, divided by the total number of wage and salary earners:
## gdppc = GDP per capita
rys1 <- ggplot(d, aes(d$tu.density, d$gdppc)) + geom_point() +
  geom_text(aes(label=d$iso),size=2.0, vjust=-0.35)  +
  xlab("TU density (%)") + ylab("GDPpc (tys USD)") +
  scale_colour_discrete(name="") +
  geom_smooth(method="lm", se=T, size=2)

rys1;

lm <- lm(data=d, gdppc ~ tu.density ); summary(lm);

##
rys2 <- ggplot(d, aes(d$tu.density,d$emprate)) + geom_point() +
  geom_text(aes(label=d$iso),size=2.0, vjust=-0.35)  +
  xlab("TU density (%)") + ylab("Empolyment rate (%)") +
  scale_colour_discrete(name="") +
  geom_smooth(method="lm", se=T, size=2);

rys2;

lm <- lm(data=d, emprate ~ tu.density ); summary(lm);

##
## http://www.oecd-ilibrary.org/employment/youth-unemployment-rate_20752342-table2
rys3 <- ggplot(d, aes(d$tu.density,d$yur)) + geom_point() +
  geom_text(aes(label=d$iso),size=2.0, vjust=-0.35)  +
  xlab("TU density (%)") + ylab("Youth unempolyment rate (%)") +
  scale_colour_discrete(name="") +
  geom_smooth(method="lm", se=T, size=2);

rys3;

lm <- lm(data=d, yur ~ tu.density ); summary(lm)


###
###
