#!/usr/bin/perl
#
use Getopt::Long;
$dir=".";
my $stationsFile="";
my $mevoBaseFile="";

GetOptions('s=s' => \$stationsFile, 'b=s' => \$mevoBaseFile, 'm=s' => \$yearmonth, );

open (STATIONS, "$stationsFile") || die "Cannot open $stationsFile!\n";
unless ( defined($yearmonth) ) {die "USAGE: $0 -s STATIONSFILE -b BASEFILE -m YYMM\n"; }

my $stationsTotal;
my %StationsLL;
my %StationsCity;

for my $s (<STATIONS>) { chomp($s);
  ## id;coords;city
  my ($id, $latlng, $city) = split /;/, $s;
    $StationsLL{"$id"} = "$latlng";
    $StationsCity{"$id"} = "$city";
    $stationsTotal++;
}

print STDERR "Active stations: $stationsTotal\n";

## ##
open (F, "$mevoBaseFile") || die "Cannot open $mevoBaseFile!\n";

while (<F>) { 
   chomp();
   ## date;bike;station
   ##600168;13677097;52.28201556 21.01293556;97
   ($date, $bike, $station) =  split /;/, $_;
   $coords = $StationsLL{$station}; ### Station-coords
   $city = $StationsCity{$station}; ### City-name
 
   unless ($BikeCC{"$bike"} eq "$coords" ) { ## CC = Current Coords
       ($lat, $lon) = split / /, $coords;
       $Bike{$bike} .= "$lon,$lat ";
       $BikeNodes{$bike}++;
       $bike_compact_txt .= "$date;$bike;$station\n";
   }

   $BikeCC{"$bike"} = "$coords";

}

close (F);

## ###
## Baza bez duplikatów postojów

open (M, ">MEVO_BIKES_COMPACT_$yearmonth.csv");
print M "date;bike;station\n$bike_compact_txt";
close(M);

## Ślad w formacie KML

$inFile=0; # flaga
$bikeNo=0; #

for $b (sort keys %Bike) {

  ## w paczkach po 500 bo pliki za duże
  if ($bikeNo % 500 == 0 ) {
    ## zakończ poprzedni
    if ($inFile == 1 ) { print T "</Document></kml>\n"; close(T); }

    open (T, ">MEVO_TRKS_${yearmonth}_$bikeNo.kml");
    print T "<?xml version='1.0' encoding='UTF-8'?>\n"
      . "<kml xmlns='http://www.opengis.net/kml/2.2' xmlns:gx='http://www.google.com/kml/ext/2.2'>\n"
      . "<Document><name>${yearmonth}${bikeNo}</name>\n"
      . "<description>tomasz przechlewski, http://pinkaccordions.homelinux.org. Some rights reserved (CC BY 2.0)</description>\n"
      . "<Style id='redLinePoly'><LineStyle><color>ff0000ff</color><width>4</width></LineStyle></Style>\n";

    $inFile=1;
  }
  print T "<Placemark><styleUrl>#redLinePoly</styleUrl><name>Path${b}</name><LineString><tessellate>1</tessellate><coordinates>\n";
  print T "$Bike{$b}\n"; 
  print T "</coordinates></LineString></Placemark>\n";

  $bikeNo++;
}

## zakończ ostatni
if ($inFile == 1 ) { print T "</Document></kml>\n"; close(T); }


##
open (X, ">MEVO_TRKS_$yearmonth.csv");
for $b (sort keys %Bike) { 
print X "$b;$BikeNodes{$b};$Bike{$b}\n"; }
close (X);
##

##open (B, ">MEVO_stations_$yearmonth.csv");
##for $c (sort {$Coords{$a} cmp $Coords{$b} } keys %Coords) { print B "$Coords{$c};$c\n"; }
##close (B);
