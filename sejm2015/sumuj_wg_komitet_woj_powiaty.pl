#!/usr/bin/perl
#
# Wypisuje wynik wg komitetów oraz powiatów lub gmin
#
# Wykorzystanie: perl sumuj_wg_komitet_woj_powiaty.pl kandydaci_obwody_wyniki_T.csv > plik-wynikowy.txt
#
use Getopt::Long;
my $typagregacji = 'powiat'; # domyślnie agregacja = powiaty
my $ActionAggrGmina = '';

GetOptions("gminy" => \$ActionAggrGmina, "gmina" => \$ActionAggrGmina,);

if ( $ActionAggrGmina ) { $typagregacji = 'gmina';  
    print STDERR "**** Poziom agregacji: $typagregacji\n"; }

################################

open (O, "kody_komisji_s.csv") ;

while (<O>) {
  chomp();
  # okreg;tkod;idkomisji
  @tmp = split (/;/, $_);
  $Okreg{"$tmp[1]"} = $tmp[0]; ## teryt -> okręg 
}

close (O);

print STDERR "**** wczytałem kody z pliku kody_komisji_s.csv\n";

# Dodaj info o typie gminy
open (T, "teryt_kody.csv") || die "cannot open teryt_kody.csv";
while (<T>) {
  chomp();
  # woj;powiat;gmina;typ;nazwa
  @tmp = split (/;/, $_);
  ## Miasta na prawach powiatu są problemem bo nie ma gminy ww:pp:01, która
  ## pojawia się w danych PKW. Zatem tworzymy to sztucznie
  if ( $tmp[2] eq "NA" && $tmp[5] =~ /na prawach powiatu/ ) {
     ##14;65;NA;NA;Warszawa;miasto stołeczne, na prawach powiatu
     $GminaTyp{"$tmp[0]$tmp[1]01"} = 1;
     $GminaNazwa{"$tmp[0]$tmp[1]01"} = "$tmp[4]*";
     print STDERR "*** $tmp[0]:$tmp[1]:01 :: 1 :: $tmp[4] ($tmp[5])\n";
     next ;
  }
  
  unless ( $tmp[2] eq "NA" ) {## Powiat lub Woj
     ## Gmina miejska: TERYT = 1 lub 8 -- dzielnice gminy Warszawa-Centrum
     ## Por https://pl.wikipedia.org/wiki/TERC
     if ($tmp[3] == 8 ) { $tmp[3] = 1 }
     ## 9 – delegatury i dzielnice innych gmin miejskich.
     if ($tmp[3] == 9 ) { $tmp[3] = 1 }

     $GminaTyp{"$tmp[0]$tmp[1]$tmp[2]"} += $tmp[3]; ## sumujemy typy
     $GminaNazwa{"$tmp[0]$tmp[1]$tmp[2]"} = $tmp[4];
     #print STDERR "$tmp[0]:$tmp[1]:$tmp[2] :: $tmp[3] :: $tmp[4]\n";
  }
}
## Gminy dzielimy na miejskie 1 i pozostałe (jeżeli GminaTyp> 1 )
## Kod TERYT gminy miejskiej = 1 (8 poprzednio 'znormalizowaliśmy')
for $g (keys %GminaTyp) { if ($GminaTyp{$g} > 1) {$GminaTyp{$g} = 2 } }

close (T);

print STDERR "**** wczytałem kody z pliku teryt_kody.csv\n";

## trzy (tajemnicze) obwody specjalne:
## Np. http://parlament2015.pkw.gov.pl/321_protokol_komisji_obwodowej/103140 
$GminaTyp{"229901"} = 0; $GminaNazwa{"229901"} = 'statki gdańsk*';
$GminaTyp{"229801"} = 0; $GminaNazwa{"229801"} = 'statki gdynia*';
$GminaTyp{"149901"} = 0; $GminaNazwa{"149901"} = 'zagranica*';

################################

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);
  if (exists ($Okreg{$tmp[6]}) ) {  $okr = $Okreg{$tmp[6]}; }
  else { die "*** Problem with $_ No such district***\n"; }
  $powiatLubGmina = "$tmp[6]"; # kodTeryt powiatu/gminy
 
  if ($typagregacji eq 'powiat') {# Jeżeli powiat usuń 2 ostatnie cyfry
     $powiatLubGmina =~ /^([0-9][0-9][0-9][0-9])/;
     $powiatLubGmina = "$1";
  }

  $Glosy{"$tmp[4]"}{"$powiatLubGmina"} += $tmp[5];
  $GlosyRazem{"$powiatLubGmina"} += $tmp[5];

  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n";

### ## ### ###
for $k (sort keys %Glosy) {
   $k_razem = 0;
   print "$k:\n";

   #for $w (sort {$a<=>$b} keys %{ $Glosy {$k} } ) {
   for $w (sort { $Glosy{$k}{$b}/$GlosyRazem{$b} <=> $Glosy{$k}{$a}/$GlosyRazem{$a} } keys %{ $Glosy {$k} } ) {

      if ($typagregacji eq 'powiat') {
         print "$w : $Glosy{$k}{$w}\n";
      } else {
         printf "%1.1s %6.6s %6.6s %5d %6.3f (%s)\n", $GminaTyp{$w}, "$w", "$k",
	   $Glosy{"$k"}{"$w"}, $Glosy{"$k"}{"$w"}/$GlosyRazem{"$w"} * 100,
          $GminaNazwa{"$w"};
      }
  
      unless ($typagregacji eq 'powiat') {  }
      $k_razem += $Glosy{$k}{$w};
   }
   print "## Razem: $k: $k_razem\n";
}

