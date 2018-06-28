for $f ( @ARGV ) {
  print STDERR "PARSING:" . $f . "\n";
  $team = $f;
  $team =~ s/s_//;   $team =~ s/.html//;

  open (F, "<$f") || die "cannot open $f\n";
  $l2p='';
  
  while (<F>) {
    chomp();
    s/&amp;/&/g;
    s/&#39;/'/g;
    ###print $_;

    #if (/Zawodnik|Obrońcy|Pomocnicy|Bramkarze|Napastnicy/) {
    #  next
    #} else {
    
      if (/<\/tr>/) {
	unless ( $l2p =~ /Zawodnik|Obrońcy|Pomocnicy|Bramkarze|Napastnicy/ ) {
	  print "$team;$l2p\n"; 
	}
	$l2p='';
      }
      elsif (/<\/td>/) { print ";" }
      elsif (/^[ \t]*$/) { next }
      elsif (/<|>|colspan/) { next }
      else { $l2p .= "$_;" }
    #}
  }

  close(F);
}
