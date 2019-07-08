#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Geo::Distance;
use IO::Uncompress::Gunzip;
use JSON;
##
my $geo = new Geo::Distance;
##
## allowed-area bounding box
my %BB = ('lly' => 53.8, 'llx' => 17.4, 'ury' => 55.0, 'urx' => '19.5' );
my %DistByCity=();
my $kilometer = 1000;
my $distCalls = 0;

my $mevoDir=".";
my $YDAY =`date -d "yesterday" '+%Y%m%d'`; chomp($YDAY);
my $stationsFile = 'MEVO_STATIONS_ALT.csv';

GetOptions('s=s' => \$stationsFile, 'day=s' => \$YDAY, 'dir=s' => \$mevoDir); ### jeżeli nie wczoraj

##print "$YDAY\n";
### ### ### ###
#

open (STATIONS, "$stationsFile") || die "Cannot open stations @ $stationsFile!\n";

my %StationsC ;
my $stationsTotal;

for my $s (<STATIONS>) { chomp($s);

  if ( $s =~ m/ele;city/ ) { next } ## pomiń nagłówek

  my ($id, $latlng, $ele, $city) = split /;/, $s;
  my ($lat, $lng) = split / /, $latlng;
  my $latlng8 = sprintf "%.08f %.08f", $lat, $lng;
  $StationsC{"$latlng8"} = "$city";
  $stationsTotal++;
}

print STDERR "Active stations: $stationsTotal\n";
close(STATIONS);


opendir(DIR, $mevoDir) or die "*** Can't open directory $mevoDir: $!.";

my @files;
while ( defined(my $file = readdir(DIR))) {
    if ($file =~ /^\./) { next ; } 
    if ($file =~ /$YDAY/ && $file =~ /\.js\.gz/) { 
       push (@files, "$file");
    }
}

closedir(DIR);

my %BikesTracks;
my %BikesPosRecent;
my ($distGrandTotal, $nmvBikes, $bikesNo, $distBC);

for my $file (sort @files) {
   print STDERR ">>> $mevoDir/$file\n";

   my $js = IO::Uncompress::Gunzip->new("$mevoDir/$file");
   my $return = readline $js;
   if ( length($return) < 99 ) { 
     print STDERR "WARNING (SKIPPING): $return (ZERO LENGTH)\n";
     next; }

   $return =~ s/\n/ /mg; ### one line
   ## tylko pierwsza zmienna (plik zawiera dwie)
   $return =~ s/^[^']*'//; $return =~ s/'.*$//;
   my $jsd = decode_json("$return");
 
   foreach my $item ( @$jsd ) {
      my $places = $item->{places};

      foreach my $place ( @$places ) {

        my $bike = clean($place->{bike}); ### flaga jeżeli 1 bike (a nie stacja)

        if ($bike < 1 ) { 
           ## tylko stacje (bez luźnych bików)
           my $lat = sprintf "%.8f", $place->{lat};
           my $lng = sprintf "%.8f", $place->{lng};
           my $coord = "$lat $lng";

           my $bikes = $place->{bike_numbers};
           my $number = clean($place->{number});
           ##my $city = clean($place->{city});
           foreach my $b_ ( @$bikes ) { 
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
}
### ### #### ####
### ### #### ####
for $b (keys %BikesTracks) {
    ### bez sort wyniki są różne ??
    my $this_bike_dist = count_dist ( $BikesTracks{$b} );

    if ( $this_bike_dist < 0) {## outside bounds bike
        print STDERR "OBB :: $this_bike_dist :: $b\n";
        next; 
    }

    $bikesNo++;

    if ($this_bike_dist < 10.0) {### jeżeli mniej niż 10m uznajemy że się nie ruszał
       ##print "$b;$this_bike_dist;00\n";
       $nmvBikes++;
    } else {
       ##print "$b;$this_bike_dist;11\n";
    }
    $distGrandTotal += $this_bike_dist; ### łącznie
}

my ($yday_y, $yday_m, $yday_d);
$yday_y = substr($YDAY, 0, 4);
$yday_m = substr($YDAY, 4, 2);
$yday_d = substr($YDAY, 6, 2);

printf "%s-%s-%s;%i;%i;%.1f;%.1f;%.1f;%.1f;%.1f;%.1f\n", $yday_y, $yday_m, $yday_d, 
   $bikesNo, $nmvBikes, $distGrandTotal /$kilometer,
   $DistByCity{'GA'}/$kilometer, $DistByCity{'GD'}/$kilometer, $DistByCity{'SP'}/$kilometer, 
   $DistByCity{'TC'}/$kilometer, $DistByCity{'RU'}/$kilometer;

for my $c_ (keys %DistByCity) { $distBC += $DistByCity{$c_}; }
print STDERR "### DistByCity: $distBC [$distCalls]\n";

#for my $b_ (sort keys %BikesTracks) {
#   print "$b_ ## $BikesTracks{$b_}\n";
#}
#
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

       if ($trNo < 2) { next} ## skip strat look for end

       my ($lat, $lng) = split " ", $t;

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

           ##print STDERR ">> $ltg1 :: $StationsC{$ltg1}\n";

           if ($city1 eq $city2) { $DistByCity{$city1} += $dist ; }
           else { 
              $DistByCity{$city1} += $dist/2 ;
              $DistByCity{$city2} += $dist/2 ; 
           }
       }

       $plat = $lat; 
       $plng = $lng;
   }
   return ($distTotal);
}

### ### ###
sub clean {
  my $s = shift;

  $s =~ s/;/,/g;
  $s =~ s/^[ \t]+|[ \t]+$//g;
  return $s;

}

