while (<>) {
 chomp();
 # WOJ;POW;GMI;RODZ;NAZWA;NAZWA_DOD;STAN_NA
 ($woj, $powiat, $gmina, $rodzaj, $n, $nd, $s) = split /;/, $_;
  if ($gmina != "") {
    $R{"$woj$powiat$gmina"} .= "$rodzaj/";
    $N{"$woj$powiat$gmina"} = "$n";
  }
}

for $g (sort keys %R) {
  if ($R{$g} eq "1/" ) { $typ="U" }  else { $typ="R"}

  print "$g;$typ;$N{$g}\n";
}
