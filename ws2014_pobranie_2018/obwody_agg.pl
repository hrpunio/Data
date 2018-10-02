#!/usr/bin/perl
## ### ### ### ###
%Numer2komitet = ('1' => 'PSL', '2' => 'DB', '3' => 'PiS', '4' => 'PO', 
   '5' => 'RN', '6' => 'SLDLR', '7' => 'NPKM');

for $kk ( sort keys %Numer2komitet ) { 
    $hdr_ .= $Numer2komitet{$kk} . ";";
    $hdp_ .= $Numer2komitet{$kk} . "p;";
}
print STDERR "*** Komitety *** $hdr_ $hdp_\n";
@k_ = sort (keys %Numer2komitet );

open (O, "ws2014_kandydaci_S.csv" );

while (<O>) { chomp;
  ($teryt, $idk, $komitet, $nr, $glosy) = split (/;/, $_);
  if ($komitet > 7 ) { next }
  else {
     ###print STDERR "**** $glosy ****\n";
     $GlosyByKomisjaK{"$teryt;$idk"}{"$komitet"} += $glosy;
     $GlosyByKomitetN{"$komitet"}{"$nr"} += $glosy;
  }
}

## ### ### ### ###
print "teryt;idk;glosyLK;${hdr_}${hdp_}\n";

for $idK ( sort keys %GlosyByKomisjaK ) { 
    $r= $p= ''; $totalK = 0;
    for $kk ( @k_ ) {
       if (exists ($GlosyByKomisjaK{$idK}{$kk} )) {
          $totalK += $GlosyByKomisjaK{$idK}{$kk};
          $r .= sprintf "%d;", $GlosyByKomisjaK{$idK}{$kk};
       } else { $r .= "0;"; }
    }
    for $kk ( @k_ ) { 
       if (exists ($GlosyByKomisjaK{$idK}{$kk} )) {
         if ($totalK > 0 ) {
             $p .= sprintf "%.2f;", $GlosyByKomisjaK{$idK}{$kk} / $totalK * 100;
         } else { $p .= sprintf "NA;"; }
       } else {  $p .= "0;";  }
    }

    print "$idK;$totalK;$r$p\n";
}

