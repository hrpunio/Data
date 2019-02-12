while (<>) {
 $lines++;
 $total++;

 if ($lines == 1 ) { next }

 chomp();
 @tmp = split (/\t/, $_);
 $year = $tmp[5]; ## may be null

 if ($year > 2018 ) { $year = '\N' } ## change to unknown

 ##print STDERR ">> $tmp[8]\n";
 @w = split (/,/, $tmp[8]);
 for $w (@w) { 
    $G{$w}++;
    $GL{$w}=1;
    $GG{$year}{$w}++; ## by year
 }
} 

print "Razem wszystkich: $total\n";

for $g (sort keys %G) {  printf "%s %i %.2f\n", $g, $G{$g}, $G{$g}/$total * 100; }

open (IMDB, ">imdb_yr_g.csv");
## header
print IMDB "year;";
for $g (sort keys %GL) {  print IMDB "$g;" }
print IMDB "Total\n";

for $y (sort keys %GG) { 
  
  print IMDB "$y;";
  $tCat=0;
  for $g (sort keys %GL ) { 
   $tCat += $GG{$y}{$g};
   if (exists $GL{$g}) {print IMDB "$GG{$y}{$g};"; $ggTotal{$g} += $GG{$y}{$g}; } 
   else { print IMDB ";"}
   }
  print IMDB "$tCat\n";
}

close(IMDB);

## sprawdzenie
print "==== Sprawdzenie:=====\n";

for $g (sort keys %ggTotal) { 
  print "$g => $ggTotal{$g}\n";
  $tt += $ggTotal{$g};
}

print "Razem: ",  $tt, "\n";

##//title.basics.tsv
