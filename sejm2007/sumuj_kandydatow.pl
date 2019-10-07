#!/usr/bip/perl -w
use strict;

my %P2O;
my %K;
my %G;
my %Okr;
my %OkrL;

open (O, "okregi_powiaty_sejm.csv");
while(<O>) {
  ## okr;woj;siedziba;ccsiedziby;teryt;status;nazwa;areaH;areakm;pop;popkm;rankA;rankP
  my @tmp = split /;/, $_;
  my $okr = $tmp[0];
  my $powiat=$tmp[4]; ## teryt-powiatu
  ##print ">$powiat<\n";

  $P2O{$powiat} = $okr;
}
close(O);
 ### obwody nietypowe
$P2O{"1499"} = "19"; ## zagranica
$P2O{"2298"} = "26"; ## tzw.statki (Gdynia)
$P2O{"2299"} = "25"; ## tzw.statki (Gdańsk)

open (K, "ws2007_kandydaci.csv");
while(<K>) {
 ## teryt;nro;nr;komitet;kto;glosy
 my ($teryt, $nro, $nr, $komitet, $kto, $glosy) = split /;/, $_;
 if ($teryt eq 'teryt') {next} ## nagłówek
 my $powiat = substr ($teryt, 0, 4);
 ##print "$powiat => $P2O{$powiat}\n";
 unless (defined $P2O{$powiat}) { die "ERROR: Undefined $powiat\n"; }
 my $okr = $P2O{$powiat};
 my $nrk = sprintf "%02i", $nr;
 #okr;nrk;komitet;kandydat;glosy;procent;procentl;wynik;plec
 $K{$okr}{$komitet}{$nrk}=$kto;
 $G{$okr}{$komitet}{$nrk} += $glosy;
 $Okr{$okr} += $glosy;
 $OkrL{$okr}{$komitet} += $glosy;
}

close(K);

my ($o, $k, $n);

for $o ( sort keys %K ) {
   for $k ( sort keys %{$K{$o}} ) {
      for $n ( sort keys %{$K{$o}{$k}} ) {
          my $procent = $G{$o}{$k}{$n} / $Okr{$o} * 100;
          my $procentL = $G{$o}{$k}{$n} / $OkrL{$o}{$k} *100;
          my $kto = $K{$o}{$k}{$n};
          ##
          my @name = split / /, $kto;
          my $iimie = ''; my $plec ='';
          my $imie = $name[$#name]; ## ostatni
          my $imieTmp = $name[$#name -1];
          if ($imieTmp =~ /[a-z]/) {$iimie = $imie;  $imie = $imieTmp} ## dwa imiona są
          my $lastChar = chop($imie);
          ##print "==> $imie :: $lastChar ($imieTmp/$iimie)\n";
          if ($lastChar eq 'a') {$plec = 'K'} else {$plec = 'M'}
          ##
          print "$o;$n;$k;$kto;$G{$o}{$k}{$n};";
          printf "%.2f;%.2f;", $procent, $procentL;
          print "xxx;$plec\n";
      }
   }

}

