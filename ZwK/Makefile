###
FILE=wyniki
DENSITY=300
all:
	R CMD BATCH $(FILE).R
conv:
	convert -density 300 Rplots.pdf $(FILE).jpg

