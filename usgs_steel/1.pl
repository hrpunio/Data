$start = 0;
while (<>) {
if (/\(Thousand metric tons.*\)/) {
  print STDERR "!!!!!!!!!!!!!!! printing !!!!!!!!!!!!!!!!!!\n";
  $start = 1
}
if (/TABLE.*Continued/i || /Thousand metric tons.*/i ||
    /RAW STEEL/ ||
    /See footnotes/i || /^;+$/i ||  /HYDRAULIC.*CEMENT.*WORLD PRODUCTION/i) {next}
if (/eEstimated/) {$start = 0; break}
if ($start) {##
  ##print $_
  @t = split /;/, $_;

  $name = $t[0];
  $val = $t[$#t - 4];

  if ( $name =~ /^Country/ ) {
     $year = $val; 
     print STDERR ">>>> $year\n";
     ## for checking
     printf "##%s;%i;%s\n", $name, $year, $val;
     next
  } else {
     $val =~ s/,//g;
     $val =~ s/[ \t]//;
     ### check later
     if ($val !~ /[0-9]+/) {$val = '@NA@'  }

     $name =~ s/^[ \t]+|[ \t]+$//g;

     $name =~ s/ae$/a/;
     $name =~ s/oe$/o/;
     $name =~ s/ee$/e/;

     $name =~ s/[0-9, \t]+$//;

     $name =~ s/eshe$/esh/;
  }

  printf "%s;%i;%s\n", $name, $year, $val;

}

}
