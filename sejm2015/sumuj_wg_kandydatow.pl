#!/usr/bin/perl
#
#

open (O, "kody_komisji_s.csv") ;

while (<O>) {
  chomp();
  # okreg;tkod;idkomisji
     @tmp = split (/;/, $_);
     $Okreg{"$tmp[1]"} = $tmp[0]; ## teryt -> okręg
}
  
close (O);

print STDERR "**** wczytałem kody z pliku kody_komisji_s.csv\n";
  

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);

  if (exists ($Okreg{$tmp[6]}) ) {  $okr = $Okreg{$tmp[6]}; }
  else { die "*** Problem with $_ No such district***\n"; }

  $Glosy{"$tmp[3]:$tmp[4]:$tmp[2]"} += $tmp[5];

  unless (exists ( $KandydatOkr{"$tmp[3]:$tmp[4]:$tmp[2]"} )) { 
      $KandydatOkr{"$tmp[3]:$tmp[4]:$tmp[2]"} = $Okreg{$tmp[6]} ;  }

  $OkregGlosy{ $Okreg{$tmp[6]} } += $tmp[5];

  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n";

### ## ### ###

for $w (sort { $Glosy{$b}/$OkregGlosy{ $KandydatOkr{$b}} <=> $Glosy {$a}/$OkregGlosy{ $KandydatOkr{$a}} } keys %Glosy ) { 
   $no++;
   printf "%4d. %s %.2f%% %d %s (%d)\n", $no, $w, 
       $Glosy{$w}/$OkregGlosy{ $KandydatOkr{$w}} * 100, $Glosy{$w}, 
       $KandydatOkr{$w}, $OkregGlosy{ $KandydatOkr{$w}};
}

