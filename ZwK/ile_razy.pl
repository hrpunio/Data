while (<>) { chomp();
   $l = lc($_);
  ($imie, $nazwisko, $adres, $afil, $dist, $czas, $wynik, $kmh, $rok, $impreza) = split /;/, $l;
  $U{"$imie:$nazwisko"}++;
  $A{"$imie:$nazwisko"} .= "$afil";
}

for $u (sort keys %U) {   print "$U{$u} $u ($A{$u})\n" }
