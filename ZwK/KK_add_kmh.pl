while (<>) {
  chomp();
  @tmp = split /;/, $_;
  if ($tmp[5] > 0 ) {
   $kmh = 3600 * $tmp[5] / $tmp[7];
    printf "%s;%.2f\n", $_, $kmh;
  } else {
    print "$_;kmh\n";
  }

}
