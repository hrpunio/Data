#!/usr/bin/perl
%Komitety = ('PSL' => 10, 'PO' => 8, 'PiS' => 1, 'LiD' => 20, 'LPR' => 3, 'Samoobrona' => 15);

while (<>) { chomp();
  ($teryt, $nro, $nrk, $komitet, $kandydat, $glosy) = split /;/, $_;

  $id = "$teryt:$nro";

  $GlosyK{$id}{$komitet} += $glosy;
  $GlosyR{$id} += $glosy;
  $Teryt{$id} = "$teryt:$nro";


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
