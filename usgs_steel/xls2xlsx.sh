#!/bin/bash
for xlsx in *.xlsx; do

CSV="${xlsx%.*}.csv"
#perl xlsx2csv.pl ocena_prowadzących_PSW_2022L.xlsx > ocena_prowadzących_PSW_2022L.csv
echo Converting xlsx2csv.pl $xlsx $CSV ...
perl xlsx2csv.pl $xlsx > $CSV

done
