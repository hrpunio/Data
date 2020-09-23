#!/usr/bin/perl
$DNF = 999999999999;
while (<>) {
   chomp();
   if(/Czas_netto/) { next}
   ##03:22:17.53 pole = 13

   @tmp = split /;/, $_;
   ($h, $m, $s) = split /:/, $tmp[12];

   if ($h > 0 || $m > 0 || $s > 0 ) {
      $czas = $h * 3600  + $m * 60 + $s ;
   } else {
      $czas = $DNF; ### nie ukończył
   }

   $C{$tmp[0]} = $czas;
   $Z{$tmp[0]} = "$tmp[0];$tmp[1] $tmp[2] $tmp[3]/$tmp[4];$tmp[6];$tmp[8];$tmp[10]/$tmp[11];$tmp[12]";
 
}

print "Lp;Numer;Nazwisko;Imię;Miejscowość;Klub;Kategoria;Dystans;Impreza;Prędkość;Czas/km;Start;Meta;Czas_netto;Czas_sekundy\n";

for $z (sort { $C{$a} cmp $C{$b} } keys %C ) {
    $ordNo++;
    if ($C{$z} == $DNF ) { $C{$z} ='DNF'  }
    $l = $Z{$z} ; $l =~ s/;/\}\{/g;
    print "\\Z{$ordNo}{$l}\n";
}

