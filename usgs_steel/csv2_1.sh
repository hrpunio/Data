#!/bin/bash
TMP="steel.csv"
rm $TMP

DD=`ls -1 *csv`

for csv in $DD ; do
   echo ">>>>>>>>>>>>>>>>>>>" $csv
   perl 1.pl $csv >> $TMP

done

awkFchkF.sh $TMP | sort -u

echo $done

