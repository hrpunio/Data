## http://www.statmethods.net/stats/regression.html
## http://www.cookbook-r.com/Statistical_analysis/Regression_and_correlation/
## google:: trust wvs  Heston et al.
## http://tdhock.github.io/animint/geoms.html
#library(reshape)
require(ggplot2)


d <- read.csv("komisje-frekwencja14_15.csv", sep = ';',  header=T, na.string="NA");
str(d)
# Usuń zagraniczne (nietypowe):
d <- subset (d, ( teryt != 149901 ));
d <- subset (d, !grepl("Dom pomocy|Domu Pomocy|Areszt|Zakład karny", adres, ignore.case = TRUE));

d <- subset (d, ( pgnw > 6 & pgnw15 > 6 ));

str(d);

d;

write.table(d, file="komisje-frekwencja-nonvalid_14_15.csv", sep=';', quote=F);
