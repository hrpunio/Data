all:
	R CMD BATCH poslowie_2015.R
hist:
	R CMD BATCH poslowie_2015h.R && mv Rplots.pdf rozklad_wg_numeru.pdf && \
		convert -flatten -density 600 rozklad_wg_numeru.pdf rozklad_wg_numeru.png


histk:
	R CMD BATCH kandydaci_2015.R && mv Rplots.pdf rozklad_wg_glosow.pdf && \
		convert -flatten -density 300 rozklad_wg_glosow.pdf rozklad_wg_glosow.png

areszty:
	R CMD BATCH areszty.R
dss:
	R CMD BATCH dss.R

wszyscy:
	R CMD BATCH wszyscy.R

zagranica:
	R CMD BATCH zagranica.R

komisje:
	R CMD BATCH komisje_glosy_razem.R && mv Rplots.pdf rozklad_komisji_wg_glosow.pdf && \
		convert -flatten -density 300 rozklad_komisji_wg_glosow.pdf rozklad_komisji_wg_glosow.png
#
#kandydaci:
#	time perl sumuj_wg_kandydatow.R kandydaci_obwody_wyniki_T.csv 

