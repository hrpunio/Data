#!/usr/bin/perl
# Wypisanie wyników dla każdej komisji/kandydata:
#
# $okr;$numer;$kto;$numer_komitet;$glosy
#
# perl ex0.pl ALL11.txt > wynik.csv
#

print "okr;numer;kto;komitet;glosy\n";

while (<>) {
 $liniaTotal++;
 chomp();

 ###if (/Lista nr ([0-9]+)/) { $lista = $1 ;   next   }
 if (/<XXX>/) { $okr = $_ ; $okr=czysc($okr);  $okr =~ s/\.html//; next ;}
 elsif (/<tr[^<>]*>/) { 
    $liniaK = ''; $liniaKN=0;
 }
 elsif (/<td[^<>]*>/) { $liniaK .= $_ . "@" ; $liniaKN++ }
 elsif (/<\/tr>/) {
   ## analizuję linię
   if ($liniaKN == 4 ) { #print STDERR "$okr;$liniaK\n" 
      ($numer, $kto, $numer_komitet, $glosy) = split /@/, $liniaK;
      $numer = czysc($numer);
      $kto = czysc($kto);
      $numer_komitet = czysc($numer_komitet);
      $glosy = czysc($glosy);
      print "$okr;$numer;$kto;$numer_komitet;$glosy\n";
      
   } else { 
      ##print STDERR "**** $liniaKN => $liniaK\n"; 
   }
 }
}

###

sub czysc {
  my $a = shift;

  $a =~ s/^[ \t]+//;  $a =~ s/[ \t]+$//;  $a =~ s/[ \t]+/ /g;
  ## usuń różne smieci:
  $a =~ s/\&quot;/"/g; ## usuń bo bruździ
  $a =~ s/;/|/g; ## zamień na wszelki wypadek bo bruździ

  $a =~ s/<[^<>]+>//g;
  $a =~ s/\n//g;
  return $a;
}

###
