#!/usr/bin/perl -w
# Przetwarza dziennik bieżących zapisów (csv) na zagregowany zapis dzienny (domyślnie)
# lub miesięczny (opcja -unit 'month')
# W przypadku agregacji miesięcznej argumenten -day powinna być nazwa YYYYMM
# plik YYYYMM_log.csv zaś powinien być połączeniem plików dziennych, tj.:
#   cat YYYYMM*_log.csv > YYYYMM_log.csv && mevo_yesterday -day YYYYMM
use strict;
use Getopt::Long;
use Geo::Distance;
my $geo = new Geo::Distance;

## allowed-area bounding box
my %BB = ('lly' => 53.8, 'llx' => 17.4, 'ury' => 55.0, 'urx' => '19.5' );
my %DistByCity=();
my $NonMovBikes; ## list of NMB as string
my $kilometer = 1000;
my $distCalls = 0;
my $freqCalls=120; ## co ile sekund pobiera dane

my $mevoHome="/home/tomek/Projekty/Mevo";
my $YDAY =`date -d "yesterday" '+%Y%m%d'`; chomp($YDAY);
my $stationsFileName = 'MEVO_STATIONS_ALT.csv';
my $mevoDir='.';
my $mevoAggUnit='day'; ## or month

GetOptions('s=s' => \$stationsFileName,'unit=s' => \$mevoAggUnit,
	   'day=s' => \$YDAY, 'dir=s' => \$mevoDir); ### jeżeli nie wczoraj

my $mevoDay="${YDAY}_log.csv"; ## domyślnie wczoraj
my $stationsFile = "$mevoHome/$stationsFileName";

open (STATIONS, "$stationsFile") || die "Cannot open stations @ $stationsFile!\n";

my %StationsC ;
## Stacje najbliżesze Abrahama 28
my %MyStations = ( '10111' => 'Mickiewicza', '10112' => 'Armii Krajowej', );
my %MyStatAvailable;
my %MyStatNN;
my %MyStatAvailableBH;
my %MyStatNNBH;
my %StationsNN;
my $stationsTotal;

for my $s (<STATIONS>) { chomp($s);

  if ( $s =~ m/ele;city/ ) { next } ## pomiń nagłówek

  my ($id, $latlng, $ele, $city) = split /;/, $s;
  my ($lat, $lng) = split / /, $latlng;
  my $latlng8 = sprintf "%.08f %.08f", $lat, $lng;
  $StationsC{"$latlng8"} = "$city";
  $StationsNN{"$city"}++; ## ile stacji w mieście
  $stationsTotal++;
}

print STDERR "### $stationsTotal active stations found in $stationsFile\n";
close(STATIONS);

my $bikesAsRegistered;
my %BikesTracks;
my %BikesPosRecent;
my ($distGrandTotal, $nmvBikes, $bikesNo, $distBC);
my ($mevoZeroStations, $mevoSingleStations, $mevoSampleNN);
my %mevoZStationsByCity;
my %mevoSStationsByCity;

open (MEVO, "$mevoDir/$mevoDay") || die "Cannot open $mevoDir/$mevoDay\n";

