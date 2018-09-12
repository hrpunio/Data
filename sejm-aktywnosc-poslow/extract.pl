undef $/;

$d = <>;

while ( $d =~ m/<tr[^<>]*>(.*?)<\/TR>/pgi ) {
    $line = $1;
    $line =~ s/&nbsp;//g;
    $line =~ s/<\/TD>/;/g;
    $line =~ s/<\/td>/;/g;
    $line =~ s/<[^<>]*>//g;
    print "$line\n";

}



