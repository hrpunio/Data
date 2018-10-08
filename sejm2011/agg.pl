#!/usr/bin/perl
%Komitety = ('PSL' => 5, 'PO' => 7, 'PiS' => 1, 'SLD' => 3);

while (<>) { chomp();
  ($okr, $teryt, $id, $nrk, $komitet, $kandydat, $glosy) = split /;/, $_;
  $GlosyK{$id}{$komitet} += $glosy;
  $GlosyR{$id} += $glosy;
  $Teryt{$id} = "$id;$teryt;$okr";


 }

## ## ## ##
print "terytP;nrk;";

for $k (sort keys %Komitety) { print "$k;" }
for $k (sort keys %Komitety) { print "${k}p;" }

print "totalG\n";

## ## ## ##
for $n (keys %GlosyK) {

   print $Teryt{$n} . ";";

   for $k (sort keys %Komitety) {
      if ($GlosyR{$n} > 0 ) {
      print $GlosyK{$n}{$k} . ";";
      } else { print "NA;"}
   }
   for $k (sort keys %Komitety) {
      if ($GlosyR{$n} > 0 ) {
      printf "%.2f;", $GlosyK{$n}{$k} / $GlosyR{$n} * 100;
      } else { print "NA;"}
   }
   print ";$GlosyR{$n}\n"
}
