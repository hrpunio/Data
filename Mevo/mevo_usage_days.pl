#!/usr/bin/perl
#
use Getopt::Long;
use Geo::Distance;
use Date::Calc qw(Week_Number Day_of_Week);
my $geo = new Geo::Distance;

## allowed-area bounding box
my %BB = ('lly' => 53.8, 'llx' => 17.4, 'ury' => 55.0, 'urx' => '19.5' );

my %Miesiac = (1 => 'styczeń', 2 => 'luty', 3 => 'marzec', 4 => 'kwiecień',
        5 => 'maj', 6 => 'czerwiec', 7 => 'lipiec', 8 => 'sierpień',
        9 => 'wrzesień', 10 => 'październik', 11 => 'listopad', 12 => 'grudzień',);
my %DoWName = ( 1 => 'pon', 2 => 'wto', 3=> 'sro', 4 => 'czw', 5 => 'pia', 6 => 'sob', 7 => 'nie' );


my $stationsFile="";
my $mevoBaseFile="";

GetOptions('s=s' => \$stationsFile, 'b=s' => \$mevoBaseFile, 'm=s' => \$yearmonth, );

open (STATIONS, "$stationsFile") || die "Cannot open $stationsFile!\n";
unless (defined($yearmonth)) {die "USAGE: $0 -s STATIONSFILE -b BASEFILE -m YYMM\n"; }

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

## ##
$yearmonth =~ /(\d\d)(\d\d)/; $yy = 2000 + $1; $mm = $2;
open (F, "$mevoBaseFile") || die "Cannot open $mevoBaseFile!\n";

while (<F>) { 
   chomp();
   ## date;bike;station
   ($date, $bike, $station) =  split /;/, $_;
   $date =~ /(\d\d)(\d\d)(\d\d)/; $day = $1; $hr = $2; $min = $3;
   $coords = $StationsLL{$station}; ### Station-coords
   $city = $StationsCity{$station}; ### City-name

   $BikeCoords{"$bike"}++;
 
   unless (defined ($BikeCC{"$bike"}) ) {$BikeCC{"$bike"} = "$coords"; next }

   ($lat, $lon) = split (/ /, $coords);
   ($plat,$plon) = split (/ /, $BikeCC{"$bike"});

   ##if ($lat < $BB{"lly"} || $lat > $BB{"ury"} || $lon < $BB{"llx"} || $lon > $BB{"urx"} ) {$next; }
   if ($plat > 54.0 ) {


     $dist = $geo->distance( "meter", $plon, $plat => $lon, $lat );
     $stagesTotal++;

     ##if ($dist > 20000) { print STDERR "$plon $plat => $lon $lat => $dist => $bike\n"; }

     my $dow = Day_of_Week($yy,$mm,$day);
     ###
     $BikeHr{$hr} += $dist;
     $BikeHrStagesNo{$hr}++;
     ##
     $BikeDow{$dow} += $dist;
     $DowDays{$day} = $dow;
     $GrandTotal += $dist;
   }

   $BikeCC{"$bike"} = "$coords";
}
close (F);

#@DIM = keys %BikeDowDays;
#$DiM = $#DIM +1; ### dni w miesiącu (efektywne)
#
#print "DIM: $DiM\n";
print "### MEVO by Hour\n";
printf "** Equal 1/24 = %.1f%%\n", 1/24 * 100; 
printf "hr ++ Tdist ++ %%dist ++ Sdist\n";
for $h (sort keys %BikeHr ) { printf "%2i %8.1f %8.1f %8.2f\n", $h, 
  $BikeHr{$h}/1000, $BikeHr{$h}/$GrandTotal *100, 
  $BikeHr{$h}/$BikeHrStagesNo{$h}/1000;
 }

## liczba dow w miesiącu:
print "### MEVO by DayOfWeek\n";
for $d (keys %DowDays ) { $DowDaysNum{ $DowDays{$d} }++; }

printf "dow + # + Tdist ++ Mdist +++ %%dist\n";
for $dow (sort keys %DowDaysNum ) { 
  printf "%4s %2i %8.1f %8.1f %8.1f\n", $DoWName{$dow}, $DowDaysNum{$dow}, 
    $BikeDow{$dow}/1000, 
    $BikeDow{$dow}/$DowDaysNum{$dow}/1000,
    $BikeDow{$dow}/$GrandTotal *100;
  $days_total += $DowDaysNum{$dow}; 
}

print "### MEVO (Total):\n";
print "DIM: $days_total ($mm)\n";
printf "%.1f km\n", $GrandTotal/1000;
print "Stages: $stagesTotal\n";

##open (B, ">bikeTmp.tmp");
##for $b (sort keys %BikeCoords) {  print B "$b = $BikeCoords{$b}\n"; }
##close (B);

