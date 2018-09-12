$plik1= "rglosowan_7.csv";
$plik2= "interpolacje_7.csv";
$plik3= "wystapienia_7.csv";

open (OD, $plik1) || die "1!\n";
open (OE, $plik2) || die "2!\n";
open (OF, $plik3) || die "3!\n";

while (<OD>) { chomp(); @tmp = split /;/, $_; $D{"$tmp[1]$tmp[2]"} = $_; $K{"$tmp[1]$tmp[2]"} = $tmp[1]; } 
while (<OE>) { chomp(); @tmp = split /;/, $_; $E{"$tmp[1]$tmp[2]"} = $_; $K{"$tmp[1]$tmp[2]"} = $tmp[1]; }
while (<OF>) { chomp(); @tmp = split /;/, $_; $F{"$tmp[1]$tmp[2]"} = $_; $K{"$tmp[1]$tmp[2]"} = $tmp[1]; }


print "kto;klub;l.glos;p.glos;l.interp;l.interp.nb;l.wystap;uwagi\n";

for $i (sort keys %K) {   

  unless (exists $D{$i}) { $D{$i} = "0;0;0;0;0;0;"}
  unless (exists $E{$i}) { $E{$i} = "0;0;0;0;0;0;"}
  unless (exists $F{$i}) { $F{$i} = "0;0;0;0;0;"}

  $l =  "$D{$i}$E{$i}$F{$i}\n"; 
  @tmp = split /;/, $l;
  ##print $l;
  if ($tmp[10] eq '') { $tmp[10] = "0"; }
  print "$tmp[1];$tmp[2];$tmp[3];$tmp[4];$tmp[9];$tmp[10];$tmp[15];$tmp[5]\n"
}

## 0 ;  1              ; 2;3   ;4    ; 5                  ; 6  ; 7               ; 8; 9;        10          ; 11 ; 12              ;13;14;15;16;
#359.;Achinger Elżbieta;PO;5509;99.01;ślubowała 11-07-2012;205.;Achinger Elżbieta;PO;70;ślubowała 11-07-2012;264.;Achinger Elżbieta;PO;36;  ;ślubowała 11-07-2012;
#420.;Adamczak Małgorzata;PO;4144;98.81;mandat wygasł 01-12-2014;413.;Adamczak Małgorzata;PO;16;mandat wygasł 01-12-2014;85.;Adamczak Małgorzata;PO;125;;mandat wygasł 01-12-2014;
#