for my $file (<MEVO>) {
  chomp($file);

  $mevoSampleNN++; ## ilość pomiarów w dniu

  my ($date, $stationList ) = split /;/, $file;
  my $hr = substr ($date, 8, 2); ## hour

  my @places = split /\+/, $stationList;

  foreach my $place ( @places ) {
    my ($typenumber, $coord, $bikesNN, $bikelist) = split /=/, $place;
    my $bike = substr($typenumber, 0, 1);

    if ($bike eq 'S' ) { ## or 'B'

      ## tylko stacje (luźne bajki są pomijane)
      my ($lat, $lng) = split / /, $coord;

      my @bikes = split /,/, $bikelist;

      ## Stary format S<numer> B0
      ## Nowy format S#<numer> B#<miasto>
      ## w tym skrypcie B tak czy siak jest pomijane (ale nie S)
      my $bikeNextChar = substr($typenumber, 1, 1); ## zmiana formatu jeżeli # nowy format
      my $number;
      if ($bikeNextChar eq '#') { $number = substr($typenumber, 2); }
      else { $number = substr($typenumber, 1); }

      my $mevoCityAbbr ;
      if (defined( $StationsC{"$lat $lng"} )) { $mevoCityAbbr = $StationsC{"$lat $lng"} }
      else { $mevoCityAbbr = 'NA' }

      if ($bikesNN <1) { $mevoZeroStations++ }
      if ($bikesNN <2) { $mevoSingleStations++ }
      ## by city
      if ($bikesNN <1) { $mevoZStationsByCity{"$mevoCityAbbr"}++; }
      if ($bikesNN <2) { $mevoSStationsByCity{"$mevoCityAbbr"}++; }

      if (defined ($MyStations{$number})) { 
	$MyStatAvailable{$number} += $bikesNN; ## liczba bajków na stacji
	$MyStatNN{$number}++; ## liczba obserwacji  
	if ($hr > 4 && $hr < 23 ) {### bez okna 23--5 (6h)
	  $MyStatAvailableBH{$number} += $bikesNN; ## liczba bajków na stacji (godziny biznesowe)
	  $MyStatNNBH{$number}++; ## liczba obserwacji (godziny biznesowe)
	}
      }
      ####
      foreach my $b_ ( @bikes ) { 
	### zapisz bez powtórzeń (ślad):
	### print STDERR "==> $BikesPosRecent{$b_} == $coord\n";
	unless (exists $BikesPosRecent{$b_} ) { $BikesPosRecent{$b_} =''; }
	unless ( $coord eq $BikesPosRecent{$b_} ) {
	  $BikesTracks{$b_} .= "$coord;"; 
	  $BikesPosRecent{$b_} = "$coord";
	}
	##print STDERR "$file : $b_ = $BikesTracks{$b_}\n";
      }
    }
  }
}

close (MEVO);
my $targetPrc = sprintf "%.1f", $mevoSampleNN / (24 * 60 * 60 / $freqCalls) * 100;
print STDERR "### $mevoSampleNN ($targetPrc%) lines from $mevoDir/$mevoDay aggregated\n";

### ### #### ####
for $b (sort keys %BikesTracks) {
    ### bez sort wyniki są różne ??
    my $this_bike_dist = count_dist ( $BikesTracks{$b} );

    ## outside bounds bike returns -1
    if ( $this_bike_dist < 0) { print STDERR "### OBB ###  $b\n"; next; }

    $bikesNo++;
    
    ### jeżeli mniej niż 10m uznajemy że się nie ruszał
    if ($this_bike_dist < 10.0) { $nmvBikes++;
      $NonMovBikes .= "$b=$BikesTracks{$b}+"; ## nr-bike = pozycja
    }
    
    $distGrandTotal += $this_bike_dist; ### łącznie
    $bikesAsRegistered .= sprintf "%s=%.1f ", $b, $this_bike_dist; ### numery/dystanse rowerów wykazanych
}

### ### #### ####
my ($yday_y, $yday_m, $yday_d);
$yday_y = substr($YDAY, 0, 4);
$yday_m = substr($YDAY, 4, 2);
$yday_d = substr($YDAY, 6, 2);

my $my_stations_stats = ''; ## jako jedno pole w formacie stacja=średnia
for my $s_ (sort keys %MyStations ) { 

    if ($MyStatNN{$s_} == 0 ) { $MyStatNN{$s_} = 0.0001;} ## lekkie oszustwo na wypadek zera
    if ($MyStatNNBH{$s_} == 0 ) { $MyStatNNBH{$s_} = 0.0001;  } ## ditto

    $my_stations_stats .= sprintf "%.2f;%.2f;", $MyStatAvailable{$s_}/$MyStatNN{$s_}, 
        $MyStatAvailableBH{$s_}/$MyStatNNBH{$s_}, 
}

$my_stations_stats .= sprintf "%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f", 
  $mevoZeroStations/$mevoSampleNN/$stationsTotal *100,
  $mevoSingleStations/$mevoSampleNN/$stationsTotal *100,
  $mevoZStationsByCity{'GD'}/$mevoSampleNN/$StationsNN{"GD"} * 100,
  $mevoZStationsByCity{'GA'}/$mevoSampleNN/$StationsNN{"GA"} * 100,
  $mevoZStationsByCity{'SP'}/$mevoSampleNN/$StationsNN{"SP"} * 100,
  $mevoZStationsByCity{'TC'}/$mevoSampleNN/$StationsNN{"TC"} * 100,
  $mevoZStationsByCity{'RU'}/$mevoSampleNN/$StationsNN{"RU"} * 100,
  $mevoSStationsByCity{'GD'}/$mevoSampleNN/$StationsNN{"GD"} * 100,
  $mevoSStationsByCity{'GA'}/$mevoSampleNN/$StationsNN{"GA"} * 100,
  $mevoSStationsByCity{'SP'}/$mevoSampleNN/$StationsNN{"SP"} * 100,
  $mevoSStationsByCity{'TC'}/$mevoSampleNN/$StationsNN{"TC"} * 100,
  $mevoSStationsByCity{'RU'}/$mevoSampleNN/$StationsNN{"RU"} * 100;

