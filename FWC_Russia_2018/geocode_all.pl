while (<>) {
 chomp();
 $_ =~ s/[ \t]//g;
 if (/citystate/) {next } ## skip header
 ($team, $no, $who, $born, $height, $weight, $club, $city, $age, $citystate) = split /;/;
 ($city, $state) = split /,/, $citystate;
 $addr = `geocodeCoder0.pl -a "$city" -country $state -log FWC2018.log`;
 $line = "$_;$addr\n";
 print STDERR $line;
 print $line;
}
