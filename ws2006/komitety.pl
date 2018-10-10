%LL = ('1' => 'PSL',
 '2' => 'LPR',
 '3' => 'PEiR',
 '4' => 'PiS',
 '5' => 'PO',
 '6' => 'SLD',
 '7' => 'Samoobrona');
while (<>) {
  chomp();
  # idK;name;nrK;nrL
  ($idK, $name, $nrK, $nrL) = split /;/, $_;

  if (exists $LL{"$nrL"}) {$Lname = $LL{"$nrL"}}
  else {$Lname = "$nrL" }

  print "$_;$Lname\n";
}
