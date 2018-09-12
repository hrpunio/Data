#!/usr/bin/perl
#
use Getopt::Long;
print STDERR ("*** $0 -c NUM -draft\n");


## measle_white 
## measle_gray
## measle_brown
## --measle_turquoise--
## small_yellow
## measle_purple
## small_blue
## small_red
GetOptions("c=i" => \$Col, "draft" => \$Draft);

my %ScaleNormalT = ( 75 => 'small_blue', 120 => 'small_purple', 160 => 'small_red', );
## LowTurout (Hojarska na przykład)
### https://fusiontables.google.com/DataSource?dsrcid=308519#map:id=3
my %ScaleLowT = ( 
  0  => 'measle_white',
  10 => 'measle_grey', 
  15 => 'measle_brown', 
  20 => 'small_purple', 
  25 => 'small_blue', 
  30 => 'small_red', );
my %Scale = %ScaleLowT;

$hdr = <>; chomp($hdr); print "$hdr;icon\n";

while (<>) { chomp();  @tmp = split /;/, $_; $val = $tmp[$Col];
  my $sb;
  for $scale_break (sort { $a <=> $b } keys %Scale ) {
     if ($val >= $scale_break ) { $sb = $scale_break; next } 
  }

  $icon = $Scale{$sb} ; 

  if ($Draft) {
     print "$icon;$val > $sb ($_)\n"; }
  else { print "$_;$icon\n";  }
}
