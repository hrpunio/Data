#!/usr/bin/perl
use strict;
use LWP::UserAgent;
use JSON;
use IO::Uncompress::Gunzip;
use Getopt::Long;

## Skonwertuj katalog plików w formacie MEVO na CSV

my $dir = ".";
GetOptions('d=s' => \$dir,);

opendir (DIR, $dir);
my @files = sort { $a cmp $b } readdir(DIR);
my %BikeStations;
my ($bikes_txt, $stations_txt);

while (my $file = shift @files ) {

   unless ($file =~ /.*js.gz$/) { print "WARNING (SKIPPED): $file\n"; next }

   my $FILEOUT = $file;
   my $CSVOUT=$FILEOUT;

   print STDERR "WARNING (READING): $FILEOUT\n";

   my ($csvOut, $jsOut, $gzOut) =  split /\./, $CSVOUT;
   ## 20190423071001.js.gz
   my $js = IO::Uncompress::Gunzip->new("$dir/$FILEOUT");
   my $return = readline $js;
   if ( length($return) < 99 ) { 
     print STDERR "WARNING (SKIPPING): $return (ZERO LENGTH)\n";
     next; }

   $return =~ s/\n/ /mg; ### one line
   ## tylko pierwsza zmienna (plik zawiera dwie)
   $return =~ s/^[^']*'//; $return =~ s/'.*$//;
   my $js = decode_json("$return");

   foreach my $item ( @$js ) {
     my $places = $item->{places};
      foreach my $place ( @$places ) {

        my $bike = clean($place->{bike});
        if ($bike < 1 ) { 
          ## tylko stacje (bez luźnych bików)
          my $uid = $place->{uid};
          my $lat = sprintf "%.8f", $place->{lat};
          my $lng = sprintf "%.8f", $place->{lng};
          my $bikes = $place->{bike_numbers};
          ## ## ##
          my $number = clean($place->{number});
          my $name = clean($place->{name});
          my $city = clean($place->{city});
          my $address = clean($place->{address});
          my $spot = clean($place->{spot});

          $BikeStations{"$lat $lng"} = "$number;";

          foreach my $b_ ( @$bikes ) {
            $bikes_txt .= "${csvOut};$b_;$uid;$lat $lng;$number;$city\n";
          }
        }
      }
  }
} ## //

for $b (keys %BikeStations) {
   ## powinno być 
   $stations_txt .= "$b $BikeStations{$b}\n";
}

## stacje
open (B, ">", "$dir/MEVO_STATIONS_0.csv");
print B $stations_txt;
close (B);

## rowery
open (B, ">", "$dir/MEVO_BIKES_0.csv");
print B $bikes_txt;
close (B);


## ## ## #############################################
sub clean {
  my $s = shift;

  $s =~ s/;/,/g;
  $s =~ s/^[ \t]+|[ \t]+$//g;
  return $s;

}

