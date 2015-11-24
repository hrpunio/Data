#!/usr/bin/perl -w
# Pobież podzbiór komisji z $baza_ids, wypisz dla tego podzbioru
# wyniki z kandydaci_obwody_wyniki.csv
$baza_ids='areszty_i_wiezienia.csv';

use Getopt::Long;

GetOptions("baza=s" => \$baza_ids, "addr" => \$AddrYes, );

open (IDS, $baza_ids) || die "Cannot open $baza_ids\n";

while (<IDS>) { chomp();
  @tmp = split /;/, $_;
  $Ids{"$tmp[0]"} = $tmp[1];
  $Adr{"$tmp[0]"} = $tmp[2];
  print STDERR "*** $tmp[0]\n";
  $ids_no++;
}

print STDERR "Pobrano $ids_no identyfikatorów\n";
close (IDS);

## ### ### ### kopiuj z bazy ###

open (BAZA, "kandydaci_obwody_wyniki.csv") || die "Cannot open";

while (<BAZA>) { chomp();
  @tmp = split /;/, $_;
  $id = $tmp[0];

  if (exists ($Ids{"$id"})) {
     if ($AddrYes) {
        print "$_;$Ids{$id};$Adr{$id}\n";
     } else { print "$_;$Ids{$id}\n" }
  }

}

close (BAZA);
