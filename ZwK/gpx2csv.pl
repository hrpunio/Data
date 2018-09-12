#!/usb/bin/perl
use Geo::Distance;
use XML::DOM;
use Getopt::Long;

my $speedMul = 1;
my $geo = new Geo::Distance;
my $trkpt = 0;
my $total_dist = 0;
my $start = 0;


GetOptions( "gpx=s"  => \$gpxfile, );

print "daytime;ele;speed;dist;stagedist\n";

my $parser = XML::DOM::Parser->new( ErrorContext => 1 );

my $log = $parser->parsefile("$gpxfile");
my $lon ; my $lat ;
my $total_dist ;

for $t ( $log->getElementsByTagName('trkseg') ) {
  my @TrackLon=(); my @TrackLat=(); my @TrackEle=();
  my @TrackTime=(); my @TrackElapsedTime=();
  
  for $f ( $t->getElementsByTagName('trkpt') ) { 
    $trkpt_current_no++;
    my $gpx_ele = -1000; # dla pewności na depresji
    
    my $gpx_lat = $f->getAttributeNode ("lat")->getValue() ;
    my $gpx_lon = $f->getAttributeNode ("lon")->getValue() ;

    ## Czas
    my @times = $f->getElementsByTagName("time");
    if (@times > 0) {
      $gpx_time = '';
      my @tmp__ = $times[0]->getChildNodes;
      foreach my $node ( @tmp__ ) { $gpx_time .= $node->getNodeValue }

      print STDERR ">>>$gpx_time\n";

      if ( $gpx_time eq '' ) { $gpx_time ='NA'; push @TrackTime, $gpx_time; }
      else {
	$daytime = $time ;
	$daytime =~ s/<[^<>]+>//g;
	##2018-08-18T15:14:31Z
	($day, $time) = split /T/, $daytime;
	($h, $m, $s) = split /:/, $time;
	$time_second_from_midnight = $h * 60 * 60  + $m * 60 + $s ;
	push @TrackTime, $gpx_time;
	push @TrackElapsedTime, $time_second_from_midnight;
      }
    } else {  push (@TrackTime, 'NA') }

    ## Wysokość
    my @eles = $f->getElementsByTagName("ele");
    if (@eles > 0) {
      $gpx_ele = '';
      my @tmp__ = $eles[0]->getChildNodes;
      foreach my $node ( @tmp__ ) { $gpx_ele .= $node->getNodeValue }
    }
    push @TrackLon, $gpx_lon;
    push @TrackLat, $gpx_lat;
    push @TrackEle, $gpx_ele;

    $trkpt++;
  }
  ## first element
  print STDERR "$#TrackLon punktów...\n";

  printf "%s;%.1f;%.1f;%.1f\n", $TrackTime[0], $TrackEle[0], 0, 0;
  
  if ( $#TrackLon > 0 ) {## są dwa punkty
    for($i =1; $i <= $#TrackLon; $i++) {
      ##printf STDERR "%f %f %f %f\n", $TrackLon[$i - 1], $TrackLat[$i -1 ], $TrackLon[$i], $TrackLat[$i];
      $dist = $geo->distance( "meter", $TrackLon[$i - 1], $TrackLat[$i -1 ] => $TrackLon[$i], $TrackLat[$i] );
      $total_dist += $dist ;

      unless ($TrackTime[$i] eq 'NA' ) {
        $time_diff = $TrackElapsedTime[$i] - $TrackElapsedTime[$i -1];
        $Speed = ($dist / $time_diff)  * 60 * 60 / 1000  * $speedMul;
      } else { $Speed = 'NA'; }

      ### wydrukuj
      printf "%s;%.1f;%.1f;%.1f;%.1f\n", $TrackTime[$i], $TrackEle[$i], $Speed, $total_dist,$dist;
    }
  }
 ### Drukuj segment

} ## // trk
##
##
printf STDERR "Total distance: %d (%d)", $total_dist, $trkpt;
