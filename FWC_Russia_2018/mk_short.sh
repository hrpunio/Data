#!/bin/bash
for i in *html ; do awk '/otdvPlayer/,/sonda/ {print }' $i > s_$i ; done
