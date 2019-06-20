#!/usr/bin/perl
use Geo::Distance;
my $geo = new Geo::Distance;

my $distGrandTotal;
my $distTotal;
## allowed-area bounding box
my %BB = ('lly' => 53.8, 'llx' => 17.4, 'ury' => 55.0, 'urx' => 19.5 );

my $stations = "MEVO_STATIONS.csv";
open (STATIONS, "$stations") || die "Cannot open $stations!\n";

#id;number;name;city;latlng;bikes;bike;spot;bikeSpot;terminal;address
my $stationsTotal;
my %StationsN;
my %StationsC;

for my $s (<STATIONS>) { chomp($s);
  my ($id, $number, $name, $city, $latlng, $bikes, $bike, $spot, $bikeSpot, $terminal, $address) = split /;/, $s;
  if ($number > 9999 && $number <13000 && $bike == 0) {
    my ($lat, $lng) = split / /, $latlng;
    $latlng = sprintf "%.08f %.08f", $lat, $lng;
    print STDERR "$latlng\n";
    $StationsN{"$latlng"} = "$number";
    $StationsC{"$latlng"} = "$city";
    $stationsTotal++;
  }
}

print STDERR "Active stations: $stationsTotal\n";
## ## ##

printf "bike;dist;mean\n";

while (<>) {
  chomp();
  ($bike, $nodes, $track) = split /;/, $_;
  $track =~ s/[ \t]+$//;
  @trkpts =  split / /, $track;

  $distTotal=0;
  $skipBike = 0;

  foreach $t (@trkpts) {
     ($lon, $lat) = split /,/, $t;
     if ($lat < $BB{"lly"} || $lat > $BB{"ury"} || $lon < $BB{"llx"} || $lon > $BB{"urx"} ) {##
        $skipBike = 1;
        print STDERR "SKIPPED (BB) $bike: lat = '$lat' / lon = '$lon' vs $BB{lly} $BB{ury} $BB{llx} $BB{urx}\n";
     } 
     else { 
        ##print STDERR ">$lat $lon $latPrev $lonPrev\n";
        if ($latPrev > 54.0 ) {
           if (exists ($StationsC{"$lat $lon"})) { print STDERR "WARN: City @ $lat $lon!\n"; $City{"$lat $lon"}++; $cC++ } 
           else {  print STDERR "WARN: City NOT FOUND @ $lat $lon!\n"; $noCity{"$lat $lon"}++; $ncC++; }
           $dist = $geo->distance( "meter", $lonPrev, $latPrev => $lon, $lon );
           $distTotal += $dist;
           ##print STDERR "DIST $dist\n";
        }

        $lonPrev =  $lon;
        $latPrev = $lat;
        $cityPrev = $city;
     }

  }

  unless ($skipBike) {
    $mean = $distTotal / 31;
    printf "%s;%.2f;%.2f\n", $bike, $distTotal, $mean;
    $distGrandTotal += $distTotal;
    $validBikes++;
  }
}

$grandMean =  $distGrandTotal / (31 * $validBikes);
@ncTotal =  keys(%noCity);
print STDERR "Średnio: $grandMean ($validBikes)\n";
printf STDERR "city/ncity: %d %d\n", $cC, $ncC;
