# Histogram: rozkład posłów wg numeru na liście kandydatów

library(reshape);
require(ggplot2);

kandydaci <- read.csv("Mandaty_2015.csv", sep = ';',  header=T, na.string="NA");
kandydaci <- subset (kandydaci, (komitet == "PETRU" | komitet == "KUKIZ" | komitet == "PSL" | komitet == "PO" | komitet == "PiS"  ));

qplot(numer, data=kandydaci, geom="histogram", binwidth=1.0, facets=komitet ~ .)
