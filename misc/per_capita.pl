#!/usr/bin/perl -w
# Dla danych z OTHERFILE.csv liczy per capita w oparciu o dane z world_population_by_country.csv
# należy podać numer kolumny z nazwą kraju, numer kolumny z wielkoscia do (s)perkapitalizowania.
# Opcjonalnie: separator jeżeli różny od `;' oraz mnożnik (zależny od tego w jakich jednostkach jest 
# wielkość perkapitalizowania (jeżeli np jest w tys a wsp. ma być w milionach to -mul = 1000)

# For data from OTHERFILE.csv computes per capita coefficients based 
# on country codes/populations from world_population_by_country.csv
# -col QUANTITY identifies data column, -name ISOCODECOLNO identifies coutry codes column
# Optional: SEPARATOR -- csv file separator (default ';'); MULTIPLIER -- multiplier (example: if
# coefficient per 1 mln inhabitants -mul = 1000 as population in world_population_by_country.csv is in ths)
#
use Getopt::Long;

my $other_file ='';
my $separator = ';';
my $colNameNo = -1;
my $colNo = -1;
my $colNoMul =1;

print STDERR "$0 -file OTHERFILE.csv -name ISOCODECOLNO -col QUANTITY -sep SEPARATOR (default ;) -mul MULTIPLIER\n";

GetOptions( "file=s" => \$other_file, "col=i" => \$colNo, "name=i" => \$colNameNo, 
   "sep=s" => \$separator, "mul=f" => \$colNoMul, ) ;

$pop_csv="world_population_by_country.csv";

open (POP, $pop_csv) || die "Cannot open: [$pop_csv] file\n";

while(<POP>) { chomp();
  if (/^#/) { next }

  @tmp = split /,/, $_;
  ## Country codes separated by |
  my @c_names = split /\|/, $tmp[0];
  foreach $c (@c_names) { $Pop{$c} = $tmp[4];  }

  if ($#tmp != 11 ) {  print "$#tmp $_\n"; }
}


close (POP);

open (OTHER_FILE, "$other_file") || die "Cannot open [$other_file] file\n";

while(<OTHER_FILE>) { chomp();
  if (/^#/) { next }

  @tmp = split /$separator/, $_;
  $Qte{$tmp[$colNameNo]} = $tmp[$colNo];
  $Lines{$tmp[$colNameNo]} = $_;
 
}


close (OTHER_FILE);

for my $c ( keys (%Qte) ) {
   if (exists $Pop{$c} ) { $QteQ{$c} = $Qte{$c}/$Pop{$c} }
   else { $QteQ{$c} = "-1" ;}
}

my $plc;

for my $c ( sort { $QteQ{$b} <=> $QteQ{$a} } keys (%QteQ) ) {
   $plc++;
   if (exists $Pop{$c} ) {
      my $q = sprintf "%.6f", $Qte{$c}/$Pop{$c} * $colNoMul ;
      print "$plc;$Lines{$c};$q\n";
   }
   else {
      print "*** $plc; No $c found!***\n"
   }

}

