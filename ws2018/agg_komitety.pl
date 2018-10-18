#!/usr/bin/perl
#
while (<>) {
  ($teryt, $idk, $uprawnieni, $kartyOtrzymane, $kartyNiewydane, $kartyWydane, $kartyNiewazne, 
   $kartyWazne, $glosy, $glosyNiewazne, $glosyLK, $PSL, $DB, $PiS, $PO, $RN, $SLDLR, $NPKM, $PSLp, 
   $DBp, $PiSp, $POp, $RNp, $SLDLRp, $NPKMp) = split /;/, $_ ;

   $Uprawnieni{$teryt} += $uprawnieni;
   $Glosy{$teryt} +=  $glosy;
   $GlosyNW{$teryt} += $glosyNiewazne;
   $GlosyLK{$teryt} +=  $glosyLK; ## glosy na komitety z listy krajowej
   $GlosyPSL{$teryt} +=  $PSL;
   $GlosyPiS{$teryt} +=  $PiS;
   $GlosySLD{$teryt} +=  $SLDLR;
   $GlosyPO{$teryt} +=  $PO;
}

print "teryt;uprawnieni;glosy;glosyNW;glosyLK;PSL;PiS;SLD;PO;ognw;PSLp;PiSp;SLDp;POp\n";

for $t (keys %Uprawnieni) {
   $gr = $Glosy{$t}; 
   if ($gr > 0) {
      $ognw = $GlosyNW{$t} / ($gr + $GlosyNW{$t} ) * 100;

      printf "%s;%i;%i;%i;%i;%i;%i;%i;%i;%.2f000;%.2f;%.2f;%.2f;%.2f\n", $t,
        $Uprawnieni{$t}, $gr, $GlosyNW{$t}, $GlosyLK{$t}, $GlosyPSL{$t},
        $GlosyPiS{$t}, $GlosySLD{$t}, $GlosyPO{$t},
        $ognw, $GlosyPSL{$t}/$gr * 100, $GlosyPiS{$t}/$gr * 100, 
        $GlosySLD{$t}/$gr * 100, $GlosyPO{$t}/$gr * 100; }
   else {
      printf "%s;%i;%i;%i;%i;%i;%i;%i;%i;%s;%s;%s;%s;%s\n", $t,
        $Uprawnieni{$t}, $gr, $GlosyNW{$t}, $GlosyLK{$t}, $GlosyPSL{$t},
        $GlosyPiS{$t}, $GlosySLD{$t}, $GlosyPO{$t},
        'NA', 'NA', 'NA', 'NA', 'NA'; }

}
