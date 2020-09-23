#!/usr/bin/perl
# zamień HTML na csv
while (<>) {
  chomp();
  if (/<tr class="even">/) { $scan =1}
  if (/https:\/\/elektronicznezapisy.pl/) { $scan = 0; print $l . "\n"; $l=""; }
  if ($scan > 0 && $_ =~ /<td>/) {
     $_ =~ s/\&nbsp;/ /g;
     $_ =~ s/\&amp;/&/g;
     ####
     $_ =~ s/^[ \t]+|[ \t]+$//g;
     $_ =~ s/;/,/g;
     $_ =~ s/<\/?td>//g;
     $l .= ";" . $_;
   }
}
