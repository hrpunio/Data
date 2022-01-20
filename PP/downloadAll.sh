#!/bin/bash
# Interwencje
# Zatrzymani na gorącym uczynku	
# Zatrzymani poszukiwani	
# Zatrzymani nietrzeźwi kierujący	
# Wypadki drogowe	
# Zabici w wypadkach	
# Ranni w wypadkach

rm pp.html

for ((i=0;i<=274;i++)) do 
##for ((i=200;i<=280;i++)) do 
  if [ ! -f ${i}.html ] ; then
    curl -o ${i}.html "http://policja.pl/pol/form/1,Informacja-dzienna.html?page=${i}" ; 
    grep 'data-label' ${i}.html >> pp.html
    sleep 6
  else 
    grep 'data-label' ${i}.html >> pp.html
    echo done
  fi

done
