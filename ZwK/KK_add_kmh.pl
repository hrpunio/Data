my $distPos=5;
my $timePos=7;
while (<>) {
  chomp();
  @tmp = split /;/, $_;
  if ($tmp[$distPos] > 0 ) {
   $kmh = 3600 * $tmp[$distPos] / $tmp[$timePos];
    printf "%s;%.2f\n", $_, $kmh;
  } else {
    print "$_;kmh\n";
  }

}
