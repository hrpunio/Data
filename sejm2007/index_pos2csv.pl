#!/usr/bin/perl
$file=$ARGV[0];
$log=0;

open (F, $file);

##<td colspan="3" class="col1lar"><a href="33.htm" title="Kielce" class="link1">33</a></td>
##<td class="col1lar">6</td>
##<td class="col1lar">9</td>
##<td class="col5al"><a href="k4_33.htm" class="link1">KWITEK Marek</a></td>
##<td class="col5al"><a href="k4.htm" class="link1">Komitet Wyborczy Prawo i Sprawiedliwość</a></td>
##<td class="col5ar">2653</td>
##<td class="col5ar">0.55</td>
##<td colspan="3" class="col6pb" align="left"><img alt="" src="../../../img/bardot.png" width="1.18%" class="bar2"></td>


while (<F>) { chomp();
    if (/<tr>/) { ##print "==========>\n";
       $l1 = <F>; $nro=clean($l1);
       $l2 = <F>; $nrlisty=clean($l2);
       $l3 = <F>; $nrk=clean($l3);
       $l4 = <F>; $kto=clean($l4);
       $l5 = <F>; $komitet=clean($l5);
              $komitet =~ s/Komitet Wyborczy Prawo i Sprawiedliwość/PiS/;
              $komitet =~ s/Komitet Wyborczy Platforma Obywatelska RP/PO/;
              $komitet =~ s/Koalicyjny Komitet Wyborczy Lewica i Demokraci.*/SLD/;
              $komitet =~ s/Komitet Wyborczy Polskiego Stronnictwa Ludowego/PSL/;
       $l6 = <F>; $glosy=clean($l6);
       $l7 = <F>; $procent=clean($l7);
       $l8 = <F>; $pomin=clean($l8);
       print "$nro;$nrk;$komitet;$kto;$glosy;$procent;T\n"
     }
}


sub clean {
 my $s = shift;

 chomp($s);

 $s =~ s/<[^<>]+>//g;
 $s =~ s/^[ \t]+|[ \t]+$//g;

 return ($s);
}


close(F);
