#!/bin/bash
F=ZwK2018
#wget 'https://www.czasomierzyk.pl/zapisy2016/kociewiekolem/index.php?akcja=lista' -O $F.out
wget 'http://www.czasomierzyk.pl/zapisy2016/zulawywkolo/index.php?akcja=lista' -O $F.out
dos2unix $F.out 
awk '/<table/,/<\/table/ {print }' $F.out > $F.txt
cat $F.txt | perl -e 'while (<>) { chomp();
   $_ =~ s/\r//g;
   $_ =~ s/title="[^"]+"//g;
   $_ =~ s/<tr><td[ \t]+class="wypis2">/\n/g;
   $_ =~ s/<tr><td[ \t]+class="wypis">//g;
   $_ =~ s/<\/td><td[ \t]+class="wypis.?">/;/g;
   $_ =~ s/<\/td><\/tr>/\n/g;

   $_ =~ s/<table border="0">|^<tr>$|<td>l.p.<\/td>|<td>nazwisko<\/td>//g;
   $_ =~ s/<td>imię<\/td>|<td>miejscowość<\/td>|<td>firma<\/td>//g;
   $_ =~ s/<td>dystans<\/td><td>opłata|<\/table>//g;
   $_ =~ s/<td>nazwisko imię<\/td>|<td>klub\/firma<\/td>//g;

   #$_ =~ s/<[^<>]+>//g;
   $_ =~ s/^[ \t]*$//g;

   if ($_ !~ /^$/ ) {  print "$_\n"; }
}' | grep -v '^$' > $F.tmp 

awk -F ';' 'BEGIN {OFS=";"}; NF==7 {print $1, $2 " " $3, $4, $5, $6, $7 }; NF==6 {print $0} ' $F.tmp |
perl -e ' print "lp;nazwisko;miejscowość;firma;dystans;oplata;plec\n";
while (<>){ chomp();@tmp = split /;/, $_;
    if ($tmp[1] =~ /a$/ ) {$s ='K'} else {$s = 'M'}; print "$_;$s\n";
   }' > $F.csv

#
#rm $F.tmp $F.txt



