#!/usr/bin/perl
use Time::Local;
use POSIX qw(strftime);
##use Date::Calc qw(Day_of_Week Week_Number);
##use Date::WeekNumber qw/ cpan_week_number iso_week_number /;
## 7 for sunday
## https://en.wikipedia.org/wiki/ISO_week_date#First_week
# If 1 January is on a Monday, Tuesday, Wednesday or Thursday, it is in W01. 
# If it is on a Friday, it is part of W53 of the previous year. If it is on a Saturday, it is part of the last week 
# of the previous year which is numbered W52 in a common year and W53 in a leap year. 
# If it is on a Sunday, it is part of W52 of the previous year.

$PP="http://policja.pl/pol/form/1,Informacja-dzienna.html";
$PPBase="pp.csv";
$PPBaseA="ppw.csv";

### read the database
open (PP, "<$PPBase") || die "cannot open $PPBase/r!\n" ;
open (PPA, ">$PPBaseA") || die "cannot open $PPBase/w!\n" ;

while (<PP>) { chomp(); 
  $line = $_; 

  if ( $line =~ /interwencje/ ) { next }

  ($data, $interwencje, $zng, $zp, $znk, $w, $z, $r) = split /;/, $line; 

  ($y, $m, $d) = split /\-/, $data;

  ##print STDERR ">> $y $m $d ($line)\n";

  #$dow = Day_of_Week($y, $m, $d);
  ##$dow = sprintf "%02i", iso_week_number($y, $m, $d);
  $epoch = timelocal( 0, 0, 0, $d, $m - 1, $y - 1900 );
  $dow  = strftime( "%U", localtime( $epoch ) );

  if ($dow == 0) { $y = $y - 1;
     $epoch = timelocal( 0, 0, 0, 31, 11, $y - 1900 );
     $dow= strftime( "%U", localtime( $epoch ) );
  } ## dodaj do 52/53 tygodnia poprzedniego roku

  unless ( $interwencje eq 'NA') { $I_v{"$y;$dow"} += $interwencje; $I_n{"$y;$dow"}++ }
  unless ( $zng eq 'NA') { $ZNG_v{"$y;$dow"} += $zng; $ZNG_n{"$y;$dow"}++ }
  unless ( $zng eq 'NA') { $ZP_v{"$y;$dow"} += $zp; $ZP_n{"$y;$dow"}++ }
  unless ( $znk eq 'NA') { $ZNK_v{"$y;$dow"} += $znk; $ZNK_n{"$y;$dow"}++ }
  unless ( $w eq 'NA') { $W_v{"$y;$dow"} += $w; $W_n{"$y;$dow"}++ }
  unless ( $z eq 'NA') { $Z_v{"$y;$dow"} += $z; $Z_n{"$y;$dow"}++ }
  unless ( $r eq 'NA') { $R_v{"$y;$dow"} += $r; $R_n{"$y;$dow"}++ }
  $Data{"$y;$dow"} = 1;
  $Days{"$y;$dow"} .= "$data,";
}

close(PP);
close(PPA);

print "rok;nrt;interwencje;in;zng;zngn;zp;zpn;znk;znkn;wypadki;wn;zabici;zn;ranni;rn;d1;d7\n";

for $k (sort keys %Data) {
  ##print "$k\n";
  if ( $I_v{"$k"} eq "")   { $I_v{"$k"} = 'NA'; $I_n{"$k"} = 'NA'}
  if ( $ZNG_v{"$k"} eq "") { $ZNG_v{"$k"} = 'NA'; $ZNG_n{"$k"} = 'NA';  }
  if ( $ZP_v{"$k"} eq "")  { $ZP_v{"$k"} = 'NA'; $ZP_n{"$k"} = 'NA';  }
  if ( $ZNK_v{"$k"} eq "") { $ZNK_v{"$k"} = 'NA'; $ZNK_n{"$k"} = 'NA';  }
  if ( $W_v{"$k"} eq "")   { $W_v{"$k"} = 'NA'; $W_n{"$k"} = 'NA';  }
  if ( $Z_v{"$k"} eq "")   { $Z_v{"$k"} = 'NA'; $Z_n{"$k"} = 'NA';  }
  if ( $R_v{"$k"} eq "")   { $R_v{"$k"} = 'NA'; $R_n{"$k"} = 'NA'; }

  chop($Days{$k});
  @days = split /,/, $Days{$k};
  $day1 = $days[0];
  $day7 = $days[$#days];

  print "$k;$I_v{$k};$I_n{$k};$ZNG_v{$k};$ZNG_n{$k};$ZP_v{$k};$ZP_n{$k};$ZNK_v{$k};$ZNK_n{$k};"
    . "$W_v{$k};$W_n{$k};$Z_v{$k};$Z_n{$k};$R_v{$k};$R_n{$k};$day1;$day7\n";
  if ($Z_n{$k} != 7) { print STDERR "$k $Z_n{$k} = $Days{$k}\n"}
}
