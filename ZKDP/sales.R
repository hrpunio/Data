library(ggplot2)
library(reshape2)

df <- read.csv("newspaper_sales_2015-17.csv", sep = ';',
               header=T, na.string="NA");

meltdf <- melt(df,id="month")

ggplot(meltdf,aes(x=month, y=value, colour=variable, group=variable)) +
  geom_line() +
  ylab(label="sales [ths]") +
  theme(legend.title=element_blank()) +
  scale_x_discrete (breaks=c("2015-01-01", "2015-06-01",
     "2016-01-01", "2016-06-01", "2017-01-01",  "2017-06-01"),
  labels=c("2015-01", "2015-06", "2016-01", "2016-06",
     "2017-01", "2017-06")  )

# https://stackoverflow.com/questions/10085806/extracting-specific-columns-from-a-data-frame
obs <- df[,c("month")]

normalize <- function(x) { return (x /x[1] * 100 )  }
dfN <- as.data.frame(lapply(df[-1], normalize))

# https://stackoverflow.com/questions/10150579/adding-a-column-to-a-data-frame
dfN["month"] <- obs

str(dfN)

meltdf <- melt(dfN,id="month")

# https://www.r-bloggers.com/what-is-a-linear-trend-by-the-way/
pN <- ggplot(meltdf,
 aes(x=month, y=value, colour=variable, group=variable)) + geom_line() +
 ylab(label="sales [ths]") +
 theme(legend.title=element_blank()) +
 stat_smooth(method = "lm", se=F) +
  scale_x_discrete (breaks=c("2015-01-01", "2015-06-01",
     "2016-01-01", "2016-06-01", "2017-01-01",  "2017-06-01"),
  labels=c("2015-01", "2015-06", "2016-01",
  "2016-06", "2017-01", "2017-06")  )

pN

# Trend liniowy
# http://t-redactyl.io/blog/2016/05/creating-plots-in-r-using-ggplot2-part-11-linear-regression-plots.html

# http://r-statistics.co/Time-Series-Analysis-With-R.html
seq = c (1:nrow(dfN))
dfN["trend"] <- seq

trendL.gw <- lm(data=dfN, gw ~ trend )
trendL.fakt <- lm(data=dfN, fakt ~ trend )
trendL.se <- lm(data=dfN, se ~ trend )

trendL.gw
trendL.fakt
trendL.se
