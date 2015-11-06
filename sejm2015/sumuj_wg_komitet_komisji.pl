#!/usr/bin/perl
#
# Drukuje $max_komisja komisji z najwyższym poparcie dla każdego komitetu
# Dodatkowo drukuje wszystkie komisje w których oddani niska_fq i mniej ważnych głosów
#
my $max_komisja = 25 ; # ile wydrukować
my $low_turnover_log = "low_turnover__.html";
my $niska_fq = 5;
my $date = `date +"%FT%T"`;

### ## ### ###
$html_head = '<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head><meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="DC.date" content="%s"/>
  <meta name="DC.creator" content="Tomasz Przechlewski" />
  <meta name="DC.rights" content="(c) Tomasz Przechlewski"/>
  <link rel="stylesheet" type="text/css" href="/style/tp-base.css" title="ES"/>
  <link rel="alternate stylesheet" type="text/css" href="/style/tp-bw.css" title="NS"/>
  <link rel="alternate stylesheet" type="text/css" href="/style/tp-big.css" title="BS"/>
  <script type="text/javascript" src="/script/tp.js"></script>
  <title xml:lang="pl">%s</title></head><body xml:lang="pl"><h2>%s</h2>
';

open (O, "kody_adresy.csv") ;
#
while (<O>) {
  chomp();
  # idkomisji;tkod;adres 
  @tmp = split (/;/, $_);
  $Adres{"$tmp[0]"} = $tmp[2]; ## idkomisji -> adres
}

close (O);

print STDERR "**** wczytałem kody z pliku kody_komisji_s.csv\n";
#
################################

while (<>) {
  chomp(); $razem++;

  if ($razem ==1) { next }

  @tmp = split (/;/, $_);
  # idkomisji;nrlisty;numer;kto;komitet;glosy;teryt;woj

  $Glosy{"$tmp[4]"}{"$tmp[0]"} += $tmp[5];
  $RazemKomisja{"$tmp[0]"} += $tmp[5];
  if ($razem % 10000 == 0 ) {   print STDERR "."; }
}

print STDERR "\n";

### ## ### ###
open (LT, ">$low_turnover_log"); 
print STDERR "**** Low tunover ($niska_fq) written to $low_turnover_log ***\n";

printf LT $html_head, $date, "Komisje z najniższą frekwencją #Wybory2015",
  "Komisje z najniższą frekwencją #Wybory2015";

### Ile komisji miało niską frekwencję
for $w ( sort { $RazemKomisja{$a} <=> $RazemKomisja {$b} } keys %RazemKomisja) {
    $url = "http://parlament2015.pkw.gov.pl/321_protokol_komisji_obwodowej/$w";
    if ($RazemKomisja{ $w } < $niska_fq ) { print STDERR "\n********* komisja $w = $RazemKomisja{$w} głosów\n";  
       printf LT "<div><a href='%s'>%s</a> %d (%s)</div>\n", $url, $w, $RazemKomisja{$w}, $Adres{$w};
   }
}

print LT "<p>$date</p>";
print LT "</body></html>\n";
close (LT);


### ## ### ###
for $k (keys %Glosy) {
   for $w (keys %{ $Glosy {$k} } ) {
      if ($RazemKomisja{ $w } > 0 ) {
          $Glosy{$k}{$w} = $Glosy{$k}{$w} / $RazemKomisja{ $w } * 100;
      } 
      
   }
}

### ## ### ###

printf $html_head, $date, "Komisje z rekordowym poparciem wg komitetów #Wybory2015",
  "Komisje z rekordowym poparciem wg komitetów #Wybory2015";

for $k (sort keys %Glosy) {
   $k_razem = 0; $komisje = 0;
   print "<h3>$k</h3>\n";
   print "<p><strong>idkomisji :: %głosów ważnych (ogółem na wszystkich kandydatów) adres</strong></p>";

   for $w (sort { $Glosy{$k}{$b} <=> $Glosy {$k}{$a} } keys %{ $Glosy {$k} } ) {
      $komisje++;

      $url = "http://parlament2015.pkw.gov.pl/321_protokol_komisji_obwodowej/$w";
      ## 25 najwyższych wyników
      if ($komisje <= $max_komisja ) {
         printf "<div><a href='%s'>%s</a> :: %.2f (%d) %s</div>\n", $url, $w, 
               $Glosy{$k}{$w}, $RazemKomisja{$w}, $Adres{$w};
         ###$k_razem += $Glosy{$k}{$w};
      }
   }
   ##print "Razem: $k: $k_razem\n";
}

print "<p>$date</p>";
print "</body></html>\n";

## ##
