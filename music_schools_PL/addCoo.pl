while (<>) { chomp();
  @tmp = split /;/, $_;

  if ($tmp[6] eq 'kodPocztowy') { print "$_;latLon\n"; next }

  ###print "$tmp[6]\n";
  $coo = `geocodeCoderOSM.pl -pc $tmp[6]`;
  chomp($coo);
  ($lat, $lon) = split /,/, $coo;
  if ($lat == 0 && $lon == 0) {
     $coo = `geocodeCoderOSM.pl -a "$tmp[3] $tmp[4], $tmp[7]"`;
     chomp($coo);
  }
  print STDERR "### $coo\n";
  print "$_;$coo\n";
  ##exit;
}
