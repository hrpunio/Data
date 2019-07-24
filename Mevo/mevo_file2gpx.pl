#!/usr/bin/perl -w
## Pokaż rower z pliku na mapie
##use strict;
use Getopt::Long;
use IO::Uncompress::Gunzip;
use JSON;
##
use utf8;
binmode(STDOUT, ":utf8");

my $MEVOHOME="/home/tomek/Projekty/Mevo";
my $mevoFile;

GetOptions('in=s' => \$mevoFile);

## ### ### ### ### ### ###
my $hrfull = substr ($mevoFile, 0, 12); ## date/hr/min/sec

my $js = IO::Uncompress::Gunzip->new("$mevoFile");
my $return = readline $js;

$return =~ s/\n/ /mg; ### one line
## tylko pierwsza zmienna (plik zawiera dwie)
$return =~ s/^[^']*'//; $return =~ s/'.*$//;
my $jsd = decode_json("$return");

open(KML, ">$mevoFile.kml");
kmlStart();
   
foreach my $item ( @$jsd ) {

   my $places = $item->{places};

   foreach my $place ( @$places ) {
     my $kmlName;

     ### bike=0|true (jeżeli zero to stacja)
     my $bike = $place->{bike};

     if ($bike < 1) {$bike='S'; } else {$bike='B'; }

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

     if ($bike eq 'S') { $kmlStyle='#SIcon'; 
         $kmlName="S$number";
     } else { $kmlStyle='#BIcon'; chop($bikeList);
       $kmlName="B$bikeList"; }

     print KML "<Placemark><styleUrl>${kmlStyle}</styleUrl><name>$kmlName</name>"
       . "<description>$lng/$lat ($kmlName)</description>"
       . "<Point><coordinates>$lng,$lat</coordinates></Point></Placemark>\n";
     }

}

kmlStop();
close(KML);

## ##
sub kmlStart {

## http://kml4earth.appspot.com/icons.html
print KML "<?xml version='1.0' encoding='UTF-8'?>\n"
 . "<kml xmlns='http://www.opengis.net/kml/2.2' xmlns:gx='http://www.google.com/kml/ext/2.2'>\n"
 . "<Document><name>KML-NAME</name>\n"
 . "<description>tomasz przechlewski, http://pinkaccordions.homelinux.org. Some rights reserved (CC BY 2.0)</description>\n"
 . "<Style id='BIcon'><IconStyle><Icon><href>http://maps.google.com/mapfiles/kml/pal4/icon24.png</href></Icon></IconStyle></Style>\n"
 . "<Style id='SIcon'><IconStyle><Icon><href>http://maps.google.com/mapfiles/kml/pal4/icon60.png</href></Icon></IconStyle></Style>\n";

}

sub kmlStop {
   print KML "</Document></kml>\n";

}

