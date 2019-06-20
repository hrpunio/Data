while (<>) {
chomp;
# 20190501000201;98200;10736341;54.41100000 18.57256000;11006;Gdańsk
($d, $b, $uid, $c, $s, $t) = split /;/, $_;
$d = substr($d, 6,6); ## ddhhmm
$t =~ s/Gdańsk/GD/;
$t =~ s/Pruszcz.*/PG/;
$t =~ s/Gdynia/GA/;
$t =~ s/Tczew/TC/;
$t =~ s/Sopot/SP/;
$t =~ s/Rumia/RU/;
$t =~ s/Reda/RE/;
$t =~ s/Puck/PU/;
$t =~ s/Żukowo/ZU/;
$t =~ s/Władysławowo/WW/;
$t =~ s/Kartuzy/KT/;
$t =~ s/Sierakowice/SI/;
$t =~ s/Somonino/SO/;
$t =~ s/Stężyca/ST/;

## Współrzędne mogą być te same 
##unless (exists ($Stacja{$c})) { $Stacja{$c} =":$s:" }
##if  ($Stacja{$c} !~ /:$s:/) {print STDERR "WARN: :$s: and $Stacja{$c} (DOUBLED @ $c)\n";  $Stacja{$c} .= ":$s:"; };

if ($s < 20000) {
  $StacjaId{$s}="$c;$t";
} else { print STDERR "WARN: $s (OUTBOUND/Skipping)\n"};

$base .= "$d;$b;$s\n";

}

### ### ###
for $id (sort keys %StacjaId) { $stacjaIdtxt .= "$id;$StacjaId{$id}\n"; }
#for $coord (sort keys %Stacja) { $stacjaCoords .= "$coord;$Stacja{$coord}\n"; }

print "date;bike;station\n$base";

open (B, ">", "MEVO_STATIONS_IDS.csv");
print B "id;coords;city\n$stacjaIdtxt";
close (B);

#open (B, ">", "MEVO_STATIONS_COORDS.csv");
#print B "coords;stations\n$stacjaCoords";
#close (B);
