use Locale::Codes::Country;

print "code;country;year;value\n";

while (<>) {
if (/^##/) {next}

$_ =~ s/Afghanistane/Afghanistan/;
$_ =~ s/Bahraine/Bahrain/;
$_ =~ s/Bangladesh[^;]*;/Bangladesh;/;
$_ =~ s/Barbadose/Barbados/;
$_ =~ s/Belgiume/Belgium/;
$_ =~ s/Benine/Benin/;
$_ =~ s/Belaruse/Belarus/;
$_ =~ s/Bhutane/Bhutan/;
$_ =~ s/Bruneie/Brunei/;
$_ =~ s/Burma[^;]*;/Burma;/;
$_ =~ s/Burundie/Burundi/;
$_ =~ s/Cameroone/Cameroon/;
$_ =~ s/Chade/Chad/;
$_ =~ s/Colombia[^;]*;/Colombia;/;
##$_ =~ s/Congo (Brazzaville)
$_ =~ s/Congo, Brazzaville/Congo \(Brazzaville\)/;
$_ =~ s/Congo \(Brazzaville\)e/Congo \(Brazzaville\)/;
##$_ =~ s/Congo (Kinshasa)
$_ =~ s/Congo, Kinshasa/Congo \(Kinshasa\)/;
##$_ =~ s/Cote d'Ivoire
$_ =~ s/Côte d'Ivoire/Cote d'Ivoire/;
$_ =~ s/Côte d’Ivoire/Cote d'Ivoire/;
$_ =~ s/Côte dʼIvoire/Cote d'Ivoire/;
$_ =~ s/Czech Republic/Czechia/;
##$_ =~ s/Czechia
$_ =~ s/Denmarke/Denmark/;
$_ =~ s/Djiboutie/Djibouti/;
$_ =~ s/Dominican Republice/Dominican Republic/;
$_ =~ s/Ecuadore/Ecuador/;
$_ =~ s/Egypte/Egypt/;
$_ =~ s/El Salvadore/El Salvador/;
$_ =~ s/Ethiopia[^;]*;/Ethiopia;/;
$_ =~ s/Fijie/Fiji/;
$_ =~ s/Finlande/Finland/;
$_ =~ s/Gabone/Gabon/;
##$_ =~ s/Ghana, from imported clinkere
##$_ =~ s/Grand total
##$_ =~ s/Grand totale
##$_ =~ s/Greece
$_ =~ s/Guadaloupe[^;]*;/Guadaloupe;/;
$_ =~ s/Haitie/Haiti/;
$_ =~ s/Hondurase/Honduras/;
$_ =~ s/Hong Konge/Hong Kong/;
$_ =~ s/Hungarye/Hungary/;
$_ =~ s/Icelande/Iceland/;
$_ =~ s/Irane/Iran/;
$_ =~ s/Iraqe/Iraq/;
$_ =~ s/Irelande/Ireland/;
$_ =~ s/Israele/Israel/;
$_ =~ s/Jordane/Jordan/;
####
##$_ =~ s/Korea, North
$_ =~ s/Korea, Northe/Korea, North/;
##$_ =~ s/Korea, Republic of
$_ =~ s/Kosovo[^;]*;/Kosovo;/;
$_ =~ s/Kuwaite/Kuwait/;
$_ =~ s/Laose/Laos/;
$_ =~ s/Luxembourge/Luxembourg/;
$_ =~ s/Madagascare/Madagascar/;
##
$_ =~ s/Malawie/Malawi/;
$_ =~ s/Malie/Mali/;
$_ =~ s/Martinique[^;]*;/Martinique;/;
$_ =~ s/Mozambique[^;]*;/Mozambique;/;
$_ =~ s/Nepal[^;]*;/Nepal;/;
$_ =~ s/Netherlandse/Netherlands/;
$_ =~ s/New Caledonia[^;]*;/New Caledonia;/;
$_ =~ s/New Zealande/New Zealand/;
$_ =~ s/Nigere/Niger/;
$_ =~ s/Norwaye/Norway/;
$_ =~ s/Omane/Oman/;
##
$_ =~ s/Pakistane/Pakistan/;
$_ =~ s/Paraguaye/Paraguay/;
$_ =~ s/Perue/Peru/;
$_ =~ s/Philippines8/Philippines/;
$_ =~ s/Philippinese/Philippines/;
$_ =~ s/Portugale/Portugal/;
$_ =~ s/Qatare/Qatar/;
##$_ =~ s/Reunion
$_ =~ s/Réunion/Reunion/;
$_ =~ s/Reunione/Reunion/;
$_ =~ s/Réunione/Reunion/;
$_ =~ s/Senegale/Senegal/;
$_ =~ s/Serbia and Montenegro7/Serbia/;
$_ =~ s/Serbia[^;]*;/Serbia;/;
##$_ =~ s/Spain
$_ =~ s/Spain, including Canary Islands/Spain/;
$_ =~ s/Suriname/Surinam/;
$_ =~ s/Swedene/Sweden/;
$_ =~ s/Switzerlande/Switzerland/;
$_ =~ s/Togo[^;]*;/Togo;/;
##$_ =~ s/Totale
$_ =~ s/Turkmenistane/Turkmenistan/;
$_ =~ s/United Arab Emiratese/United Arab Emirates/;
$_ =~ s/United States[^;]*;/United States;/;
$_ =~ s/Uruguaye/Uruguay/;
$_ =~ s/Uzbekistane/Uzbekistan/;
$_ =~ s/Yemene/Yemen/;
####


  @c = split /;/, $_; 
  $c3  = uc(country2code($c[0], LOCALE_CODE_ALPHA_3)); 
  ##print "$c3;$_\n";
 
  if ($c[0] eq 'Total') {
     print "WLD;$_";
  }
  else {
     print "$c3;$_";
  }

}
