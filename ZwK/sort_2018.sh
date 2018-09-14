FILE=2018_KK_D
cat $FILE.csv | grep ';155;' | awk -F ';' '{ print $8  ";" $0}' | sort -n > ${FILE}_155.csv
cat $FILE.csv | grep ';115;' | awk -F ';' '{ print $8  ";" $0}' | sort -n > ${FILE}_115.csv
cat $FILE.csv | grep ';65;'  | awk -F ';' '{ print $8  ";" $0}' | sort -n > ${FILE}_65.csv
cat ${FILE}_155.csv ${FILE}_115.csv ${FILE}_65.csv | awk -F ';' 'BEGIN{OFS=";"; dist=0;}; 
  { if (dist != $7) {dist = $7; nr=0}; nr++; print nr, $2, $3, $4, $5, $6, $7 " km" , $8, $10 " kmh"}'

