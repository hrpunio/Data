#!/usr/bin/perl
#
open (P14, "komisje-frekwencja.csv") || die "Cannot open 1\n";
open (P15, "../sejm2015/komisje-frekwencja2015.csv") || die "Cannot open 2\n";

while (<P14>) { chomp(); @tmp=split (/;/, $_); $L{"$tmp[1]_$tmp[2]"} = $_; }

while (<P15>) {
  chomp(); @tmp=split (/;/, $_);
  $id = "$tmp[1]_$tmp[2]";

  if (exists $L{$id} ) {
     print "$L{$id};$tmp[4];$tmp[5];$tmp[6];$tmp[7];$tmp[8];$tmp[9];$tmp[10];$tmp[3]\n";
  } else {
    warn "NO $id found\n!";
  }

}




