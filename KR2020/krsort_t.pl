#!/usr/bin/perl
$DNF = 999999999999;
while (<>) {
   chomp();
   if(/Czas_netto/) { next}
   ##03:22:17.53 pole = 13
   $_ =~ s/[\&\#\_]//g;

   @tmp = split /;/, $_;
   ($h, $m, $s) = split /:/, $tmp[12];

   if ($h > 0 || $m > 0 || $s > 0 ) {
      $czas = $h * 3600  + $m * 60 + $s ;
   } else {
      $czas = $DNF; ### nie ukończył
   }

   $C{$tmp[0]} = $czas;
   $Z{$tmp[0]} = "$tmp[0];$tmp[1] $tmp[2] $tmp[3]/$tmp[4];$tmp[6];$tmp[8];$tmp[10]/$tmp[11];$tmp[12]";
 
}

$TeXhead = '\\documentclass{article}
\\usepackage{polyglossia}
\\setdefaultlanguage{polish}
\\textheight=900mm
\\textwidth=300mm
\\usepackage[width=290truemm,height=950truemm,pdftex]{crop}
\\evensidemargin=\\oddsidemargin
\\font\\rm="Iwona Condensed:mapping=tex-text,+onum" at 9pt
\\font\\bf="Iwona Condensed/B:mapping=tex-text,+onum" at 9pt
\\font\\em="Iwona Condensed/I:mapping=tex-text,+onum" at 9pt
\\font\\BF="Iwona Condensed/B:mapping=tex-text,+onum,+smcp" at 11pt
\\def\\Z#1#2#3#4#5#6#7{\quad#1&#2&#3&#4&#5&#6&#7\\quad\\\\ }
\\def\\ZS{\multicolumn{7}{l}{\hss}\\\\
\multicolumn{7}{l}{Na podstawie: %%
https://elektronicznezapisy.pl/event/5210/results.html?fbclid=IwAR1PfaAC8Fl3oI\_iySIWUGGPCeUzax5foYTY9s-rHTP-eY3qpLXoPyfOTqA}\\\\ }
\\pagestyle{empty}\\thispagestyle{empty}\\begin{document}\\rm';

$TeXtail = '\\end{document}';
$tablehead = '\\begin{tabular}{|lllllll|} \\hline
Lp&Nr&Zawodnik&Kat&Km/h&Start/Meta&Czas\\\\ \\hline';
$tabletail = ' \\hline \\ZS \\end{tabular}';
$newpage =  '\\newpage';

#### #### ####
print $TeXhead;
print $tablehead . "\n";
for $z (sort { $C{$a} cmp $C{$b} } keys %C ) {
    $ordNo++;
    if ($C{$z} == $DNF ) { $C{$z} ='DNF'  }
    $l = $Z{$z} ; $l =~ s/;/\}\{/g;
    print "\\Z{$ordNo}{$l}\n";

   if ($ordNo == 150 ) {  print "$tabletail\n\n" . "$newpage\n" . $tablehead ; }
}

if ($ordNo != 150 ) {  print $tabletail . "\n\n"; }
print $TeXtail;


