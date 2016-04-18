#!/usr/bin/perl
#
#
%Numer2Komitet = (
   1 => 'Ziobro', 10 => 'DemBezp', 11 => 'Samoobrona', 12 => 'Zieloni', 2 => 'RuchNarodowy',
   3 => 'SLDUP', 4 => 'PiS', 5 => 'Europa+', 6 => 'Gowin', 7 => 'Korwin', 8 => 'PO', 9 => 'PSL', );

open (O, "pe_komisje.csv") ;

while (<O>) {
  chomp();
  # nrokregu;teryt;nrobwodu
  @tmp = split (/;/, $_);
  $Okreg{"$tmp[1]"} = $tmp[0]; ## teryt -> okręg
}
  
close (O);

print STDERR "**** wczytałem kody z pliku pe_komisje.csv\n";
  

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);

  if (exists ($Okreg{$tmp[1]}) ) {  $okr = $Okreg{$tmp[1]}; }
  else { die "*** Problem with $_ No such district***\n"; }

  $kkomitet= $Numer2Komitet{$tmp[3]};

  ## $Glosy{kto:nrKomitet:nrNaLiście}
  $Glosy{"$tmp[5]:$kkomitet:$tmp[4]"} += $tmp[6];


  unless (exists ( $KandydatOkr{"$tmp[5]:$kkomitet:$tmp[4]"} )) { 
      $KandydatOkr{"$tmp[5]:$kkomitet:$tmp[4]"} = $Okreg{$tmp[1]} ;  }

  $OkregGlosy{ $Okreg{$tmp[1]} } += $tmp[6];

  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n OK!\n";

### ## ### ###
print "Nr. Kto:Komitet:Nr UdziałOkr GłosyRazem (OkrNr=GłosyRazemOkr)\n";
print "-------------------------------------------------------------\n";

for $w (sort { $Glosy{$b}/$OkregGlosy{ $KandydatOkr{$b}} <=> $Glosy {$a}/$OkregGlosy{ $KandydatOkr{$a}} } keys %Glosy ) { 
##for $w (sort { $Glosy{$b} <=> $Glosy {$a} } keys %Glosy ) { 
   $no++;
   printf "%4d. %s %.2f%% %d (%s=%d)\n", $no, $w, 
       $Glosy{$w}/$OkregGlosy{ $KandydatOkr{$w}} * 100, $Glosy{$w}, 
       $KandydatOkr{$w}, $OkregGlosy{ $KandydatOkr{$w}};
}