## Statystyki
## ==========
## day -- dzien
## bikes -- liczba rowerów
## zb -- liczba rowerów nie jeżdżących
## dist.total -- dystans łącznie
## ga;gd;sop;tczew;rumia -- dystans wg;
## s10111;s10111d;s10112;s10112d;
## zstat % bez rowerów
## sstat % z jednym rowerem
## gd0p;ga0p;sop0p;tczew0p;rumia0p;gd1p;ga1p;sop1p;tczew1p;rumia1p -- zstat/sstat wg

my $mevoAggUnitMask; ## day/month aggregate

if ($mevoAggUnit eq 'month') { $mevoAggUnitMask = sprintf "%s-%s", $yday_y, $yday_m; }
else { $mevoAggUnitMask = sprintf "%s-%s-%s", $yday_y, $yday_m, $yday_d; }
#elsif ($mevoAggUnit eq 'day') { $mevoAggUnit = $yday_y, $yday_m, $yday_d }
printf "%s;%i;%i;%.1f;%.1f;%.1f;%.1f;%.1f;%.1f;%s\n", $mevoAggUnitMask,
   $bikesNo, $nmvBikes, $distGrandTotal /$kilometer,
   $DistByCity{'GA'}/$kilometer, $DistByCity{'GD'}/$kilometer, $DistByCity{'SP'}/$kilometer, 
   $DistByCity{'TC'}/$kilometer, $DistByCity{'RU'}/$kilometer, $my_stations_stats;

for my $c_ (keys %DistByCity) { $distBC += $DistByCity{$c_}; }
print STDERR "### DistByCity: $distBC [$distCalls]\n";

### ### #### ####
if ($mevoAggUnit eq 'day') {##
  open (BIKES, ">>MEVO_REGISTERED_BIKES.csv");
  $mevoAggUnitMask = sprintf "%s-%s-%s", $yday_y, $yday_m, $yday_d;
  printf BIKES "%s;%i;%s\n", $mevoAggUnitMask, $bikesNo, $bikesAsRegistered;
  close(BIKES); }

###################
### Liczy dystans przejechany przez 1 rower
###################
sub count_dist {
   my $trace = shift;

   my $distTotal = 0;
   my $dist = 0;

   my $plat = -999;
   my $plng = -999;

   chop($trace); ## remove ; at the end
   ###print STDERR "$trace\n";

   my @tr = split /;/, $trace;
   my $trNo=0;

   foreach my $t ( @tr ) {
       $trNo++;

       ##if ($trNo < 2) { next} ## skip start look for end
       ##
       ##my ($lat, $lng) = split " ", $t;
       ## Błąd powodujący pomijanie 1 odcinka! 4.8.2018 
       my ($lat, $lng) = split " ", $t;
       if ($trNo < 2) {### ### ### 
         $plat = $lat; $plng = $lng; ## !!!
         next;} ## skip strat look for end

       if ($lat < $BB{"lly"} || $lat > $BB{"ury"} || $lng < $BB{"llx"} || $lng > $BB{"urx"} ) { return -1 }

       if ($plat > 54.0 ) {## za pierwszym razem nie jest
           $dist = $geo->distance( "meter", $plng, $plat => $lng, $lat );       
           $distCalls++;

           ##print STDERR "$distCalls;$plng;$plat;$lng;$lat;$dist\n";
           $distTotal += $dist;

           my $ltg1 = "$plat $plng"; 
           my $ltg2 = "$lat $lng"; 

           my $city1 = $StationsC{$ltg1} ;
           my $city2 = $StationsC{$ltg2} ;

           if ($city1 eq $city2) { $DistByCity{$city1} += $dist ; }
           else { 
              $DistByCity{$city1} += $dist/2 ;
              $DistByCity{$city2} += $dist/2 ; 
           }
       }

       $plat = $lat; $plng = $lng;
   }
   return ($distTotal);
} ## // sub count_dist


