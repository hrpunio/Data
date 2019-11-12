library(ggplot2)
library(reshape2)

normalize <- function(x) { return (x /x[1] * 100 )  }
dg <- read.csv("newspaper_sales_EF.csv", sep = ';', header=T, na.string="NA");
fperiod  <- 61 ## 5 x12 +1

ggplot(dg,aes(x=as.Date(month), y=gw)) +
  geom_line() +
  xlab(label="") +
  ggtitle('Sprzedaż GazetyWyborczej 2015--2019 (https://www.zkdp.pl/)')
