#!/bin/bash
# Process to pdf/jpg with Xetex convert and perl
# Typeset with Iwona condensed
#
HTML=ELEKTRONICZNEZAPISY.html
CSV=ELEKTRONICZNEZAPISY.csv
DENSITY=300

perl ELEKTRONICZNEZAPISY2csv.pl $HTML > $CSV

grep 'Magister' $CSV > KR2020_M.csv ; grep 'Doktor' $CSV > KR2020_D.csv
grep 'Profesor' $CSV > KR2020_P.csv

for c in KR2020*_[MDP].csv ; do echo "==>" $c ; 
  f=`basename $c .csv` && perl krsort_t.pl $c > ${f}.tex && xelatex ${f}.tex && pdfcrop ${f}.pdf \
    && convert -density $DENSITY ${f}-crop.pdf ${f}.jpg
done

