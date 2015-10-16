while (<>) { chomp();
  @tmp = split /;/, $_;

  @nazwa = split " ", $tmp[0];

  if ($nazwa[0] =~ /a$/ ) { $plec='F';  }
  else { $plec ='M' }

  print "$_;$plec\n";

}
