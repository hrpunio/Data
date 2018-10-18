#!/usr/bin/perl
print "urzad;razem;kobietyP;wiek;PSL;PiS;PO;SLD;PP;NP;teryt;xteryt;name;areaH;popThs;popKm;rankP;type;bb;center\n";

while (<>) { chomp();
  ($urzad, $teryt, $razem, $razemKobiety, $wiek, $PSL, $PiS, $PO, $SLD, $PP, $NP, 
    $terytbis, $xteryt, $name, $areaH, $areaKm, $popThs, $popKm, $rankA, $rankP, $type, $bb, $center) = split (/;/, $_);

  if ($razem > 0 ) {
  printf "%s;%d;%.2f;%.2f;%d;%d;%d;%d;%d;%d;%s;%s;%s;%.1f;%.1f;%1.f;%d;%s;%s;%s\n", $urzad, $razem, $razemKobiety/$razem*100, 
    $wiek, $PSL, $PiS, $PO, $SLD, $PP, $NP, 
    $teryt, $xteryt, $name, $areaH, $popThs, $popKm, $rankP, $type, $bb, $center;
 } else {
   print STDERR "$_\n"; ## Nagłówek?
 }
}
