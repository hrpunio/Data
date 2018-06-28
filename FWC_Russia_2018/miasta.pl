while (<>) {
   chomp();
   @tmp = split /;/, $_;
   $m = $tmp[7]; $m =~ s/,.*$//;
   $M{$m}++
}

for $m (sort {$M{$b} <=> $M{$a} } keys %M ) {
   print "$m = $M{$m}\n";
   $L{$M{$m}} .= "$m;"
}

print "===========\n";

## ile gdzie
for $l (sort {$a <=> $b } keys %L ) {
   my @N = $L{$l} =~ /;/g;
   my $N = scalar @N;
   #print "$l = $L{$l} ($N)\n";
   print "$l = $N\n";
}
