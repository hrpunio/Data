library(reshape)
require(ggplot2)

d <- read.csv("western00_byyear.csv", sep = ';',  header=T, na.string="NA");

d <- subset (d, (year < 2019 ));

ggplot(d, aes(x = year)) +
  geom_line(aes(y = movies, colour = 'movies'), size=2) +
  ylab(label="#Movies") +
  labs(colour = "") +
  theme(legend.position="top") +
  theme(legend.text=element_text(size=12));

