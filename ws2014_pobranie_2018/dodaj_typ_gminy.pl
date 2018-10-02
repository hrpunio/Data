#!/usr/bin/perl
$wyniki = "ws2014_komitety_by_komisja.csv";

open (T, "teryt_kody_typy_GUS.csv");

while (<T>) { chomp();
  ($teryt, $typ, $name) = split /;/, $_;
  ##print "$teryt\n";
  $Type{$teryt} = $typ;
}

close(T);

open (T, "$wyniki") || die "cannot open $wyniki\n ";
while (<T>) { chomp();
  @tmp = split /;/, $_;
  if (exists  $Type{$tmp[0]}) { print "$_;$Type{$tmp[0]}\n" }
  else {print "$_;NA\n"; $NAs++ }
}

print STDERR "**** Nieznaleziono typu: $NAs ****\n"
