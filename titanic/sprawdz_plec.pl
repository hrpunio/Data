#!/usr/bin/perl 
#
# Dodanie do pliku Titanic_Passengers_and_Crew.txt płci na podstawie tytułu wpisanego
# w polu `Name'; Ustalone metodą prób-i-błędów...
while (<>) { chomp();
  $line = $_ ; 
  $sex_ ='';

  if ($line =~ /Name;Age;Class.or.Dept/) { 
	$line =~ s/Name;Age;Class.or.Dept/Name;Sex;Age;Class.or.Dept/;
	print "$line\n" ; 
	next ; 
  }

  @p = split /;/, $line ;
  $do = $p[0] ;

  if ($do =~ /, Mr |, Master |, Colonel |, Captain |, Major |, Sig. |, (Don.|Sir) |, Dr |, (Fr|Rev.)/) { $sex_ = "M" }
  elsif ($do =~ /, (Mrs|Ms) |, Miss |, (Lady|Countess|Doña)|, Mme. |, Mlle/) { $sex_ = "F" }
  elsif ($do =~ /OLIVA Y OCANA/) { $sex_ = "F" }
  else {
    print STDERR "*** $p[0] \n";
  }

  print "$p[0];$sex_;";

  for ($i=1; $i<=$#p; $i++){ print $p[$i], ";" ; }

  print "\n";

}
