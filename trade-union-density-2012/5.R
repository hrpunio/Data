require(ggplot2)

## https://stats.oecd.org/Index.aspx?DataSetCode=UN_DEN
d <- read.csv("union_density_and_gdp.csv", sep = ';',  header=T, na.string="NA");

## tu.density = ratio of  wage and salary earners
## that are trade union members, divided by the total number of wage and salary earners:
## gdppc = GDP per capita
ggplot(d, aes(d$tu.density,d$gdppc)) + geom_point() +
  geom_text(aes(label=d$iso),size=2.0, vjust=-0.35)  + xlab("TU density (%)") + ylab("GDPpc (tys USD)") +
  scale_colour_discrete(name="") +
  geom_smooth(method=lm,se=T, size=2)

lm <- lm(data=d, gdppc ~ tu.density ); summary(lm)
