#!/bin/bash
RWC2019=rwc2019
RWCALL=rwc-1999-2019

echo "[1] R..."
R CMD BATCH ${RWCALL}.R ; mv Rplots.pdf ${RWCALL}.pdf

echo "[1] Convert..."
convert -density 150 ${RWCALL}.pdf ${RWCALL}.jpg

echo "[1] Montage..."
montage ${RWCALL}-2.jpg ${RWCALL}-10.jpg ${RWCALL}-4.jpg ${RWCALL}-11.jpg -tile 2x2 -border 0 -geometry 1050 RWC_2019_0001.jpg
montage ${RWCALL}-9.jpg ${RWCALL}-13.jpg ${RWCALL}-5.jpg ${RWCALL}-7.jpg -tile 2x2 -border 0 -geometry 1050 RWC_2019_0002.jpg


echo "[2] R..."
R CMD BATCH ${RWC2019}.R ; mv Rplots.pdf ${RWC2019}.pdf

echo "[2] Convert..."
convert -density 150 ${RWC2019}.pdf ${RWC2019}.jpg

echo "[2] Montage..."
montage ${RWC2019}-0.jpg ${RWC2019}-1.jpg ${RWC2019}-2.jpg ${RWC2019}-3.jpg -tile 2x2 -border 0 -geometry 1050 RWC_2019_0000.jpg
