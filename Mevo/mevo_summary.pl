#!/usr/bin/perl
## Monthly summary statistics of MEVO
## Typical usage: perl mevo_summary.pl -s MEVO_STATIONS_IDS.csv -b MEVO_TRKS_.csv -m 5
use Geo::Distance;
use Getopt::Long;
my $geo = new Geo::Distance;

my $stationsFile;
my $mevoBaseFile;
my $monthN; ### numer miesiąca
my $kilometer = 1000;

GetOptions('s=s' => \$stationsFile, 'b=s' => \$mevoBaseFile, 'm=i' => \$monthN, );

unless (defined($stationsFile) && defined($mevoBaseFile) && defined($monthN)) {
 print STDERR "USAGE: $0 -s STATIONS -b MEVOBASE -m MONTH\n";
 print STDERR "STATIONS = $stationsFile; BASE = $mevoBaseFile; MONTH = $monthN\n";
 exit;} 

my $distGrandTotal;
my $distTotal;

## allowed-area bounding box
my %BB = ('lly' => 53.8, 'llx' => 17.4, 'ury' => 55.0, 'urx' => '19.5' );

my %DaysInMonth = ('1' => 31, '2' => 28, '3' => 31, '4' => 30, '5' => 31, '6' => 30, 
     '7' => 31, '8' => 31, '9' => 30, '10' => 31, '11' => 30, '12' => 31,);

my $stationsTotal;
my %StationsN;
my %StationsC;

my $DIM = $DaysInMonth{$monthN};

open (STATIONS, "$stationsFile") || die "Cannot open $stationsFile!\n";

for my $s (<STATIONS>) { chomp($s);

  ###print STDERR "$s\n";### ### ###

  #id;latlng;city
  my ($id, $latlng, $city) = split /;/, $s;
  my ($lat, $lng) = split / /, $latlng;
  $latlng = sprintf "%.08f %.08f", $lat, $lng;
  ###print STDERR "### '$latlng'\n";

  $StationsN{"$latlng"} = "$number";
  $StationsC{"$latlng"} = "$city";
  $StationsLL{"$number"} = "$latlng";
  $stationsTotal++;
  $StationsByCity{"$city"}++;
}

print STDERR "Active stations found: $stationsTotal\n";
close(STATIONS);

## ## ##

open (BASE, "$mevoBaseFile") || die "Cannot open $mevoBaseFile!\n";

while (<BASE>) {
  chomp();
  ($bike, $nodes, $track) = split /;/, $_;
  $track =~ s/[ \t]+$//;
  @trkpts =  split / /, $track;

  $distTotal=0;
  $skipBike = 0;
  $lngPrev =  $latPrev = $cityPrev = '';

  foreach $t (@trkpts) {
     ($lng, $lat) = split /,/, $t;
     $latlng = sprintf "%.08f %.08f", $lat, $lng;
     #print STDERR "### '$latlng'\n";

     if ($lat < $BB{"lly"} || $lat > $BB{"ury"} || $lng < $BB{"llx"} || $lng > $BB{"urx"} ) {##
        $skipBike = 1;
        print STDERR "SKIPPED (BB) $bike: lat = '$lat' / lng = '$lng'\n";
     } 
     else { 
        if ($latPrev > 54.0 ) {## first $latPrev is NUL
           unless (exists ($StationsC{"$latlng"})) { print STDERR "*** NOT FOUND CITY *** @ $latlng ($StationsC{$latlng})\n"; }

           $dist = $geo->distance( "meter", $lngPrev, $latPrev => $lng, $lat );
           $stagesTotal++;
           $BikeStages{$bike}++;

           $Visited{"$latlng"}++;
           $VisitedSections{"$latlng $latPrev $lngPrev"}++;

           my $ltg1 = "$latPrev $lngPrev";
           my $ltg2 = "$lat $lng"; 
           my $city1 = $StationsC{$ltg1};
           my $city2 = $StationsC{$ltg2};

           if ($city1 eq $city2) { $DistByCity{$city1} += $dist ; }
	   else {
              ## City2city stages are divided by 2 and equally assigned:
              $DistByCity{$city1} += $dist/2 ;
              $DistByCity{$city2} += $dist/2 ; 
	   }
           
           $distTotal += $dist;
        }

        $lngPrev =  $lng;
        $latPrev = $lat;
        $cityPrev = $city;
     }

  }

  unless ($skipBike) {
    $validBikes++;
    $BikesByDistance{$bike} = $distTotal;
    $distGrandTotal += $distTotal;
  }
}

