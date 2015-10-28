all:
	R CMD BATCH poslowie_2015.R
hist:
	R CMD BATCH poslowie_2015h.R && mv Rplots.pdf rozklad_wg_numeru.pdf && convert -density 600 rozklad_wg_numeru.pdf rozklad_wg_numeru.png

