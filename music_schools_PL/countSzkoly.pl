#!/usr/bin/perl
#
open (S, "szkolyMuz20190415.csv");

while (<S>)  { 
  chomp; if ($_ =~ /teryt/) { next };
  ## 1= typ ; 10=teryt (pełny)
  @tmp = split/;/, $_;
  $typS = $tmp[1];
  $terytP = substr($tmp[10], 0, 4) . "000"; 
  ##print STDERR "$terytP\n";
  if ($typS eq "PolicSM") { next }  ### Pomijamy
  $S{$terytP}{$typS}++;
  $T{$typS}=1;
}

close (S);

open (P, "powiaty_ludnosc.csv");
while (<P>)  {
  chomp; if ($_ =~ /teryt/) { next };

  ## 0= teryt; 1= nazwa ; 14=pp
  @tmp = split/;/, $_;
  $terytP = $tmp[0]; 
  $nazwaP = $tmp[1]; 
  $ppP2017 = $tmp[14]; 
  $ppT2017 = $tmp[7]; ## liczba ludności
  $Pnazwa{$terytP}=$nazwaP;
  $PPP{$terytP}=$ppP2017;
  $PPT{$terytP}=$ppT2017;
  $PPTP{$terytP}= sprintf "%.2f", $ppP2017/$ppT2017*100;
}

print "teryt;nazwa;ppp;totalp;ppp.p";
for $t (sort keys %T ) { print ";$t" }
print ";L1;L2;typ\n";


for $p (sort keys %Pnazwa ) {
  print "$p;$Pnazwa{$p};$PPP{$p};$PPT{$p};$PPTP{$p}";
  $L1=0;$L2=0;
  for $t (sort keys %T ) {
      if (exists $S{$p}{$t}) {
         print ";$S{$p}{$t}";

         if ($t eq "SM1" || $t eq "OSM1" ) {$L1 += $S{$p}{$t} } else { $L2 += $S{$p}{$t} }

      } else {
         print ";0"
      }
   }
  print ";$L1;$L2";

  if ($Pnazwa{$p} =~ /^m\./) { $typ = 'm'} else {$typ = 'p'}
  print ";$typ\n";
}
