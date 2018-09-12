#!/usr/bin/perl 
#
open (IDS,"idkomisji_teryt_nrobwodu.csv");

while (<IDS>) { chomp();
   ($idk,$teryt,$ido) = split /;/, $_;
   $IDO2IDK{"$teryt$ido"} = $idk;
   $IDK2IDO{$idk} = "$ido$teryt";
}

close(IDS);
## ## ##
open (COORDS, "kody_adresy_wspolrzedne.csv");

while (<COORDS>) { chomp();
  ($id, $teryt, $adres, $latlon) = split /;/, $_;
  $IDK2COORDS{$id} = $latlon;
}

close(COORDS);
## ## ##
#
open (IN, "komisje-frekwencja-ws2014.csv");

while (<IN>) { chomp();
  @tmp = split /;/, $_;
  $id = "$tmp[0]$tmp[2]"; ## $teryt$ido
  $idk = $IDO2IDK{$id};
  if ( exists $IDO2IDK{$id} ) { print "$_;$idk;$IDK2COORDS{$idk}\n"; }
  else { print "$_;?????\n";
     warn "*** NOT FOUND: $id => $_\n"; }

}

close(IN);
