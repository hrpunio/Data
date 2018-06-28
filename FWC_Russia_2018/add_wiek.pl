while (<>) {
  chomp();
  @tmp = split /;/, $_;
  $born = $tmp[3];
  $cln = $tmp[6];

  ($d, $m, $y) = split /\./, $born;
  @namecity = split " ", $cln;
  $w = 2018 - $y;
  if ($cln =~ /City|United|Saint-Germain/ ) { $nn = $namecity[0]; }
  else { $nn = $namecity[$#namecity]; }

  print "$_;$nn;$w\n";


}
