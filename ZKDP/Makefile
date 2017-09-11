###
FILE=sales
all:
	LANG=C R CMD BATCH $(FILE).R
sales0:
	R CMD BATCH sales0.R
sales1:
	R CMD BATCH sales1.R

conv:
	convert -density 300 Rplots.pdf $(FILE)_2015-17.jpg


