all:
	R CMD Sweave 1.Rnw && R CMD pdflatex 1.tex

html:
	##echo "library(R2HTML); Sweave(’sample.Rnw’, driver=RweaveHTML)" | R --no-save --no-restore
	echo "library('R2HTML'); Sweave('1_h.Rnw', encoding='utf-8', syntax='SweaveSyntaxNoweb', driver=RweaveHTML)" | R --no-save --no-restore

## 1.R is tangled
R:
	R --no-save --no-restore < 1.R
