#$start_yr = 1991; ## kadencja nr 1
#$start_yr = 1993; ## kadencja nr 2 
#$start_yr = 1997; ## kadencja nr 3 
#$start_yr = 2001; ## kadencja nr 4 
#$start_yr = 2005; ## kadencja nr 5
#$start_yr = 2007; ## kadencja nr 6
$start_yr = 2011; ## kadencja nr 7 


while (<>) { chomp();
  @tmp = split /;/, $_;
  @data = split /\-/, $tmp[1]; $rok = $data[2]; 

  # imię i nazwisko;data urodzenia;miejsce urodzenia;partia;nr okregu i nazwa okregu;liczba głosów;płeć
  if ($data[0] < 1900 || $data[0] > 1990 ) { print STDERR "*** $_\n"; }

  if ($data[0] =~ /NA/ ) { $wiek ='NA' }
  else { $wiek = $start_yr  - $data[0]; }

  print "$start_yr;$tmp[0];$tmp[1];$wiek;$tmp[3];$tmp[2];$tmp[4];$tmp[5];$tmp[6]\n";
  

}
