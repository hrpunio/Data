#!/usr/bin/perl
use locale;
use utf8;
binmode(STDOUT, ":utf8");
#use open ":encoding(utf8)";
use open IN => ":encoding(utf8)", OUT => ":utf8";
##

while (<>) { chomp();
  ##M. st. Warszawa M. st. Warszawa mazowieckie 146501 1
  ##dzielnice quarters
  #Bemowo M. st. Warszawa mazowieckie 146502 8
  #Białołęka M. st. Warszawa mazowieckie 146503 8
  #Bielany M. st. Warszawa mazowieckie 146504 8
  #Mokotów M. st. Warszawa mazowieckie 146505 8
  #Ochota M. st. Warszawa mazowieckie 146506 8
  #Praga-Południe M. st. Warszawa mazowieckie 146507 8
  #Praga-Północ M. st. Warszawa mazowieckie 146508 8
  #Rembertów M. st. Warszawa mazowieckie 146509 8
  #Śródmieście M. st. Warszawa mazowieckie 146510 8
  #Targówek M. st. Warszawa mazowieckie 146511 8
  #Ursus M. st. Warszawa mazowieckie 146512 8
  #Ursynów M. st. Warszawa mazowieckie 146513 8
  #Wawer M. st. Warszawa mazowieckie 146514 8
  #Wesoła M. st. Warszawa mazowieckie 146515 8
  #Wilanów M. st. Warszawa mazowieckie 146516 8
  #Włochy M. st. Warszawa mazowieckie 146517 8
  #Wola M. st. Warszawa mazowieckie 146518 8
  #Żoliborz M. st. Warszawa mazowieckie 146519 8
  #
  #https://stat.gov.pl/cps/rde/xbcr/bip/BIP_oz_wykaz_identyfikatorow.pdf

  ##pbw_10001_wbp1_1;126101;182;Komitet Wyborczy Prawo i Sprawiedliwość;Lasota Marek Wojciech;105;;
  lc($_);

  ($file, $t, $nr, $komitet, $k, $glosy, $mandat, $inne) = split /;/, $_;
  ## Wawa. Zondertreatment:
  if ( $t =~ /(14650[1-9]|14651[1-9])/) { $t = "146501"; }
  $K{"$k:$t"}++;
}

for $t (sort { $K{$b} <=> $K{$a} } keys %K) {
  print "$K{$t};$t\n";
}
