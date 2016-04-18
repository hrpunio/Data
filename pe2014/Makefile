##
komisje:
	R CMD BATCH komisje_glosy_razem.R && mv Rplots.pdf komisje_glosy_razem.pdf && \
		convert -flatten -density 300 komisje_glosy_razem.pdf komisje_glosy_razem.png
	R CMD BATCH freq.R && mv Rplots.pdf freq.pdf && convert -density 300 freq.pdf freq_%02d.png

