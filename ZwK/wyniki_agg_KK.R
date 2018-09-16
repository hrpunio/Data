#
z16 <- read.csv("2016_KK_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z16$time, list(Numer = z16$dist), summary)
# fun=fivenum -- minimum, lower-hinge, median, upper-hinge, maximum
z16$year <- 2016;

z17 <- read.csv("2017_KK_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z17$time, list(Numer = z17$dist), summary)
z17$year <- 2017;

z18 <- read.csv("2018_KK_D.csv", sep = ';',  header=T, na.string="NA", dec=".");
aggregate (z18$time, list(Numer = z18$dist), summary)
z18$year <- 2018;


###
zz16 <- z16[, c("dist", "kmH", "time", "year")];
zz17 <- z17[, c("dist", "kmH", "time", "year")];
zz18 <- z18[, c("dist", "kmH", "time", "year")];

zz <- rbind (zz16, zz17, zz18);

## tylko dystans 155
zz140 <- subset (zz, ( dist > 120 & kmH < 50 ));
sum140 <- aggregate (zz140$kmH, list(Numer = zz140$year), summary)
sum140

xl <- sprintf("średnie 2016 = %.2f | kmh 2017 = %.2f kmh | 2018 = %.2f kmh", 
        sum140$x[1,4], sum140$x[2,4], sum140$x[3,4])
boxplot (kmH ~ year, zz140, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="Kociewie kołem. Dystans profesor" )


zz120 <- subset (zz, ( dist > 100 & dist < 130 & kmH < 50 ));
sum120 <- aggregate (zz120$kmH, list(Numer = zz120$year), summary)
sum120

xl <- sprintf("średnie 2016 = %.2f | kmh 2017 = %.2f kmh | 2018 = %.2f kmh", 
        sum140$x[1,4], sum140$x[2,4], sum140$x[3,4])
boxplot (kmH ~ year, zz120, xlab = xl, ylab = "Śr.prędkość [kmh]", col = "yellow", main="Kociewie kołem. Dystans doktor" )

