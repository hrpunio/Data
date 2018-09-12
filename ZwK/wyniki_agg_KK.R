#
z16 <- read.csv("2016_KK_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z16$time, list(Numer = z16$dist), summary)
# fun=fivenum -- minimum, lower-hinge, median, upper-hinge, maximum
z16$year <- 2016;

z17 <- read.csv("2017_KK_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z17$time, list(Numer = z17$dist), summary)
z17$year <- 2017;

###
zz16 <- z16[, c("dist", "kmH", "time", "year")];
zz17  <- z17[, c("dist", "kmH", "time", "year")];

zz <- rbind (zz16, zz17);

## tylko dystans 155
zz140 <- subset (zz, ( dist > 120 ));
sum140 <- aggregate (zz140$kmH, list(Numer = zz140$year), summary)
sum140

xl <- paste ("średnie 2016=", sum140$x[1,4], "kmh   2017=", sum140$x[2,4], " kmh")
boxplot (kmH ~ year, zz140, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="Kociewie kołem. Dystans profesor" )


