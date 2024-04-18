#!/usr/bin/perl
# Wykorzystanie perl xslx2csv.pl plik.xslx [numer-arkusza]

use Spreadsheet::ParseXLSX;
#
use locale;
use utf8;
binmode(STDOUT, ":utf8");
##use open ":encoding(utf8)";
use open IN => ":encoding(utf8)", OUT => ":utf8";
#

$xslxfile = $ARGV[0]; 
$ArkuszNo = $ARGV[1] || 1; ## domyślnie arkuszu 1

my $source_excel = new Spreadsheet::ParseXLSX;
my $source_book = $source_excel->parse("$xslxfile")
  or die "Could not open source Excel file $xslxfile: $!";


##https://metacpan.org/pod/Spreadsheet::ParseExcel::Workbook

my $lastSheet = $source_book->worksheet_count();
$ArkuszNo = $lastSheet;

# Zapisuje zawartość wybranego arkusza do hasza %csv
my %csv = ();

foreach my $sheet_number (0 .. $source_book->{SheetCount}-1) {
  my $sheet = $source_book->{Worksheet}[$sheet_number];

  print STDERR "*** SHEET:", $sheet->{Name}, "/", $sheet_number, "\n";
  if ( $ArkuszNo ==  $sheet_number + 1 ) {

    next unless defined $sheet->{MaxRow};
    next unless $sheet->{MinRow} <= $sheet->{MaxRow};
    next unless defined $sheet->{MaxCol};
    next unless $sheet->{MinCol} <= $sheet->{MaxCol};

    foreach my $row_index ($sheet->{MinRow} .. $sheet->{MaxRow}) {
       foreach my $col_index ($sheet->{MinCol} .. $sheet->{MaxCol}) {
          my $source_cell = $sheet->{Cells}[$row_index][$col_index];
	  if ($source_cell) {
	    ##$csv{$row_index}{$col_index} = $source_cell->Value;
	    $cVal = $source_cell->Value;
            $cVal =~ s/\n/ /g;
            print "$cVal";
	  }
          unless($col == $sheet -> {MaxCol}) {print ";";}
       }
       unless( $row == $sheet -> {MaxRow}){print "\n";}
    }
  }
}
###
