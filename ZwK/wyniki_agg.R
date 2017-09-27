#
z16 <- read.csv("wyniki_zulawy_2016_D.csv", sep = ';',  header=T, na.string="NA", dec=",");
aggregate (z16$time, list(Numer = z16$dist), summary)
# fun=fivenum -- minimum, lower-hinge, median, upper-hinge, maximum
z16$year <- 2016;

z15 <- read.csv("wyniki_zulawy_2015_D.csv", sep = ';',  header=T, na.string="NA", dec=",");
aggregate (z15$time, list(Numer = z15$dist), summary)
z15$year <- 2015;

z17 <- read.csv("wyniki_zulawy_2017_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z17$time, list(Numer = z17$dist), summary)
z17$year <- 2017;

###
zz15 <- z15[, c("dist", "kmH", "time", "year")];
zz16 <- z16[, c("dist", "kmH", "time", "year")];
zz17  <- z17[, c("dist", "kmH", "time", "year")];

zz <- rbind (zz15, zz16, zz17);


## tylko dystans 140
zz140 <- subset (zz, ( dist == 140 ));
sum140 <- aggregate (zz140$kmH, list(Numer = zz140$year), summary)
sum140
xl <- paste ("średnie 2015=", sum140$x[1,4], "kmh   2016=", sum140$x[2,4], "kmh   2017=", sum140$x[3,4], " kmh")
boxplot (kmH ~ year, zz140, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="140km" )

## tylko dystans 55
zz75 <- subset (zz, ( dist > 60 & dist < 90 ));
sum75 <- aggregate (zz75$kmH, list(Numer = zz75$year), summary)
sum75
xl <- paste ("średnie 2015=", sum75$x[1,4], "kmh   2016=", sum75$x[2,4], "kmh   2017=", sum75$x[3,4], " kmh")
boxplot (kmH ~ year, zz75, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="80/75km" )

## tylko dystans 55
zz55 <- subset (zz, ( dist < 60 ));
sum55 <- aggregate (zz55$kmH, list(Numer = zz55$year), summary)
sum55
#str(sum55$x[2,4])
xl <- paste ("średnie 2015=", sum55$x[1,4], "kmh   2016=", sum55$x[2,4], "kmh   2017=", sum55$x[3,4], " kmh")

boxplot (kmH ~ year, zz55, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="55km" )

