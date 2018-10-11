#!/usr/bin/perl
%Komitety = ('PSL' => 1, 'PO' => 5, 'PiS' => 4, 'SLD' => 6);

while (<>) { chomp();
  ($teryt, $okr, $idK, $kto, $glosy, $nrk, $nrL, $komitet) = split /;/, $_;
  $id = "$teryt;$okr";
  $GlosyK{$id}{$komitet} += $glosy;
  $GlosyR{$id} += $glosy;
  $Teryt{$id} = "$id";


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
