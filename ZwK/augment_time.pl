#!/usr/bin/perl
$time_pos=6; ## dla roku 2016/KK
#$time_pos=5; ## dla roku 2017
#$time_pos=7; ## dla roku 2016
#$time_pos=5; ## dla roku 2015

use Getopt::Long;
print STDERR ("*** $0 -c NUM -draft\n");
GetOptions("c=i" => \$time_pos, "draft" => \$Draft);



while (<>) { 
  chomp();
  @tmp = split (/;/, $_);
  $time = $tmp[$time_pos];

  print STDERR "$time\n";
  ($h, $m, $s) = split (/:/, $time);
  $time_in_seconds = $h * 3600 + $m * 60 + $s ;
  if ($time_in_seconds  > 0) {
    print "$_;$time_in_seconds\n";
  } else {
    print STDERR "*** SKIPPED: $_\n";
  }
}
