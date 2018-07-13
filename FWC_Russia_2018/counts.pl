$PASSED="ARG|BEL|BRA|COL|CRO|DEN|ENG|ESP|FRA|JPN|MEX|POR|RUS|SUI|SWE|URU";



while (<>) {
 chomp();
 $_ =~ s/[ \t]//g;
 if (/citystate/) {next } ## skip header
 @tmp = split /;/;
 $tn = $tmp[0]; ## team name
 ($t, $c) = split /,/, $tmp[9];
 $C{$c}++;
 print ">$tn<\n";
 $Codes{$c}=1;

 if ($tn =~ /$PASSED/) {
   $D{$c}++; 
   $P++; 
 }
 $N++; 
}
for $c (sort %Codes) { print "$c "; } ; print "\n";

for $c (sort {$C{$a} <=> $C{$b} } keys %C) { print "$c => $C{$c} (" . $C{$c}/$N*100 . " " 
  . $D{$c}/$P*100  . ")\n"; }

print STDERR "$N $P\n";
