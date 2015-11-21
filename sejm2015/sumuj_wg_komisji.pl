#!/usr/bin/perl
#
# Drukuje $max_komisja komisji z najwyższym poparcie dla każdego komitetu
# Dodatkowo drukuje wszystkie komisje w których oddani niska_fq i mniej ważnych głosów
#
my $max_komisja = 25 ; # ile wydrukować
my $low_turnover_log = "komisje_glosy_razem.csv";

### ## ### ###
open (O, "kody_adresy.csv") ;
while (<O>) {
  chomp();
  # idkomisji;tkod;adres 
  @tmp = split (/;/, $_);
  $Adres{"$tmp[0]"} = $tmp[2]; ## idkomisji -> adres
}

close (O);

print STDERR "**** wczytałem kody z pliku kody_komisji_s.csv\n";
################################

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);
  # idkomisji;nrlisty;numer;kto;komitet;glosy;teryt;woj

  $RazemKomisja{"$tmp[0]"} += $tmp[5];
  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n";

### ## ### ###
open (LT, ">$low_turnover_log"); 
print STDERR "**** Low tunover ($niska_fq) written to $low_turnover_log ***\n";
print LT "glosy;komisja\n";

### Ile komisji miało niską frekwencję
for $w ( sort { $RazemKomisja{$a} <=> $RazemKomisja {$b} } keys %RazemKomisja) {
     print LT "$RazemKomisja{$w};$w\n";
}

close (LT);
### ## ### ###
