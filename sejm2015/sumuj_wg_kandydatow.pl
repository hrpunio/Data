#!/usr/bin/perl
#

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);

  $Glosy{"$tmp[3]:$tmp[4]:$tmp[2]"} += $tmp[5];
  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n";

### ## ### ###

for $w (sort { $Glosy{$b} <=> $Glosy {$a} } keys %Glosy ) { print "$w = $Glosy{$w}\n"; }

