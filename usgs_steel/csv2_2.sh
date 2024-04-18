#!/bin/bash
TMP="steel.csv"
O="steel1.csv"

perl 2.pl $TMP > $O

awkFchkF.sh $O | sort -u

echo $done


awk -F ';' '$4 ~ /[^0-9\.]/ {print $0}' $O


echo "======================"

grep '^;' $O
