#!/usr/bin/perl
#
use List::UtilsBy qw(max_by);

open (V, "komisje_komitety7_wyniki_ws2014.csv");
 
my $nrow = 0;
while (<V>) { 
   chomp();
   $nrow++;
   
   ($nrk, $teryt, $nro, $adres, $lwug, $lkw, $lkwzu, $lgnw, $lgw, $freq, $pgnw, 
     $lwug15, $lkw15, $lkwzu15, $lgnw15, $lgw15, $freq15, $pgnw15, $lwug14, 
     $lkw14, $lkwzu14, $lgnw14, $lgw14, $freq14, $pgnw14, $psl, $dbezp, $pis, $po, $rn, $sld, $npjkm ) = split /;/, $_;
     $razem7 = $psl + $dbezp + $pis + $po + $rn + $sld + $npjkm ;
     ##print $lgw14, "\n";
     if ($nrow == 1 ) { print STDERR "*** teryt;nro;psl;dbezp;pis;po;rn;sld;npjkm;razem7;psl;db;pis;po;rn;sld;npjkm\n"; next ; }
     if ($lgw14 > 0) {
       my %big7 = ("PSL" => $psl, "DB" => $dbezp, "PIS" => $pis, "PO" => $po, "RN" => $rn, "SLD" => $sld, "JKM" => $npjkm);
       my $maxBig7 = max_by { $big7{$_} } keys %big7;
       $Votes{"$teryt$nro"} = sprintf "%s;%s;%s;%s;%s;%s;%s;%d;%d;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%s", $psl, $dbezp, $pis, $po, $rn, $sld, $npjkm,
          $razem7, $lgw14, $psl/$lgw14 * 100, $dbezp/$lgw14 * 100, $pis/$lgw14 * 100, $po/$lgw14 * 100, $rn/$lgw14 * 100, $sld/$lgw14 * 100, $npjkm/$lgw14 * 100, 
          $maxBig7;
     } else {
       $Votes{"$teryt$nro"} = sprintf"%s;%s;%s;%s;%s;%s;%s;%s;%s;%d;%d;%s;%s;%s;%s;%s;%s;%s;%s", $teryt, $nro, $psl, $dbezp, $pis, $po, $rn, $sld, $npjkm,
       $razem7, $lgw14, "NA", "NA", "NA", "NA", "NA", "NA", "NA", "NA";
     }
}

close(V);

## ## ##

open (X, "komisje-frekwencja-ws2014-coords-icons.csv");
# teryt;nrk;nro;adres;lwug;lkw;lkwzu;lgnw;lgw;freq;pgnw;idk;coords;icon
$nrow = 0;

while (<X>) { 
  chomp();
  $nrow++;
  ($teryt,$nrk,$nro,$adres,$lwug,$lkw,$lkwzu,$lgnw,$lgw,$freq,$pgnw,$idk,$coords,$icon) = split /;/, $_;
  if ( $nrow > 1 ) {
     print "$_;", $Votes{"$teryt$nro"}, "\n";
  } else { 
   print "teryt;nrk;nro;adres;lwug;lkw;lkwzu;lgnw;lgw;freq;pgnw;idk;coords;icon;psl;dbezp;pis;po;rn;sld;npjkm;razem7;psl;db;pis;po;rn;sld;npjkm;winner\n";
  }
}

close(X);
