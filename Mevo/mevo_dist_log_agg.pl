while (<>) {
  chomp();

  if ($_ =~ /MEVO SUMMARY/) { $skip=1; next}
  if ($_ =~ /BIKE SUMMARY/) { $skip=0; next}
  unless ($skip) {
    @tmp = split " ", $_;
    $bike=$tmp[3];
    $dist=$tmp[5];
    if ($dist =~ /[0-9\.]+/) {
       ##print "$bike $dist\n";
       $Bike{$bike} += $dist;
    }
  }
}

print "nn;idb;dist\n";

for $b (sort {$Bike{$b} <=> $Bike{$a}} keys %Bike) {
       $nn++;
       print "$nn;$b;$Bike{$b}\n";
}
