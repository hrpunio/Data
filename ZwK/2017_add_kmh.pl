while (<>) {
  chomp();
  @tmp = split /;/, $_;
  if ($tmp[4] > 0 ) {
   $kmh = 3600 * $tmp[4] / $tmp[6];
    printf "%s;%.2f\n", $_, $kmh;
  } else {
    print "$_;kmh\n";
  }

}
