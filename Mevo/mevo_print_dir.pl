#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use IO::Uncompress::Gunzip;
use JSON;
##
use utf8;
binmode(STDOUT, ":utf8");
## allowed-area bounding box
my %StationsC ;
my %UIDNN;
my %UIDC;
my %UIDCity;
my %UIDType;
my %UIDNum;

my $MEVOHOME="/home/tomek/Projekty/Mevo";
my $mevoDir=".";
my $stationsFile = "MEVO_STATIONS_ALT.csv";

print STDERR "### Opening $MEVOHOME/MEVO_STATIONS_ALT.csv...\n";
GetOptions('s=s' => \$stationsFile, 'dir=s' => \$mevoDir);

## ### ### ### ### ### ###
my $stationsTotal;

open (STATIONS, "$MEVOHOME/$stationsFile") ||
  die "Problems reading $stationsFile!\n";

for my $s (<STATIONS>) { chomp($s);

  if ( $s =~ m/ele;city/ ) { next } ## pomiń nagłówek

  my ($id, $latlng, $ele, $city) = split /;/, $s;
  my ($lat, $lng) = split / /, $latlng;
  my $latlng8 = sprintf "%.08f %.08f", $lat, $lng;
  $StationsC{"$latlng8"} = "$city";
  $stationsTotal++;
}

print STDERR "### Active stations: $stationsTotal\n";
close(STATIONS);

## ### ### ### ### ### ###
opendir(DIR, $mevoDir) or die "*** Can't open directory $mevoDir: $!.";

my @files;
while ( defined(my $file = readdir(DIR))) {
  unless ($file =~ /.*js.gz$/) {
    print "WARNING (SKIPPED): $file\n"; next }
   print STDERR "### $mevoDir/$file\n";
   push (@files, "$file");
}

closedir(DIR);
print STDERR "### $mevoDir closed!\n";

for my $file (sort @files) {
   print STDERR "### $mevoDir/$file\n";

   my $hrfull = substr ($file, 0, 12); ## date/hr/min/sec

   my $js = IO::Uncompress::Gunzip->new("$mevoDir/$file");
   my $return = readline $js;
   if ( length($return) < 99 ) {
     print STDERR "### SKIPPING: $return (ZERO LENGTH)\n";
     next; }

   $return =~ s/\n/ /mg; ### one line
   ## tylko pierwsza zmienna (plik zawiera dwie)
   $return =~ s/^[^']*'//; $return =~ s/'.*$//;
   my $jsd = decode_json("$return");
   
   foreach my $item ( @$jsd ) {

      my $places = $item->{places};

      foreach my $place ( @$places ) {

        ### bike=0|true (jeżeli zero to stacja)
        my $bike = $place->{bike};
	if ($bike < 1) {$bike='S'} else {$bike='B'}

        ### odwrotność bike
        my $spot = $place->{spot};
        
	## liczba rowerów
	my $bikesNo = $place->{bikes};
	my $bikedbikesNo = $place->{booked_bikes};

        ## lista numerów rowerów
        my $bikeList ='';
        my $bikes = $place->{bike_numbers};
        foreach my $b_ ( @$bikes ) {  $bikeList .= "$b_,";  }

        ## tylko stacje (bez luźnych bików)
        my $lat = sprintf "%.8f", $place->{lat};
        my $lng = sprintf "%.8f", $place->{lng};

        ## uid pozycji (stały dla stacji)
        my $uid = $place->{uid};

        my $coord = "$lat $lng";
        my $city = $place->{city};

        my $number = $place->{number};

	$UIDNN{$uid}++;
	$UIDC{$uid}=$coord;
	$UIDCity{$uid}=$city;
	$UIDType{$uid}=$bike;
	$UIDNum{$uid}=$number;
      }
  }
 }


### ### ### ### ### ### ### ###
for my $u (sort {$UIDNN{$b} <=> $UIDNN{$a}} keys %UIDNN ) {
  my $city_ = $StationsC{$UIDC{$u}} || 'UDF';
  my $nn = $UIDNN{$u};
  print "$u;$UIDNum{$u};$UIDC{$u};$city_;$UIDCity{$u};$UIDType{$u}($nn)\n";
}
