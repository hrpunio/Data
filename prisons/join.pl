open O, "prisonstudies.txt" || die "cannot open";

while (<O>) {
  chomp();
  ($c, $pris) = split /;/, $_;
  $C{$c} = $pris;
}

close (O);

open P, "worldpop.txt";

while (<P>) {
  chomp();
  ($c, $pop, $tmp1, $tmp2, $tmp3) = split /;/, $_;
  $CP{$c} = $pop;
}

close (P);

for $c (keys %C ) {
   if (exists $CP{$c}) {
   print "$c;$C{$c};$CP{$c}\n";
   }
   else {
     if ($CP{$c} > 10000000 ) { print STDERR "**** $c\n"; }
   }
}


