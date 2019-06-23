library(ggplot2)
library(reshape2)

normalize <- function(x) { return (x /x[1] * 100 )  }
dg <- read.csv("newspaper_sales_EF.csv", sep = ';', header=T, na.string="NA");
fperiod  <- 61 ## 5 x12 +1

### sales in ths ###############################################################
df <- dg

seq = c (1:nrow(df))

seq

fperiod

# str(df)
meltdf <- melt(df,id="month")


df["trend"] <- seq
trendL.gw <- lm(data=df, gw ~ trend )
trendL.fakt <- lm(data=df, fakt ~ trend )
trendL.se <- lm(data=df, se ~ trend )
trendL.rz <- lm(data=df, rz ~ trend )

summary(trendL.gw)
summary(trendL.fakt)
summary(trendL.se)
summary(trendL.rz)

trendcoeffs.gw <- coef(trendL.gw);
trendcoeffs.fakt <- coef(trendL.fakt);
trendcoeffs.se <- coef(trendL.se);
trendcoeffs.rz <- coef(trendL.rz);

# str(meltdf)
#> str(meltdf)
#'data.frame':   208 obs. of  3 variables:
# $ month   : Factor w/ 52 levels "2015-01-01","2015-02-01",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ variable: Factor w/ 4 levels "gw","se","fakt",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ value   : int  168859 168077 158924 166740 156043 154296 152873 153541 149416 155735 ...
## prognoza 1/2020
forecast.gw   <- trendcoeffs.gw[2]   * fperiod + trendcoeffs.gw[1]
forecast.fakt <- trendcoeffs.fakt[2] * fperiod + trendcoeffs.fakt[1]
forecast.se   <- trendcoeffs.se[2]   * fperiod + trendcoeffs.se[1]
forecast.rz   <- trendcoeffs.rz[2]   * fperiod + trendcoeffs.rz[1]

label.gw   <- sprintf("GW: s = %.2f t + %.2f", trendcoeffs.gw[2], trendcoeffs.gw[1] )
label.fakt <- sprintf("Fakt: s = %.2f t + %.2f", trendcoeffs.fakt[2], trendcoeffs.fakt[1] )
label.se   <- sprintf("SE: s = %.2f t + %.2f", trendcoeffs.se[2], trendcoeffs.se[1] )
label.rz   <- sprintf("Rz: s = %.2f t + %.2f", trendcoeffs.rz[2], trendcoeffs.rz[1] )

xpx <- 6;
ggplot(meltdf,aes(x=month, y=value, colour=variable, group=variable)) +
  geom_point() +
  ylab(label="sales [ths]") +
  theme(legend.title=element_blank()) +
 stat_smooth(method = "lm", se=F) +
##
ggtitle('Newspaper sales (data: https://www.zkdp.pl/)') +
annotate("text", x = xpx, y = 240000, label = sprintf("Trend:\n%s\n%s\n%s\n%s", 
   label.gw, label.fakt, label.se, label.rz), size=3, hjust = 0) +
annotate("text", x = 6, y = 210000, label = sprintf("Forecast 1/2020 (ths): %.1f (gw) %.1f (f)\n%.1f (se) %.1f (rz)", 
  forecast.gw/1000, forecast.fakt/1000, forecast.se/1000, forecast.rz/1000 ), size=3, hjust = 0, fontface = "bold") +
##
  scale_x_discrete (breaks=c("2015-01-01", "2015-07-01",
     "2016-01-01", "2016-07-01", "2017-01-01", "2017-07-01", "2018-01-01", "2018-07-01", "2019-01-01", "2019-07-01" ),
  labels=c("2015-01", "2015-07", "2016-01", "2016-07", "2017-01", "2017-07", "2018-01", "2018-07", "2019-01", "2019-07")  )

# https://stackoverflow.com/questions/10085806/extracting-specific-columns-from-a-data-frame
obs <- df[,c("month")]

