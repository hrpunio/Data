#!/usr/bin/perl
#
# frekwencja = lkw / lwug
# Oficjalna 2014 = 23.83% ; 2015 = 50.92%
#
my %Woj = (
'02' => 'Dolnośląskie', '04' => 'Kujawsko-pomorskie', '06' => 'Lubelskie', '08' => 'Lubuskie',
'10' => 'Łódzkie', '12' => 'Małopolskie', '14' => 'Mazowieckie', '16' => 'Opolskie', '18' => 'Podkarpackie',
'20' => 'Podlaskie', '22' => 'Pomorskie', '24' => 'Śląskie', '26' => 'Świętokrzyskie', '28' => 'Warmińsko-mazurskie',
'30' => 'Wielkopolskie', '32' => 'Zachodniopomorskie', );

$frqD=2.13; ## $f2015/$f2014 \approx 2.13
$pominKomisje = 14;

while (<>){ chomp();
  if ($_ =~ /lwug/) {next } ## pierwszy wiersz

  # 4/5 dla roku 2014 ;  11/12 dla roku 2015
  @tmp = split /;/, $_;
  $lwug14 = $tmp[4]; $lwug15 = $tmp[11];
  $lkw14 = $tmp[5]; $lkw15 = $tmp[12];
  $teryt = $tmp[1];
  $woj = substr($teryt, 0, 2);
  ##print "> $teryt $woj\n";

  if ($lwug14 eq 'NA' || $lwug15 eq 'NA' || $lkw14 eq 'NA' || $lkw15 eq 'NA' ) { next }
  
  $LWUG14{$woj} += $lwug14; $LWUG15{$woj} += $lwug15;
  $LKW14{$woj} += $lkw14; $LKW15{$woj} += $lkw15;

  $f2014 = $tmp[9]; $f2015 = $tmp[16];  $fdiff = $f2015 - $f2014;
  if (  $f2015 - $frqD * $f2014 >= 20.0 && ($lkw14 > $pominKomisje/$frqD || $lkw15 > $pominKomisje) ) {
        $BigDiff{$woj} .= ">> $tmp[3]: $lkw14 $lkw15 $f2014 $f2015 ($fdiff)\n";  }
}


print "Woj Freq2014 Freq2015 (F2015/2014)\n";
print "------------------------------\n";
for $w (sort keys %LWUG14) {
   $f2014 = $LKW14{$w}/$LWUG14{$w} *100;
   $f2015 = $LKW15{$w}/$LWUG15{$w} *100;

   printf "%s %.2f %.2f (%.2f)\n", $Woj{$w}, $f2014,  $f2015, $f2015/$f2014;
   #printf "%s %.2f %.2f\n", $w, $LWUG14{$w},  $LWUG15{$w};
   $lwug14 += $LWUG14{$w}; $lwug15 += $LWUG15{$w};
   $lkw14 += $LKW14{$w}; $lkw15 += $LKW15{$w};

}

$frq2014 = $lkw14/ $lwug14 * 100; $frq2015 = $lkw15/ $lwug15 * 100;

print "------------------------------\n";
printf "%s %.2f %.2f (%.2f)\n", "Razem", $frq2014, $frq2015, $frq2015/$frq2014;


for $w (sort keys %BigDiff) {
    print "$Woj{$w}:\n$BigDiff{$w}\n";
}
