#!/usb/bin/perl
use Math::Complex;
use Math::Trig;
my $factor = 0.00001;
my $init_shift = 0.00001;

$pi = 4*atan2(1,1);

while (<>) {
  chomp();
  $lineNo++;
  if (/dystans;oplata/) { next;}

  ## "lp;nazwisko;miejscowosc;firma;dystans;oplata;coords;quality ##
  ($nr,$kto,$skad,$affil,$dist,$paid,$coords,$quality) = split/;/, $_;
  $Skad{$skad}++;
  $Coords{$skad}=$coords;
  push (@Enlisted, $_);
}

print "lp;nazwisko;miejscowosc;firma;dystans;oplata;coords;quality;jcoords\n";

for $l ( @Enlisted ) {

  ($nr,$kto,$skad,$affil,$dist,$paid,$coords,$quality) = split/;/, $l;

   $sd = sqrt($factor * $Skad{$skad});

   print STDERR "$skad => $sd\n";

   ($lat, $lon) = split (/ /, $coords);

   #$rand_lat = $lat + rand($sd);
   #$rand_lon = $lon + rand($sd);
   
   $r = $sd * sqrt(rand()); $theta = rand() * 2 * $pi;

   $rand_lat = $lat + $r * cos($theta);
   $rand_lon = $lon + $r * sin($theta);

   print "$l;$rand_lat $rand_lon\n";
}



for $s (sort {$Skad{$a} <=> $Skad{$b}} keys %Skad ) { print STDERR "$s @ $Skad{$s}\n" ;}
