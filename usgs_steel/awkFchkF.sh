#!/bin/bash

while test $# -gt 0; do
  case "$1" in

     -nf)  shift; NF="$1";;
    -nf*)  NF="`echo :$1 | sed 's/^:-nf//'`";;

       *)  FF="$1";;
  esac
  shift
done



if [ "$NF" = "" ] ; then
  echo "** Report mode"
  awk -F ';'  '{print NF}' $FF
else
  echo "** Check mode"
  awk -v NFX="$NF" -F ';'  'NF != NFX {print "**", NF, $0}' $FF
fi 
