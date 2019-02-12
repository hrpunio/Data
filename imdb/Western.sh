#!/bin/bash
#awk -F '\t' '$2 == "movie" && $9 ~ /Western/ && $6 != "\\N" && $6 > 1944 {print $0, "==>", $6}' title.basics.tsv > western45.tsv 
#wc -l western45.tsv 
### 3617 western45.tsv
#awk -F '\t' '$2 == "movie" && $9 !~ /Comedy/ && $9 ~ /Western/ && $6 != "\\N" && $6 > 1944 {print $0, "==>", $6}' title.basics.tsv > western45.tsv 
#wc -l western45.tsv 
### 3161 western45.tsv
##
#awk -F '\t' '$2 == "movie" && $9 ~ /Western/ {print $0, "==>", $6}' title.basics.tsv > western00.tsv 
#wc -l western00.tsv 
#6949 western00.tsv
awk -F '\t' '$2 == "movie" && $9 ~ /Western/ {print $0}' title.basics.tsv > western00.tsv 
