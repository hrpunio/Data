#!/usr/bin/perl
# perl extract_candidates.pl ALL.txt > wynik.csv
#

%NumerKomitet = (
  'Lista nr 1 - Komitet Wyborczy Solidarna Polska Zbigniewa Ziobro' => 1,
  'Lista nr 10 - Komitet Wyborczy Demokracja Bezpośrednia' => 10,
  'Lista nr 11 - Komitet Wyborczy Samoobrona' => 11,
  'Lista nr 12 - Komitet Wyborczy Partia Zieloni' => 12,
  'Lista nr 2 - Komitet Wyborczy Wyborców Ruch Narodowy' => 2,
  'Lista nr 3 - Koalicyjny Komitet Wyborczy Sojusz Lewicy Demokratycznej-Unia Pracy' => 3,
  'Lista nr 4 - Komitet Wyborczy Prawo i Sprawiedliwość' => 4,
  'Lista nr 5 - Koalicyjny Komitet Wyborczy Europa Plus Twój Ruch' => 5,
  'Lista nr 6 - Komitet Wyborczy Polska Razem Jarosława Gowina' => 6,
  'Lista nr 7 - Komitet Wyborczy Nowa Prawica – Janusza Korwin-Mikke' => 7,
  'Lista nr 8 - Komitet Wyborczy Platforma Obywatelska RP' => 8,
  'Lista nr 9 - Komitet Wyborczy Polskie Stronnictwo Ludowe' => 9,
);

### ### ### ####
print "okr;tkod;nnrobwd;nrKomitet;numer;kto;glosy\n";

while (<>) {
  $linia++;
  chomp();

  if (/<XXX>/) {
     $okr = $_ ; $okr=czysc($okr);  $okr =~ s/\.html//; next ;
  }
  elsif (/<TKOD>/) { $tkod = $_ ; $tkod = czysc($tkod); }
  elsif (/<NNRO>/) { $nnro = $_ ; $nnro = czysc($nnro); }
  elsif (/<LISTA>/) { 
     $numer_komitet = $_ ; $numer_komitet = czysc($numer_komitet);
     if (exists($NumerKomitet{$numer_komitet}) ) {  $numer_komitet = $NumerKomitet{$numer_komitet}; }
     else { die "NIE MA: $numer_komitet\n";}
  }
  elsif (/<Kto>/) {
     $kto = $_ ; $kto = czysc($kto);
  }
  elsif (/<KtoNr>/) {
     $numer = $_ ; $numer = czysc($numer);
  }
  elsif (/<LgL>/) {
     $glosy = $_ ; $glosy = czysc($glosy);
     ##$komitet = <> ; $komitet = czysc($komitet);
     ##$procenty = <> ; $procenty=czysc($procenty);
     $linia = "$okr;$tkod;$nnro;$numer_komitet;$numer;$kto;$glosy";
     print "$linia\n"; 
  }

}

#####

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

#####
#<tr>
#<td>1</td>
#<td><a href="../../../cpr/sjm-10/pl/a3f6f6b7-831a-440a-92cc-f2dea6d29280.html"> Macierewicz Antoni </a> </td>
#<td>41 871</td>
#<td>16,03%</td>
#<td><div class="barfull"><div class="bar" style="width:16.03% "></div></div></td>
#</tr>

