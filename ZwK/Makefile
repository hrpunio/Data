###
FILE=wyniki
FILE2=wyniki_agg
DENSITY=300
all:
	R CMD BATCH $(FILE).R
conv:
	convert -density 300 Rplots.pdf $(FILE).jpg

agg:
	R CMD BATCH $(FILE2).R
