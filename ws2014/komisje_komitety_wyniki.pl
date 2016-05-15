#!/usr/bin/perl
#
# Komitety zarejestr. w każdym województwie
my @Komitety = (1, 2, 3, 4, 5, 6, 7);

open (W, "kandydaci_obwody_wyniki.csv");

while (<W>) { chomp;
  @tmp = split (/;/, $_) ;
  $id = "$tmp[0]$tmp[1]"; 
  $idkomitet = $tmp[4];

  $W{$id}{$idkomitet} += $tmp[5];
}

close (W);

## ## ##
open (K, "komisje-frekwencja-2014-15.csv");

while (<K>) { chomp; $NN++;
  ## Wiersz nagłówka
  if ($NN == 1 ) { print "$_;psl;dbezp;pis;po;rn;sld;npjkm\n" ; next }

  @tmp = split (/;/, $_) ;
  $id = "$tmp[1]$tmp[2]";
  $K{$id} = $_; 
  if (exists $W{$id} ) { 
     ##print "OK!\n";
     if (exists $W{$id}{1} ) { $kom1 = $W{$id}{1} } else { $kom1 = 0 ;}
     if (exists $W{$id}{2} ) { $kom2 = $W{$id}{2} } else { $kom2 = 0 ;}
     if (exists $W{$id}{3} ) { $kom3 = $W{$id}{3} } else { $kom3 = 0 ;}
     if (exists $W{$id}{4} ) { $kom4 = $W{$id}{4} } else { $kom4 = 0 ;}
     if (exists $W{$id}{5} ) { $kom5 = $W{$id}{5} } else { $kom5 = 0 ;}
     if (exists $W{$id}{6} ) { $kom6 = $W{$id}{6} } else { $kom6 = 0 ;}
     if (exists $W{$id}{7} ) { $kom7 = $W{$id}{7} } else { $kom7 = 0 ;}

     print "$_;$kom1;$kom2;$kom3;$kom4;$kom5;$kom6;$kom7\n"
  }
  else { print STDERR "**** Problem $id\n";
  }
}

close(K);
