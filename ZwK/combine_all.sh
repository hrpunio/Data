#!/bin/bash
awk -F';' 'BEGIN{OFS=";"}; {print $0 ";2015;K"}' 2015_KK_D.csv  > ROVER_2015_2017.csv.tmp
#
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2015;R"}' 2015_KR_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2016;K"}' 2016_KK_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2016;R"}' 2016_KR_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2017;K"}' 2017_KK_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2017;R"}' 2017_KR_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2018;K"}' 2018_KK_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2018;R"}' 2018_KR_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2015;Z"}' wyniki_zulawy_2015_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2016;Z"}' wyniki_zulawy_2016_D.csv >> ROVER_2015_2017.csv.tmp
awk -F';' 'BEGIN{OFS=";"}{print $0 ";2017;Z"}' wyniki_zulawy_2017_D.csv >> ROVER_2015_2017.csv.tmp
##
cat ROVER_2015_2017.csv.tmp | grep -i -v "Nazwisko" | awk -F ';' 'BEGIN{OFS=";"}; {print $2,$3,$4,$5,$6,$7,$8,$9,$10,$11}' | \
   tr '[A-ZĄĆĘŁŃÓŚŻŹ]' '[a-ząćęłńóśżź]' | \
   sort > ROVER_2015_2017.csv
##
rm ROVER_2015_2017.csv.tmp
