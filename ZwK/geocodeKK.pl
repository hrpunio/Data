#!/usb/bin/perl
my $factor = 0.0001;
my $init_shift = 0.00001;

sub gaussian_rand {
    my $mean = shift;
    my $sd = shift;

    my ($u1, $u2);  # uniformly distributed random numbers
    my $w;          # variance, then a weight
    my ($g1, $g2);  # gaussian-distributed numbers

    do {
        $u1 = 2 * rand() - 1;
        $u2 = 2 * rand() - 1;
        $w = $u1*$u1 + $u2*$u2;
    } while ( $w >= 1 );

    $w = sqrt( (-2 * log($w))  / $w );
    $g2 = $u1 * $w;
    $g1 = $u2 * $w;
    # return both if wanted, else just one
    return wantarray ? ($g1, $g2) : $g1;
} ##// gaussian_rand(mean, sd);


while (<>) {

  chomp();

  if (/dystans;oplata/) { print "lp;nazwisko;miejscowosc;firma;dystans;oplata;coords;quality\n" ; next;}

  ($nr,$kto,$skad,$affil,$dist,$paid) = split/;/, $_;
  $skad =~ s/(^ +| +$)//g;
  $Skad{$skad}++;
  unless (exists $GeocodedCache{$skad} ) {
       $r = `geocodeCoder1.pl -a $skad`;   chomp($r);
       ($label_, $lat, $lon, $lname, $lquality) = split / /, $r;
       $GeocodedCache{$skad} =  "$lat $lon;$lquality";
       print $_, ";", "$lat $lon;$lquality\n";
       print STDERR "Geocoded new address $skad!\n";
  } else {
       $coords = $GeocodedCache{$skad};
       print $_, ";", "$coords\n";
       print STDERR "Using cached for $skad!\n";
  }
}

#for $m (sort { $Skad{$a} <=> $Skad{$b} } keys %Skad) {
#   $Skad{$m} = $factor * $Skad{$m};
#   ($lat, lon) = split /:/, $Geocoded{$skad};
#   $rand_lat = gaussian_rand(gaussian_rand(mean, sd);, sd);
#   print $m, "=>", $Skad{$m}, "\n";
#}



