while (<>) {
 chomp();
 $_ =~ s/[ \t]//g;
 if (/citystate/) {next } ## skip header
 ($team, $no, $who, $born, $height, $weight, $club, $city, $age, $citystate) = split /;/;
 ($city, $state) = split /,/, $citystate;
 $C{$state}{$club} .= "$who;";
 $CN{$state}{$club}++;
 $SN{$state}++;
}

for $s (sort { $SN{$b} <=> $SN{$a} } keys %C ) {
    print "==> $s ($SN{$s})\n";
  for $c ( sort { $CN{$s}{$b} <=> $CN{$s}{$a} } keys %{ $C{$s}}) {
    $t = $C{$s}{$c};
    #$count_t = ($t =~ tr/X//);
    my $number_t = () = $t =~ /;/gi;
    print "  $c $number_t $C{$s}{$c}\n";
}
}
