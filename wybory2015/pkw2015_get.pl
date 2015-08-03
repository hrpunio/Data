#!/usr/bin/perl
use LWP::Simple;

## dla 27818 zwracana jest pusta strona
my $komisjaKoniec = 27817 ;
my $base_uri='http://prezydent2015.pkw.gov.pl/321_protokol_komisji_obwodowej';

open (LOG, ">Wybory2015.log");

for ($komisja=1; $komisja<=$komisjaKoniec; $komisja++) {

  unless (is_success(getstore("$base_uri/$komisja", "$komisja.html"))) {
     print LOG "** Problems: $komisja\n"; }
  sleep 2;
}

close (LOG);

