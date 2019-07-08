#!/usr/bin/perl
## Stations occupancy (daily/hourly)
## Typical usage: 
## perl mevo_ave_hr.pl  -s MEVO_STATIONS_ALT.csv -b MEVO_BIKES_1906.csv -m 6 -y 2019
## Note: do not feed compact base
##
use Geo::Distance;
use Getopt::Long;
use Date::Calc qw(Day_of_Week);
my $geo = new Geo::Distance;

my $stationsFile;
my $mevoBaseFile;
my $kilometer = 1000;

my %DoW = ( 1 => 'poniedziałek', 2 => 'wtorek', 3=> 'środa', 4 => 'czwartek', 
   5 => 'piątek', 6 => 'sobota', 7 => 'niedziela' );

GetOptions('s=s' => \$stationsFile, 'b=s' => \$mevoBaseFile, 'm=i' => \$monthN, 'y=i' => \$yearN);

unless (defined($monthN) && defined($monthN) && defined($mevoBaseFile) && defined(stationsFile)) { 
  die "USAGE: $0 -s STACJA -b BAZA -m M -y Y\n"; }

open (STATIONS, "$stationsFile") || die "Cannot open $stationsFile!\n";
for my $s (<STATIONS>) { chomp($s);
 if ($s =~ /city/) {next}
  my ($id, $latlng, $ele, $city) = split /;/, $s;
  $CName{"$id"} = "$city";
  $BNumByCity{$city}++; ## liczba stacji/wg/miast
  $stationsTotal++; }
print STDERR "Active stations found: $stationsTotal\n";

for $c (sort keys %BNumByCity) { printf "%5.5s %5i\n", $c, $BNumByCity{$c} }

close(STATIONS);

my $cityHdr = "       >>";
for $c (sort keys %BNumByCity) { $cityHdr .= sprintf "%6s ", $c; }
##print "$cityHdr\n"; exit;

open(BASE, $mevoBaseFile) || die "Cannot open $mevoBaseFile!\n";

while (<BASE>) {
 chomp();
 if ($_ =~ /date;/) {next}

 ($datetime, $bno, $sno) = split /;/, $_;
 $day = substr($datetime, 0, 2); 
 $hr = substr($datetime, 2, 2);  ## godzina
 $min = substr($datetime, 4, 2); ## minuta
 $date = "${day}"; ### bieżący miesiąc i rok
 $city = $CName{$sno};

 ###print STDERR "$datetime :: $day $hr $min\n";

 my $dow = Day_of_Week($yearN,$monthN,$day);

 ## Łącznie D S M ### ### ### ###
 $DHN{"$hr"}{"$day$min"}=1; ## liczba obserwacji w godzinie hr (w miesiącu)
 $DDN{"$day"}{"$hr$min"}=1; ##  liczba obs w dniu $day

 $S{$sno}++; ## stacje 
 $M{$city}++;

 ## Wg dni/godzin: DS DM CS CM
 $DS{"$hr"}{$sno}++;  ## stacje-godziny
 $DM{"$hr"}{$city}++; ## miasta-godziny
 $CS{"${day}"}{$sno}++;  ## stacje-dni
 $CM{"${day}"}{$city}++; ## miasta-dni

 $CSDow{"${dow}"}{$sno}++;  ## stacje-dni-t
 $CMDow{"${dow}"}{$city}++; ## miasta-dni-t
 $DayDoW{"$day"} = $dow; ##

 ##$CityDateTime{$city}{"${date}${hr}"}++;
 $Days{"$day"}=1;
 $Bikes{"$bno"}=1;
 $Hrs{"$hr"}=1;
}

close(BASE);

## ile dni tygodnia w m-cu
## for $d (keys %Days) { my $dow = Day_of_Week($yearN,$monthN,$day); $DofWN{"$dow"}++; $daysTotal++; }

### liczba obserwacji w dniu (miesiąca) x
for $x (keys %DDN) { my @NN = keys %{$DDN{$x} }; $ObsNum{$x} = $#NN +1;
     $ObsNumDoW{$DayDoW{$x}} += $ObsNum{$x}; ### liczba OBS w dow 
   }

## Wg miast/dni
print "### MIASTA DNI MIESIĄCA ### ### ### ### ##\n";
print "$cityHdr\n";

for $d (sort keys %Days) { 
   printf "%6s >>", $d;
   for $c (sort keys %BNumByCity) {
     ## CM-rowery łącznie w dniu d w mieście c Cites{c}
     printf "%6.2f ", $CM{$d}{$c} / $BNumByCity{$c} / $ObsNum{$d} ; ## średnio / dzień / stacja w mieście c
   }
   print "\n";
}

## Wg miast/dni
print "### MIASTA DNI TYGODNIA ### ### ### ### ##\n";
print "$cityHdr\n";
for $d (1, 2, 3, 4, 5, 6, 7) { 
   printf "%6s >>", $d;
   for $c (sort keys %BNumByCity) {
     printf "%6.2f ", $CMDow{$d}{$c}/$BNumByCity{$c} / $ObsNumDoW{$d}; ## średnio / stację /dzień tygodnia
   }
   print "\n";
}

##
for $x (keys %DHN) { my @NN = keys %{$DHN{$x} }; $ObsNum{$x} = $#NN +1; }
## Wg miast/godzin
print "### MIASTA GODZINY ### ### ### ### ### ###\n";
print "$cityHdr\n";
for $h (sort keys %Hrs) { 
   printf "%6s >>", $h;
   for $c (sort keys %BNumByCity) {
     printf "%6.2f ", $DM{$h}{$c}/$BNumByCity{$c}/$ObsNum{$h}; ## średnio / stację / godzinę
   }
   print "\n";
}