close (BASE);

### ################################################################################
open (LOG, ">MEVO_MONTHLY_LOG.log");
print STDERR "by Active bikes... (LOG)\n";

print LOG "## MEVO SUMMARY for $monthN -------------------------------------------\n";

### ################################################################################
### ### ### ###
## Najlepsze stacje (drukuje tylko użyte co najmniej 3 razy dziennie (90 w miesiącu)
print STDERR "by Stations... (LOG)\n";
##open (STS, ">MEVO_BEST_STATIONS.log");
open (KML, ">MEVO_BEST_STATIONS.kml");

print KML kml_header("Stations for month $monthN");
print LOG "## STATIONS SUMMARY -------------------------------------------\n";
for my $s (sort {$Visited{$b} <=> $Visited{$a} } keys %Visited) { 
  $currentstation++;
  if ($Visited{$s} < 90) { last } ### tylko stacje użyte co najmniej 3x dziennie 
    printf LOG "| %4i | %6s | %5i | %s |\n", $currentstation, $s, $Visited{$s}, $StationsC{$s}; 
  ## Do KML tylko 999 i więcej:
  if ($Visited{$s} > 999) {
      $visitedNo = $Visited{$s};
      my ($lt0, $lg0) = split / /, $s;
      print KML "<Placemark><name>visited$visitedNo</name>"
        . "<description>visited: $visitedNo ($currentstation)</description>"
        . "<Point><coordinates>$lg0,$lt0</coordinates></Point></Placemark>\n";
  }
}

##close(STS);
print KML kml_tail();
close(KML);

### ################################################################################
## Najlepsze odcinki (drukuje tylko przejechane co najmniej 3 razy dziennie (90 w miesiącu)
print STDERR "by Sections... (LOG)\n";
open (KML, ">MEVO_BEST_SECTIONS.kml");
##open (SCS, ">MEVO_BEST_SECTIONS.log");

print LOG "\n## SECTIONS SUMMARY -------------------------------------------\n";

print KML kml_header("Sections for month $monthN");

for my $s (sort {$VisitedSections{$b} <=> $VisitedSections{$a} } keys %VisitedSections) { 
 $path++;
 if ($VisitedSections{$s} < 60) { last } ### tylko odcinki przejechane co najmniej 2x w miesiącu
 my ($lt1, $lg1, $lt2, $lg2) = split / /, $s;
 my $ltg1 = "$lt1 $lg1"; my $ltg2 = "$lt2 $lg2";

 printf LOG "| %4i | %s | %5i | %s |\n",  $path, $s, $VisitedSections{$s}, "$StationsC{$ltg1}--$StationsC{$ltg2}";

 $kml_p_name = "Section${path}_$VisitedSections{$s}";

 if ($VisitedSections{$s} < 60) { $kmlStyle='#redLinePoly'; }
 elsif ($VisitedSections{$s} < 90) { $kmlStyle='#redLinePolyX'; }
 elsif ($VisitedSections{$s} < 150) { $kmlStyle='#redLinePolyXX'; }
 elsif ($VisitedSections{$s} < 200) { $kmlStyle='#redLinePolyXXX'; }
 elsif ($VisitedSections{$s} < 300) { $kmlStyle='#redLinePolyY'; }
 else { $kmlStyle='#redLinePolyZ' }

 print KML "<Placemark><styleUrl>$kmlStyle</styleUrl><name>$kml_p_name</name><LineString><tessellate>1</tessellate><coordinates>\n";
 print KML "$lg1,$lt1 $lg2,$lt2\n";
 print KML "</coordinates></LineString></Placemark>\n";
 
}

