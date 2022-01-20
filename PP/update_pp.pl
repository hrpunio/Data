#!/usr/bin/perl
use LWP::Simple;
## Uaktualnienie statystyk policyjnych

$PP="http://policja.pl/pol/form/1,Informacja-dzienna.html";
$PPBase="pp.csv";

$content = get("$PP");

$content =~ s/\r//g; # dla pewności usuń

@content = split (/\n/, $content);

foreach (@content) { chomp();
  unless ($_ =~ m/data-label=/ ) { next }

  if ($_ =~ m/Data statystyki/ ) { $d = clean($_); }
  elsif ($_ =~ m/Interwencje/ )  { $i = clean($_); }
  elsif ($_ =~ m/Zatrzymani na g/ ) { $zg = clean($_); }
  elsif ($_ =~ m/Zatrzymani p/ ) { $zp = clean($_); }
  elsif ($_ =~ m/Zatrzymani n/ ) { $zn = clean($_); }
  elsif ($_ =~ m/Wypadki d/ ) { $w = clean($_);  }
  elsif ($_ =~ m/Zabici/ )  { $z = clean($_);  }
  elsif ($_ =~ m/Ranni/ ) { $r = clean($_);
    $l = "$d;$i;$zg;$zp;$zn;$w;$z;$r";
    ##$last_line = "$l"; $last_date = "$d";
    $lastDays{$d}="$l";
 }
}

### read the database
open (PP, "<$PPBase") || die "cannot open $PPBase/r!\n" ;

while (<PP>) { chomp(); 
  $line = $_; 
  @tmp = split /;/, $line; 
  $Base{"$tmp[0]"} = "$line";
}

close(PP);

### append the database (if new records are present)
open (PP, ">>$PPBase") || die "cannot open $PPBase/w!\n" ;

for $ld (sort keys %lastDays) {
   unless ( exists ($Base{$ld} )) { 
      print PP "$lastDays{$ld}\n";
   }
   else {
      print STDERR "$ld already in the database!\n"
   }
}

close(PP);

sub clean  {
 my $s = shift;
 $s =~ s/<[^<>]*>//g;
 $s =~ s/[ \t]//g;

 return ($s);

}
