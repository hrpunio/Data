#!/usr/bin/perl
$pobranie1="../ws2014/komisje-frekwencja-ws2014.csv";
$pobranie2="ws2014_komisje.csv";


open(WX, $pobranie1) || die "cannot open $pobranie1\n";

while (<WX>) { 
  chomp();
  ($teryt, $nrk, $nro, $adres, $lwug, $lkw, $lkwzu, $lgnw, $lgw, $freq, $pgnw) = split /;/, $_;
  $LWUG1{"$teryt:$nro"} = $lwug; ## liczba wyborców
  $LGW1{"$teryt:$nro"} = $lgw; ## glosy ważne
  $ADDR1{"$teryt:$nro"} = $adres; ## 
}
close (WX);

#

open(WY, $pobranie2) || die "cannot open $pobranie2\n";
while (<WY>) {
  chomp();
  ($id, $teryt, $idk, $adres, $uprawnieni, $kartyOtrzymane, $kartyNiewydane, $kartyWydane, 
    $pelnomocnicy, $pakiety, $kartyWyjete, $koperty, $kartyNiewazne, $kartyWazne, 
    $glosy, $glosyNiewazne) = split /;/, $_;
  $LWUG2{"$teryt:$idk"} = $uprawnieni;
  $LGW2{"$teryt:$idk"} = $glosy;
  $ADDR2{"$teryt:$idk"} = $adres;
}
close (WY);

### LWUG1 ma mniej głosów ## ### ### ### ###
for $ik ( sort keys %LWUG1 ) {
    if ( ( $LWUG1{$ik} != $LWUG2{$ik} ) || ($LGW1{$ik} != $LGW2{$ik} )) {
       print "$ik :: $LWUG1{$ik} = $LWUG2{$ik} :: $LGW1{$ik} = $LGW2{$ik}\n";
    }
}
