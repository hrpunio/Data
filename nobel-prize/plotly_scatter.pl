#!/usr/bin/perl
use WebService::Plotly;
use Getopt::Long;

# login to plotly script
require "$ENV{'HOME'}/bin/login2plotly.pl";

my $plotly = WebService::Plotly->new( un => $plotly_user, key => $plotly_key );

my $sep_sequence = ';';
my $col_x = -1;
my $col_y = -1;
my $chart_title='??Chart title??';
my $header='Y';
my $boxpoints='outliers'; ## or all' | 'outliers' | False
my $dryrun='';
my $USAGE="*** USAGE: -colx=i -coly=i -title=s -header=s -sep=s FILE *** \n";

# plot values from column 'col' grouped by column 'by'. If header is Y skip first row in data.
# Add title 'title'. Columns in csv data are separated by 'sep' (default ';')
GetOptions("colx=i" => \$col_x, "coly=i" => \$col_y, "title=s" => \$chart_title,
	'header=s' => \$header, 'sep=s' => \$sep_sequence, 'dryrun' => \$dryrun);
	##'boxpoints=s' => \$boxpoints ) ;  ## not work

if (($col_number == -1 ) || ($by_col_number == -1) ) { print $USAGE } 

while (<>) { chomp ($_); $nr++;
    if (($nr < 2) && ( $header eq 'Y' ) ) { next }
    $_ =~ s/"//g;
    my @fields = split(/$sep_sequence/, $_);
    ##push @Colx, $fields[$col_x]; push @Coly, $fields[$col_y];
    push @{$datax{$col_x}}, $fields[$col_x];
    push @{$datay{$col_y}}, $fields[$col_y];
    ##push @{$data{$fields[$by_col_number]}}, $fields[$col_number];

}

my @variants = sort keys %data;

print STDERR "*** No of rows scanned: $nr ***\n";
print STDERR "*** Groups found: @variants ($boxpoints) \n";
for $k (keys %data ) { 
  print "$k"; 
  push (@traces, { x => $datax{$k},
                   y => $datay{$k}, 
                   type => 'scatter', 
	           mode => 'markers', 
		   name => "$k" } ) }

if ($dryrun) { exit }

my $layout = { 'title' => $chart_title };

my $response = $plotly->plot(\@boxes, layout => $layout );
my $url = $response->{url};
my $filename = $response->{filename};

print STDERR "*** done: filename: '$filename' url: '$url' ***\n"
##
