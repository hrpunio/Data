#!/usr/bin/perl -w
## Zamienia pojedynczy plik yyyymmddhhmmss.js.gz na plik csv zawierający:
## w trybie S: dane dot liczby/udziały rowerów
## w trybie C: liczby/udziały rowerów oraz wsp. HH dla miast
## Domyślnym jest tryb `C'
## Data jest ustalana na podstawie nazwy pliku
##
##use strict;
use Getopt::Long;
use IO::Uncompress::Gunzip;
use JSON;
use utf8;
binmode(STDOUT, ":utf8");

my $MEVOHOME="/home/tomek/Projekty/Mevo";
my $mevoFile;
my $outMode='C'; ## or S
my $totalBikes;
my %totalBikes;

GetOptions('in=s' => \$mevoFile, 'out=s' => \$outMode);

print STDERR "Processing $mevoFile...\n";

## Data yyyymmddhhmm:
my $hrfull = substr ($mevoFile, 0, 12); ## date/hr/min/sec

my $js = IO::Uncompress::Gunzip->new("$mevoFile");
my $return = readline $js;

$return =~ s/\n/ /mg; ### one line
## tylko pierwsza zmienna (plik zawiera dwie)
$return =~ s/^[^']*'//; $return =~ s/'.*$//;
my $jsd = decode_json("$return");

foreach my $item ( @$jsd ) {
   my $places = $item->{places};

   foreach my $place ( @$places ) {
     my $kmlName;

     ### bike=0|true (jeżeli zero to stacja)
     my $bike = $place->{bike};

     if ($bike < 1) {$bike='S'; } else {$bike='B'; }

     ### odwrotność bike
     my $spot = $place->{spot};
        
     ## liczba rowerów
     my $bikesNo = $place->{bikes};
     my $bikedbikesNo = $place->{booked_bikes};

     ## lista numerów rowerów
     my $bikeList ='';
     my $bikes = $place->{bike_numbers};

     foreach my $b_ ( @$bikes ) {  $bikeList .= "$b_,";  }

     ## tylko stacje (bez luźnych bików)
     my $lat = sprintf "%.8f", $place->{lat};
     my $lng = sprintf "%.8f", $place->{lng};

     ## uid pozycji (stały dla stacji)
     my $uid = $place->{uid};

     my $coord = "$lat $lng";
     my $city = $place->{city};

     my $number = $place->{number};

     if ($number <= 0 ) {$number = "00000"; }

     $statOrBike{"S$number;$lng,$lat"} = $bikesNo;
     $statOrBikeCity{"S$number;$lng,$lat"} = "$city";
     $totalBikes += $bikesNo;
     $totalBikes{"$city"} += $bikesNo;

     }
}

## sort
my %Shares ;
my %SharesStats ;
my $localshare;

for $sb (sort {$statOrBike{$b} <=> $statOrBike{$a}} keys %statOrBike) {

     if ($totalBikes{$statOrBikeCity{$sb}} > 0) {
        $localshare = $statOrBike{$sb}/$totalBikes{$statOrBikeCity{$sb}}*100;
     } else {  $localshare = 0; }

     ### ###
     if ($outMode eq 'S') {
     ## Drukuje dane dot indywidualnych stacji
     ## idStacji;współrzędne;miasto;rowery;%rowery;%roweryLokalnie
     ## rowery -- liczba rowerów na stacji
     ## %rowerów -- udział rowerów w całości
     ## %roweryLokalnie -- udział w całości ale całość = miasto
     printf "%s;%s;%i;%.3f;%.3f\n", 
         $sb, 
         $statOrBikeCity{$sb},
         $statOrBike{$sb}, 
         $statOrBike{$sb}/$totalBikes *100,
         $localshare;
     }
     if ($localshare > 1) {
     ## For speed do not count 1 and less
     ## HHindex
        $Shares{$statOrBikeCity{$sb}} += $localshare * $localshare;
        $SharesStats{$statOrBikeCity{$sb}} .= sprintf "%.1f ", $localshare;
     }       
}

if ($outMode eq 'C') {
#### cities
###########
  for $c (sort {$Shares{$b} <=> $Shares{$a}} keys %Shares) {
     my $xx = sprintf "%.1f", $Shares{$c};
     my $zz = $SharesStats{$c}; chop($zz);
     my $yy;

     if ( $totalBikes{$c}/$totalBikes > 0 ) {
        $yy = sprintf "%.1f", $totalBikes{$c}/$totalBikes * 100;
     } else { $yy = 0 ;}

     ## Drukuje zbiorczo wg miast
     ## -------------------------
     ## dataCzas;miasto;HHI;rowery;%rowery;%roweryLista
     ## rowery -- liczba rowerów w mieście
     ## %rowery -- rowery w mieście jako % w całości
     ## %roweryLista -- rowery na stacjach jako % w całości w danym mieście
     print "$hrfull;$c;$xx;$totalBikes{$c};$yy;$zz\n";
  }
}
