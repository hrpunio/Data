library(ggplot2)

d <- read.csv("mevo_dist_log_agg.csv", sep = ';',  header=T, na.string="NA");

fivenum(d$dist)
mean(d$dist)

mm <- summary(d$dist, na.rm=TRUE);
ms <- sd(d$dist, na.rm=TRUE)
qq <- quantile(d$dist, seq(0,1, by = 0.1))
qq

summaryLabel <- sprintf ("Śr = %.1f\nMe = %.1f\nq1 = %.1f\nq3 = %.1f\nS = %.1f",
  mm[["Mean"]], mm[["Median"]], mm[["1st Qu."]], mm[["3rd Qu."]], ms)
##summaryLabel <- "";


ggplot(d, aes(x = dist)) + geom_histogram(binwidth = 50) + annotate("text", x=400, y=50, label=summaryLabel )  +
 ggtitle ("MEVO bikes by distance (km/2019)")

ggplot(d, aes(x = dist)) + geom_histogram(binwidth = 250) + annotate("text", x=400, y=50, label=summaryLabel )  +
 ggtitle ("MEVO bikes by distance (km/2019)")
