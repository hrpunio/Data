#!/usr/bin/perl

$xml_dir = $ARGV[0];
$xml_out_file='wybory2015-2.csv';

opendir(DIR, "$xml_dir") || die;
my @XMLFileList = grep(/html$/, readdir(DIR));
closedir(DIR);

print STDERR "Combining: @XMLFileList (from: $xml_dir)\n";

open (XMLOUT, ">$xml_out_file") || die "ERROR: Cannot open $xml_out_file\n";
print STDERR "Writing to: $xml_out_file\n";

foreach $file (sort @XMLFileList) {
  open (XML, "<$xml_dir/$file") || die "ERROR: Cannot open $file\n";
  print STDERR ">> $xml_dir/$file\n";

  ###my $okreg = <XML>;

  $kodTerytorialny=$adres=$adresGmina=$adresPowiat=$adresWoj='';
  $liczbaKartOgolem=$liczbaNWykorzyst=$liczbaWydanych=$liczbaWyjetych=$liczbaKartWaznych=$liczbaNWaznych=0;
  $liczbaWaznych=$duda=$komorowski=-1;

  while (<XML>) {
    chomp();

    if (/Kod terytorialny/) {$kodTerytorialny = <XML> ; $kodTerytorialny = popraw ($kodTerytorialny); }
    if (/Adres/) {$adres = <XML> ; $adres = popraw($adres); }
    if (/Gmina/) {$adresGmina = <XML> ; $adresGmina = popraw($adresGmina); }
    if (/Powiat/) {$adresPowiat = <XML> ; $adresPowiat = popraw($adresPowiat); }
    if (/Województwo/) {$adresWoj = <XML> ; $adresWoj = popraw($adresWoj); }

    if (/Liczba wyborców uprawnionych do głosowania/) { $liczbaUpr = <XML> ; $liczbaUpr = popraw( $liczbaUpr)}
    if (/Komisja otrzymała kart do głosowania/) { $liczbaKartOgolem = <XML> ; $liczbaKartOgolem = popraw($liczbaKartOgolem) }
    if (/Nie wykorzystano kart do głosowania/) { $liczbaNWykorzyst = <XML> ; $liczbaNWykorzyst = popraw($liczbaNWykorzyst) }
    if (/Liczba wyborców, którym wydano karty do głosowania/) { $liczbaWydanych = <XML> ; $liczbaWydanych = popraw($liczbaWydanych) }
    if (/Liczba kart wyjętych z urny/) { $liczbaWyjetych = <XML> ; $liczbaWyjetych = popraw($liczbaWyjetych) }
    if (/Liczba kart ważnych/) { $liczbaKartWaznych = <XML> ; $liczbaKartWaznych = popraw($liczbaKartWaznych)}
    if (/Liczba głosów nieważnych/) { $liczbaNWaznych = <XML> ;  $liczbaNWaznych = popraw($liczbaNWaznych)}
    if (/Liczba głosów ważnych oddanych łącznie/) { $liczbaWaznych = <XML> ; $liczbaWaznych = popraw($liczbaWaznych)  }

    if (/Komorowski Bronisław Maria/) { $komorowski=<XML> ; $komorowski= popraw($komorowski) ; }
    if (/Duda Andrzej Sebastian/ ) { $duda = <XML> ; $duda = popraw($duda) ; }
  }
  close (XML);

  $wynik = "$kodTerytorialny;$adres;$adresGmina;$adresPowiat;$adresWoj;" 
     . "$liczbaKartOgolem;$liczbaNWykorzyst;$liczbaWydanych;$liczbaWyjetych;"
     . "$liczbaKartWaznych;$liczbaNWaznych;$liczbaWaznych;$duda;$komorowski";

  $WynikCSV .= "$file;$wynik\n";

} ##//foreach

print XMLOUT $WynikCSV ;

sub popraw {
 my $line = shift;
 $line =~ s/\n//g;
 $line =~ s/;/,/g;
 $line =~ s/^[\t ]+|[ \t]+$//g;
 $line =~ s/<div[^>]*>//g;
 $line =~ s/<[^>]*div>//g;
 $line =~ s/<br \/>/|/g;
 $line =~ s/<\/?td>//g;
 $line =~ s/<a[^>]+>//g;
 $line =~ s/<\/a>//g;

 return $line; 
 
}

