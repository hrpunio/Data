#!/usr/bin/perl
open (LOG, ">>ws2014_log.log");

open (L, ">>ws2014_listy.csv");
open (K, ">>ws2014_kandydaci.csv");
open (X, ">>ws2014_komisje.csv");

$fileName = $ARGV[0];
$fileName =~ s/(\/[^\/]+)$/$1/;

##print STDERR "$fileName";

open (Q, $ARGV[0]);
$OK="KO";

while (<Q>) { chomp(); if (/<\/html>/) { $OK = 'OK'; last; }}
if ($OK eq 'OK') {print STDERR "$fileName $OK!\n";}
else { print STDERR "$fileName $OK!\n";
      print LOG "$fileName $OK\n"; 
      exit; }
close(Q);

####exit;####


while(<>) {
   chomp();
	    
   if (/<h2>/) {  $mode = 'I'; 

       while (<>) {
          chomp();
	  if (/<div>Kod terytorialny/) { $Teryt = next_line(); }
          if (/<div>Numer obwodu/) { $IdO = next_line(); }
           if (/<div>Adres/) { $Addr = next_line();
             $IdDataFull = "$fileName;$Teryt;$IdO;$Addr";
             $IdData = "$fileName;$Teryt;$IdO";
             last;
          }
       }

   }
   if ($mode eq 'I') {
   }
   ##if (/<h3>/) {  print "$_\n"; }

   if (/Wyniki wyborów na Kandydatów/) {  $mode = 'C' }
   if (/ZESTAWIENIE WYNIKÓW/) {  $mode = 'S';
       while (<>) {
          chomp();

          if (/<div>Liczba wyborców uprawnionych do głosowania/) { $N_uprawnieni = next_line() ; }
          if (/<div>Komisja otrzymała kart do głosowania/) { $N_karty_otrzymane = next_line();}
          if (/<div>Nie wykorzystano kart do głosowania/) { $N_karty_niewykorzystane = next_line(); }
          if (/<div>Liczba wyborców, którym wydano karty do głosowania/) { $N_karty_wydane = next_line(); }
          if (/<div>Liczba wyborców głosujących przez pełnomocnika/) { $N_pelnomocnicy = next_line(); }
          if (/<div>Liczba wyborców, którym wysłano pakiety wyborcze/) { $N_pakiety = next_line(); }
          if (/<div>Liczba kart wyjętych z urny/) { $N_karty_wyjete = next_line(); }
          if (/<div>w tym liczba kart wyjętych z kopert na karty do głosowania/) {$karty_z_kopert = next_line(); }
          if (/<div>Liczba kart nieważnych/) { $N_karty_niewazne = next_line(); }
          if (/<div>Liczba kart ważnych/) { $N_karty_wazne = next_line(); }
          if (/<div>Liczba głosów nieważnych/) { $N_glosy_niewazne = next_line(); }
          if (/<div>Liczba głosów ważnych oddanych/) {
	    $N_glosy_wazne = next_line() ;
	    print X "$IdDataFull;$N_uprawnieni;$N_karty_otrzymane;$N_karty_niewykorzystane;"
	      . "$N_karty_wydane;$N_pelnomocnicy;$N_pakiety;$N_karty_wyjete;$karty_z_kopert;"
	      . "$N_karty_niewazne;$N_karty_wazne;$N_glosy_wazne;$N_glosy_niewazne\n";
	    last;
          }
       }

			       }

   ##########

   if (/Wyniki wyborów na listy/) {
     $mode = 'L' ;
     $colNo=0;
     %List = ();
     $start = 0;
     while (<>) {
          chomp();
          if (/<tbody>/) {$start = 1}
          if ($start == 1 ) {
              if (/<td[^<>]*>/ ) { #############
	         $colNo++;
                 $List{$colNo} = clean($_);
              }
              if (/<tr>/) {
                  $colNo=0;
                  %List = ();
		}
	      if (/<\/tr>/) {
		$line_ = "$IdData;";
		for $x (sort keys %List ) { $line_ .= "$List{$x};" }
		print L "$line_\n";
              }
              if (/<\/tbody>/ ) {###
                 last;
              } ##//
	    }
	}
   }

   
   ###########

   if ($mode eq 'C' && /<tr>/) {
       $colNo=0;
       %Candidate = ();
       while (<>) {
	 chomp();
	 
          if (/<table>/) { next } ## skip this line

	 if (/<\/tr>/ ) { 
              $line_ = "$IdData;";
              for $x (sort keys %Candidate ) {  $line_ .= "$Candidate{$x};" }
              print K "$line_\n";
              last; 
          } ## //end 
          if (/<td[^<>]*>/ ) { #############
	       $colNo++;
               $Candidate{$colNo} = clean($_);
	     }
	}
     }

}

########################################################################

sub clean {
  my $x = shift;

  $x =~ s/<[^<>]+>//g;
  $x =~ s/^[\t ]+|[\t ]+$//g;
  $x =~ s/&quot;//g;
  return ($x)
}


sub next_line {
   while (<>) {
      chomp();
      return (clean ($_));
   }
}


close(L);
close(K);
close(X);

print LOG "$fileName $OK\n";

close (LOG);
## ///
  