print KML kml_tail();
close(KML);
##close(SCS);

### ################################################################################
# Zestawienie wg miast
print STDERR "by Cities... (LOG)\n";
print LOG "\n## CITY SUMMARY -------------------------------------------\n";
print LOG "+----------------------------------------------+\n"
        . "| City | TotalDist km | %TotalDist | %Stations |\n"
        . "+----------------------------------------------+\n";
for my $city (sort {$DistByCity{$b} <=> $DistByCity{$a} } keys %DistByCity) { 
printf LOG "| %4s | %12.1f | %9.2f%% | %8.2f%% |\n", $city, $DistByCity{$city}/1000, 
    $DistByCity{$city}/$distGrandTotal *100,
    $StationsByCity{$city}/$stationsTotal *100;
}
print LOG "+-###-###--------------------------------------+\n\n";


### ################################################################################
print LOG "##TOTALS -------------------------------------------\n";
$grandMean =  $distGrandTotal / ($validBikes);
printf STDERR "Monthly average/bike (bikesNo):  %.1f km (%d)\n", $grandMean/$kilometer, $validBikes;
printf LOG "Monthly average/bike (bikesNo): %.1f km (%d)\n", $grandMean/$kilometer, $validBikes;
printf STDERR "Daily average/bike (bikesNo):  %.1f km (%d)\n", $grandMean/($kilometer * $DIM), $validBikes;
printf LOG "Daily average/bike (bikesNo): %.1f km (%d)\n", $grandMean/($kilometer * $DIM), $validBikes;
printf LOG "Grand total (%i): %1.f km (%i)", $monthN, $distGrandTotal/$kilometer, $stagesTotal;
printf STDERR "Grand total (%i): %1.f km (%i)", $monthN, $distGrandTotal/$kilometer, $stagesTotal;

### ################################################################################
print LOG "\n## BIKE SUMMARY -------------------------------------------\n";
print LOG "+------------------------------------------------+\n";
print LOG "|  #   |  bike    |   dist   |   mean   | stages |\n";
print LOG "+------------------------------------------------+\n";
for my $b (sort {$BikesByDistance{$b} <=> $BikesByDistance{$a} } keys %BikesByDistance) {
  $cbike++;
  printf LOG "| %4.4i | %8s | %8.1f | %8.2f | %6i |\n", $cbike,  $b, $BikesByDistance{$b}/$kilometer, 
   $BikesByDistance{$b}/$DIM/$kilometer, $BikeStages{$b}; 
} 

print LOG "+-###-###----------------------------------------+\n";


close (LOG);

## ### subroutines

sub kml_header {
  my $name = shift || 'KML-NAME';
return ("<?xml version='1.0' encoding='UTF-8'?>\n"
 . "<kml xmlns='http://www.opengis.net/kml/2.2' xmlns:gx='http://www.google.com/kml/ext/2.2'>\n"
 . "<Document><name>$name</name>\n"
 . "<description>tomasz przechlewski, http://pinkaccordions.homelinux.org. Some rights reserved (CC BY 2.0)</description>\n"
 . "<Style id='redLinePoly'><LineStyle><color>ff6f6fff</color><width>1</width></LineStyle></Style>\n"
 . "<Style id='redLinePolyX'><LineStyle><color>ff6f6fff</color><width>2</width></LineStyle></Style>\n"
 . "<Style id='redLinePolyXX'><LineStyle><color>ff0000ff</color><width>4</width></LineStyle></Style>\n"
 . "<Style id='redLinePolyXXX'><LineStyle><color>ff0000ff</color><width>6</width></LineStyle></Style>\n"
 . "<Style id='redLinePolyY'><LineStyle><color>ff0000ff</color><width>10</width></LineStyle></Style>\n"
 . "<Style id='redLinePolyZ'><LineStyle><color>ff0000ff</color><width>12</width></LineStyle></Style>\n");
}

sub kml_tail { return ("</Document></kml>\n"); }
