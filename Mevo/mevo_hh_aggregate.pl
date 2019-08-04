#!/usr/bin/perl
## Oblicza zbiorcze (dzienne) wartości współczynnika HHI dla wybranych miast 
##  na podstawie zawartości pliku HH.csv o strukturze:
##    201907010000;Stężyca;5000.0;6;0.9;66.7 16.7 16.7
##    data-godzina;miasto;hhindex;liczba-rowerów;%-rowerów;udziały-wg-stacji
##
## Plik HH.csv powstaje w wyniku wykonania (w pętli dla każdego pliku yyyymmddhhmmss.js.gz):
## perl mevo_file2csv.pl -in yyyymmddhhmmss.js.gz >> HH.csv
## for i in *.js.gz; do  perl mevo_file2csv.pl -in $i >> HH.csv ; done
##
## Wynik działania tego skryptu jest zapisywany w postaci:
##  date;Gd;Ga;PGd;Rumia;Sop;Tczew;status
##  2019-07-01 00:00;42.4;163.7;919.6;814.0;1516.1;668.2;1
## Uwaga: miasta raportowane określa %Cities (domyślnie Gd/GA/Sop/Tczew/Rumia/PG)
## Uwaga2: status = dzień powszedni 1..5 (pon--piątek)
## 6..7 (niedziela)
## jeżeli święto 11--15 (pon--piątek) lub 16--17 święto+sobota/niedziela
## listę świąt (dla bieżącego roku) definiuje @Holidays
## Przykład wykorzystania:
## MEVO_HH_AGGR_2019.csv -- dane 1.5--30.7 2019
## mevo_hrly_hh.R -- wykresy średniego godzinowego HHI dla Gd/Ga/Sop/Tczew 
##
use Date::Calc qw(Day_of_Week);
## Holidays 2019 ## ## ## ##

my @Holidays = ('2019-01-01', '2019-01-06', '2019-04-21', '2019-04-22',
'2019-05-01', '2019-05-03', '2019-06-09', '2019-06-20', '2019-08-15',
'2019-11-01', '2019-11-11', '2019-12-25', '2019-12-26' );

%Cities = ( 'Gdańsk' => 'Gd', 
  'Gdynia' => 'Ga', 
  'Sopot' => 'Sop', 
  'Tczew' => 'Tczew', 
  'Rumia' => 'Rumia',
  'Pruszcz Gdański' => 'PGd');
my %DoWDayName = ( 
   1 => 'poniedziałek', 2 => 'wtorek', 3=> 'środa', 4 => 'czwartek', 
   5 => 'piątek', 6 => 'sobota', 7 => 'niedziela' );

while (<>) {
  ##201907010000;Stężyca;5000.0;6;0.9;66.7 16.7 16.7
  my ($date, $city, $hh, $bikes, $share, $list) = split /;/, $_;
  $hr = substr ($date, 0, 10);
  $Obs{$city}{$hr}++;
  $HH{$city}{$hr} += $hh;
  $Hrs{$hr}=1;
  $HHtotal{$city}+=$hh;
  $NNtotal{$city}++;
}

## Nagłówek
print "date";
for $c (sort keys %Cities) { printf ";%s", $Cities{$c}; }
print ";status\n";

for $d (sort keys %Hrs) {
   ## Day of week
   $yearN = substr($d,0,4);
   $monthN = substr($d,4,2);
   $dayN = substr($d,6,2);
   $hrN = substr($d,8,2);
   $secN = substr($d,10,2);
   my $dowN = Day_of_Week($yearN,$monthN,$dayN)
     + check_if_holiday("$yearN-$monthN-$dayN");
   print "${yearN}-${monthN}-${dayN} $hrN:00";

   for $c (sort keys %Cities) {
    $hh = $HH{$c}{$d} / $Obs{$c}{$d};
    printf ";%.1f", $hh;
   }
   print ";$dowN\n";
}
  
## ## ## ## ## ##
for $c (sort keys %Cities) { 
   $hh = $HHtotal{$c} / $NNtotal{$c};
   printf STDERR "%s %.1f\n", $c, $hh;
}

## ## ## ## ## ## ## ## ##
sub check_if_holiday {####
  ## Sprawdzenie czy d2c jest dniem świątecznym
  ## argument d2c: yyyy-mm-dd
  my $d2c = shift;
  foreach $d (@Holidays) {
    ## $d2c jest dniem świątecznym
    if ($d eq $d2c ) { return (10); }
  }
  return (0);
}##//
