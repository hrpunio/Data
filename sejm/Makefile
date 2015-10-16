FILE=sejm7_wg_stazu_wieku
FILE2=sejm7_wg_stazu

all:
	R CMD Sweave $(FILE).Rnw && R CMD pdflatex $(FILE).tex

byage:
	R CMD Sweave $(FILE2).Rnw && R CMD pdflatex $(FILE2).tex

html:
	echo "library('R2HTML'); Sweave('$(FILE).Rnw', encoding='utf-8', syntax='SweaveSyntaxNoweb', driver=RweaveHTML)" | R --no-save --no-restore

## 1.R is tangled
R:
	R --no-save --no-restore < 1.R


knitr:
	Rscript -e "library(knitr); knit('$(FILE).Rmd')"


wiek:
	R CMD BATCH sejm.R
	rm .RData
