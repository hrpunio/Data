#!/usr/bin/perl
$file = `basename $0 .pl`; chomp($file);
print STDERR "** reading $file.csv\n";

open (K, "$file.csv") || die "Cannot open $file.csv";

while (<K>) {
  chomp($_);
  $_ =~ s/"//g;
  ($Teryt, $Gmina, $Powiat, $Urzad, $Imiona, $Nazwisko, $Komitet, $Sygnatura, 
    $Typ, $Wyksztalcenie, $Wiek, $Plec, $TerytMz, $GminaMz, $Miejscowosc, $Czlonek, $Poparcie) = split /;/, $_;
  
  $NK{"$Urzad:$Teryt"}++;
  $Kandydaci{"$Urzad:$Teryt"} .= "$Nazwisko:$Imiona;";
  $Name{"$Urzad:$Teryt"} = "$Miejscowosc/$Powiat";
  if ($Plec eq 'K') { $SexK{"$Urzad:$Teryt"}++; }
  $NKWiekT{"$Urzad:$Teryt"} += $Wiek;
  if ($Typ =~ /partii politycznej|Koalicyjny/ ) {
     $Typ = 'PP';
     if ($Komitet =~ /SPRAWIEDLIWO/ ) {$Typ = 'PiS'}
     if ($Komitet =~ /LUDOWE/ ) {$Typ = 'PSL'}
     if ($Komitet =~ /PLATFORMA\.NOWOCZESNA/ ) {$Typ = 'PO'}
     if ($Komitet =~ /LEWICA RAZEM/ ) {$Typ = 'SLD'}
     $NKExtra{"$Urzad:$Teryt"}{$Typ}++; 
  }
  else {  $NKExtra{"$Urzad:$Teryt"}{"NP"}++}
}

close (K);

print "urzad;teryt;razem;razemKobiety;wiek;PSL;PiS;PO;SLD;PP;NP\n";

## liczba kandydatów:
for $k (sort { $NK{$b} <=> $NK{$a} }keys %NK){
   unless (exists $SexK{$k} ) { $SexK{$k}=0 }
   $wieksr = sprintf "%.2f", $NKWiekT{$k} / $NK{$k};

   for $x ('PSL', 'PiS', 'PO', 'SLD', 'PP', 'NP') {
       unless (exists $NKExtra{$k}{$x}) { $NKExtra{$k}{$x} = 0   }
   }

   $pp = sprintf "%d;%d;%d;%d;%d;%d", $NKExtra{$k}{"PSL"}, $NKExtra{$k}{"PiS"}, $NKExtra{$k}{"PO"}, 
         $NKExtra{$k}{"SLD"}, $NKExtra{$k}{"PP"}, $NKExtra{$k}{"NP"};

   print "$k;$NK{$k};$SexK{$k};$wieksr;$pp\n";

   $SumStats{$NK{$k}}++;
   $Total++;
}

#for $k (sort { $SumStats{$b} <=> $SumStats{$a} }keys %SumStats){
#   printf "%d %d %.2f%\n", $k, $SumStats{$k}, $SumStats{$k}/$Total * 100; }
#
#print "Razem: ", $Total;
