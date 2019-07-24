#!/usr/bin/perl -w
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

my $stationsZ_txt;

my %NN;
my %totalBikes;
my %totalPlaces;
my %totalZPlaces;
my %totalXPlaces;
my $bikesNo;

#my ($csvOut, $jsOut, $gzOut);

while (my $file = shift @files ) {

   unless ($file =~ /.*js.gz$/) { print "WARNING (SKIPPED): $file\n"; next }
   my $FILEOUT = $file;
   my $CSVOUT=$FILEOUT;

   print STDERR "WARNING (READING): $FILEOUT\n";

   my ($csvOut, $jsOut, $gzOut) =  split /\./, $CSVOUT;
   my $dateTime = substr($csvOut, 0, 10);

   my $js = IO::Uncompress::Gunzip->new("$dir/$FILEOUT");
   my $return = readline $js;

   if ( length($return) < 99 ) { 
     print STDERR "WARNING (SKIPPING): $return (ZERO LENGTH)\n";
     next; 
   }

   $return =~ s/\n/ /mg; ### one line
   ## tylko pierwsza zmienna (plik zawiera dwie)
   $return =~ s/^[^']*'//; $return =~ s/'.*$//;
   $js = decode_json("$return");

   $NN{$dateTime}++;

   foreach my $item ( @$js ) {
     my $places = $item->{places};
      foreach my $place ( @$places ) {

        my $bike = $place->{bike};
        if ($bike < 1 ) { 

          $totalPlaces{$dateTime}++;

          $bikesNo = $place->{bikes};

          $totalBikes{$dateTime} += $bikesNo;

          if ($bikesNo < 1 ) { $totalZPlaces{$dateTime}++; }
          if ($bikesNo == 1 ) { $totalXPlaces{$dateTime}++; }
         
       }
      }
   }
} 

for my $d (sort keys %totalBikes) {
  ### średnie godzinne
  $totalZPlaces{$d} = sprintf "%.1f", $totalZPlaces{$d} / $NN{$d};
  $totalXPlaces{$d} = sprintf "%.1f", $totalXPlaces{$d} / $NN{$d};
  $totalPlaces{$d} = sprintf "%.1f", $totalPlaces{$d} / $NN{$d};
  $totalBikes{$d} = sprintf "%.1f", $totalBikes{$d} / $NN{$d};
 
  my $zxRatio = sprintf "%.1f", $totalXPlaces{$d} / $totalPlaces{$d} * 100;
  my $zzRatio = sprintf "%.1f", $totalZPlaces{$d} / $totalPlaces{$d} * 100;

  $stationsZ_txt .= "$d;$totalBikes{$d};$totalZPlaces{$d};$totalXPlaces{$d};$totalPlaces{$d};$zzRatio;$zxRatio\n";
 }

## stacje
open (B, ">", "$dir/MEVO_ZERO_STATIONS.csv");
print B $stationsZ_txt;
close (B);
