#!/bin/bash
# Pobierz pliki MEVO z poprzedniego dnia (z umbriela) i przetwórz
# ---------------------------------------------------------------
#
# BACKUPA=`date -d '-1 day' '+%u'`
#
MDIR=`date -d "yesterday" '+%Y%m'`
YDAY=`date -d "yesterday" '+%Y%m%d'`
MEVO="/home/tomek/Dist/umbriel/home/tomek/Mevo"
LMEVO="/home/tomek/Projekty/Mevo"

RAINS="/home/tomek/Dist/umbriel/home/tomek/Logs/Weather/rains_daily.csv"
B_CHART_FILE="mevo_daily_bikes"
S_CHART_FILE="mevo_daily_zstats"
RB_FILE="mevo_daily_bikes.R"
RS_FILE="mevo_daily_zstats.R"
S_FILE="MEVO_STATIONS_ALT.csv"
##
B_OUT_FILE="MEVO_DAILY_BIKES.csv"
REG_BIKES="MEVO_REGISTERED_BIKES.csv"

echo "Process remote ${YDAY}_log.csv // Append to local $B_OUT_FILE // Generate charts..."

cd $LMEVO

## Make a copy

cp $B_OUT_FILE ${B_OUT_FILE}.1
cp $REG_BIKES ${REG_BIKES}.1

if [ -f "$MEVO/$MDIR/${YDAY}_log.csv" ] ; then
   echo "Copying $MEVO/$MDIR/$YDAY*js.gz  $LMEVO/$MDIR"
   cp $MEVO/$MDIR/$YDAY*js.gz $LMEVO/$MDIR
   ## ## ##
   echo "Copying $MEVO/$MDIR/${YDAY}_log.csv $LMEVO/$MDIR"
   cp $MEVO/$MDIR/${YDAY}_log.csv $LMEVO
   ##cp $RAINS $LMEVO
   ##perl $LMEVO/rains-from-13.pl $LMEVO/rains_daily.csv  > $LMEVO/mevo_rains_daily.csv
else
   echo "mount $MEVO/$MDIR"
   exit;
fi

mevo_yesterday.pl -s $S_FILE  >> $B_OUT_FILE && \
R CMD BATCH $RB_FILE && \
R CMD BATCH $RS_FILE && \
convert -density 150 ${B_CHART_FILE}.pdf ${B_CHART_FILE}.jpg && \
convert -density 150 ${S_CHART_FILE}.pdf ${S_CHART_FILE}.jpg

echo "Appended..."
tail -n7 $B_OUT_FILE