### sales in %%% ###############################################################

dfN <- as.data.frame(lapply(dg[-1], normalize))
seq = c (1:nrow(dfN))

# https://stackoverflow.com/questions/10150579/adding-a-column-to-a-data-frame
dfN["month"] <- obs

str(dfN)

dfN

meltdf <- melt(dfN,id="month")

# Trend liniowy
# http://t-redactyl.io/blog/2016/05/creating-plots-in-r-using-ggplot2-part-11-linear-regression-plots.html

# http://r-statistics.co/Time-Series-Analysis-With-R.html
dfN["trend"] <- seq

trendL.gw <- lm(data=dfN, gw ~ trend )
trendL.fakt <- lm(data=dfN, fakt ~ trend )
trendL.se <- lm(data=dfN, se ~ trend )
trendL.rz <- lm(data=dfN, rz ~ trend )

summary(trendL.gw)
summary(trendL.fakt)
summary(trendL.se)
summary(trendL.rz)

trendcoeffs.gw <- coef(trendL.gw);
trendcoeffs.fakt <- coef(trendL.fakt);
trendcoeffs.se <- coef(trendL.se);
trendcoeffs.rz <- coef(trendL.rz);

label.gw   <- sprintf("GW: s = %.2f t + %.2f", trendcoeffs.gw[2], trendcoeffs.gw[1] )
label.fakt <- sprintf("Fakt: s = %.2f t + %.2f", trendcoeffs.fakt[2], trendcoeffs.fakt[1] )
label.se   <- sprintf("SE: s = %.2f t + %.2f", trendcoeffs.se[2], trendcoeffs.se[1] )
label.rz   <- sprintf("Rz: s = %.2f t + %.2f", trendcoeffs.rz[2], trendcoeffs.rz[1] )

# https://www.r-bloggers.com/what-is-a-linear-trend-by-the-way/
pN <- ggplot(meltdf,
 aes(x=month, y=value, colour=variable, group=variable)) + 
 geom_line(size=.3) +
 geom_point(size=1) +
 ylab(label="% sales") +
 theme(legend.title=element_blank()) +
 ggtitle('Newspaper sales (data: https://www.zkdp.pl/; 2015-01=100%)') +
 ##ggtitle('Sprzedaż gazet (dane ZKDP; 2015-01=100%)') +
 stat_smooth(method = "lm", se=F) +
##
annotate("text", x = 11, y = 60, label = sprintf("Trend:\n%s\n%s\n%s\n%s", 
   label.gw, label.fakt, label.se, label.rz), size=3, hjust = 0) +
#annotate("text", x = 15, y = 70, label = sprintf("Trend:"), size=3, hjust = 0) +
#annotate("text", x = 15, y = 67, label = sprintf("GW: s = %.2f t + %.2f", trendcoeffs.gw[2], trendcoeffs.gw[1] ), size=3, hjust = 0) +
#annotate("text", x = 15, y = 64, label = sprintf("Fakt: s = %.2f t + %.2f", trendcoeffs.fakt[2], trendcoeffs.fakt[1] ), size=3, hjust = 0) +
#annotate("text", x = 15, y = 61, label = sprintf("SE: s = %.2f t + %.2f", trendcoeffs.se[2], trendcoeffs.se[1] ), size=3, hjust = 0) +
#annotate("text", x = 15, y = 58, label = sprintf("Rz: s = %.2f t + %.2f", trendcoeffs.rz[2], trendcoeffs.rz[1] ), size=3, hjust = 0) +
##
  scale_x_discrete (breaks=c("2015-01-01", "2015-07-01",
     "2016-01-01", "2016-07-01", "2017-01-01", "2017-07-01", "2018-01-01", "2018-07-01", "2019-01-01", "2019-07-01"),
  labels=c("2015-01", "2015-07", "2016-01", "2016-07", "2017-01", "2017-07", "2018-01", "2018-07", "2019-01", "2019-07")  )

pN
