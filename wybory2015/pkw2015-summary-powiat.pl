#!/usr/bin/perl
#DOLNOŚLĄSKIE 	1216650 	554269 	45.56%	662381 	54.44% 	45.56% 	54.44%
#KUJAWSKO-POMORSKIE 	841230 	366053 	43.51%	475177 	56.49% 	43.51% 	56.49%
#LUBELSKIE 	925889 	614512 	66.37%	311377 	33.63% 	66.37% 	33.63%
#LUBUSKIE 	390245 	155481 	39.84%	234764 	60.16% 	39.84% 	60.16%
#ŁÓDZKIE 	1131684 	608325 	53.75%	523359 	46.25% 	53.75% 	46.25%
#MAŁOPOLSKIE 	1538284 	955102 	62.09%	583182 	37.91% 	62.09% 	37.91%
#MAZOWIECKIE 	2704603 	1448847 	53.57%	1255756 	46.43% 	53.57% 	46.43%
#OPOLSKIE 	376915 	159545 	42.33%	217370 	57.67% 	42.33% 	57.67%
#PODKARPACKIE 	932033 	665377 	71.39%	266656 	28.61% 	71.39% 	28.61%
#PODLASKIE 	490093 	290681 	59.31%	199412 	40.69% 	59.31% 	40.69%
#POMORSKIE 	989316 	397943 	40.22%	591373 	59.78% 	40.22% 	59.78%
#ŚLĄSKIE 	1970555 	961706 	48.80%	1008849 	51.20% 	48.80% 	51.20%
#ŚWIĘTOKRZYSKIE 	531578 	328202 	61.74%	203376 	38.26% 	61.74% 	38.26%
#WARMIŃSKO-MAZURSKIE 	540068 	236314 	43.76%	303754 	56.24% 	43.76% 	56.24%
#WIELKOPOLSKIE 	1484588 	617184 	41.57%	867404 	58.43% 	41.57% 	58.43%
#ZACHODNIOPOMORSKIE 	679207 	271086 	39.91%	408121 	60.09% 	39.91% 	60.09%

my %PKWDuda ;
my %PKWBul ;

PKWData(1401, 	'białobrzeski', 15025, 	11018, 	73.33,		  4007, 	26.67, 	73.33, 	26.67);
PKWData(1402, 	'ciechanowski', 37003, 	21972, 	59.38,		 15031, 	40.62, 	59.38, 	40.62);
PKWData(1403, 	'garwoliński', 	51851, 	38734, 	74.70,		 13117, 	25.30, 	74.70, 	25.30);
PKWData(1404, 	'gostyniński', 	18938, 	12205, 	64.45,		  6733, 	35.55, 	64.45, 	35.55);
PKWData(1405, 	'grodziski', 	43883, 	21034, 	47.93,		 22849, 	52.07, 	47.93, 	52.07);
PKWData(1406, 	'grójecki', 	45365, 	28262, 	62.30,		 17103, 	37.70, 	62.30, 	37.70);
PKWData(1407, 	'kozienicki', 	28398, 	20217, 	71.19,		  8181, 	28.81, 	71.19, 	28.81);
PKWData(1408, 	'legionowski', 	54417, 	26605, 	48.89,		 27812, 	51.11, 	48.89, 	51.11);
PKWData(1409, 	'lipski', 	13803, 	 9353, 	67.76,		  4450, 	32.24, 	67.76, 	32.24);
PKWData(1410, 	'łosicki', 	13773, 	 9759, 	70.86,		  4014, 	29.14, 	70.86, 	29.14);
PKWData(1411, 	'makowski', 	19912, 	13888, 	69.75,		  6024, 	30.25, 	69.75, 	30.25);
PKWData(1412, 	'miński', 	70524, 	41797, 	59.27,		 28727, 	40.73, 	59.27, 	40.73);
PKWData(1413, 	'mławski', 	29712, 	18420, 	62.00,		 11292, 	38.00, 	62.00, 	38.00);
PKWData(1414, 	'nowodworski', 	34981, 	19076, 	54.53,		 15905, 	45.47, 	54.53, 	45.47);
PKWData(1415, 	'ostrołęcki', 	35577, 	25456, 	71.55,		 10121, 	28.45, 	71.55, 	28.45);
PKWData(1416, 	'ostrowski', 	32780, 	23703, 	72.31,		  9077, 	27.69, 	72.31, 	27.69);
PKWData(1417, 	'otwocki', 	62090, 	35517, 	57.20,		 26573, 	42.80, 	57.20, 	42.80);
PKWData(1418, 	'piaseczyński', 84757, 	38936, 	45.94,		 45821, 	54.06, 	45.94, 	54.06);
PKWData(1419, 	'płocki', 	44049, 	29716, 	67.46,		 14333, 	32.54, 	67.46, 	32.54);
PKWData(1420, 	'płoński', 	34279, 	21544, 	62.85,		 12735, 	37.15, 	62.85, 	37.15);
PKWData(1421, 	'pruszkowski', 	81449, 	38421, 	47.17,		 43028, 	52.83, 	47.17, 	52.83);
PKWData(1422, 	'przasnyski', 	21324, 	14425, 	67.65,		  6899, 	32.35, 	67.65, 	32.35);
PKWData(1423, 	'przysuski', 	19966, 	15201, 	76.13,		  4765, 	23.87, 	76.13, 	23.87);
PKWData(1424, 	'pułtuski', 	22051, 	14356, 	65.10,		  7695, 	34.90, 	65.10, 	34.90);
PKWData(1425, 	'radomski', 	65611, 	47527, 	72.44,		 18084, 	27.56, 	72.44, 	27.56);
PKWData(1426, 	'siedlecki', 	36916, 	28324, 	76.73,		  8592, 	23.27, 	76.73, 	23.27);
PKWData(1427, 	'sierpecki', 	20821, 	13630, 	65.46,		  7191, 	34.54, 	65.46, 	34.54);
PKWData(1428, 	'sochaczewski', 37159, 	22469, 	60.47,		 14690, 	39.53, 	60.47, 	39.53);
PKWData(1429, 	'sokołowski', 	26483, 	18861, 	71.22,		  7622, 	28.78, 	71.22, 	28.78);
PKWData(1430, 	'szydłowiecki', 16640, 	12188, 	73.25,		  4452, 	26.75, 	73.25, 	26.75);
PKWData(1432, 	'warszawski zachodni', 	55721, 	27545, 	49.43,	 28176, 	50.57, 	49.43, 	50.57);
PKWData(1433, 	'węgrowski', 	30727, 	21014, 	68.39,		  9713, 	31.61, 	68.39, 	31.61);
PKWData(1434, 	'wołomiński',  109709,  66269, 	60.40,		 43440, 	39.60, 	60.40, 	39.60);
PKWData(1435, 	'wyszkowski', 	33761, 	22486, 	66.60,		 11275, 	33.40, 	66.60, 	33.40);
PKWData(1436, 	'zwoleński', 	15544, 	11644, 	74.91,		  3900, 	25.09, 	74.91, 	25.09);
PKWData(1437, 	'żuromiński', 	15458, 	 9489, 	61.39,		  5969, 	38.61, 	61.39, 	38.61);
PKWData(1438, 	'żyrardowski', 	33915, 	18509, 	54.57,		 15406, 	45.43, 	54.57, 	45.43);
PKWData(1461, 	'Ostrołęka', 	23467, 	14096, 	60.07,		  9371, 	39.93, 	60.07, 	39.93);
PKWData(1462, 	'Płock', 	55939, 	29128, 	52.07,		 26811, 	47.93, 	52.07, 	47.93);
PKWData(1463, 	'Radom', 	99050, 	54225, 	54.75,		 44825, 	45.25, 	54.75, 	45.25);
PKWData(1464, 	'Siedlce', 	36590, 	21357, 	58.37,		 15233, 	41.63, 	58.37, 	41.63);
PKWData(1465, 	'Warszawa',    916778, 371864, 	40.56,		544914, 	59.44, 	40.56, 	59.44);
PKWData(0000,   'Zagranica',   158499,  88654,  55.93,           69845,         44.07,   0,      0,  ); # oddzielna strona

while(<>) {

 @tmp = split /;/, $_;
  $powiat = "$tmp[4]/$tmp[5]"; # powiat/woj
  $duda = $tmp[13];
  $bul = $tmp[14];

  ## licz bez zagranicy
  ##if ($powiat =~ m/Zagranica/ ) {next }

  $WynikBul{$powiat} += $bul;
  $WynikDuda{$powiat} += $duda;
  $Bul+=$bul;
  $Duda+=$duda;

}

# ** Jest błąd w woj mazowieckim **
for $w (keys %WynikBul ) {
  $diffBul = $WynikBul{$w} - $PKWBul{$w}; $diffDuda =  $WynikDuda{$w}- $PKWDuda{$w};

  printf "%s %d %d [%d] %d %d [%d]\n", $w, $WynikBul{$w}, $PKWBul{$w}, $diffBul,
    $WynikDuda{$w}, $PKWDuda{$w}, $diffDuda ;
  if ( $w =~ /\/mazowieckie/) {
    $mazowieckieBul+= $WynikBul{$w} ; $mazowieckieDuda+= $WynikDuda{$w}
  }

}

    print "Mazowsze: Bul/Duda: $mazowieckieBul $mazowieckieDuda\n";

sub PKWData {
  @tmp = @_;

  ##print ">>", $tmp[1], $tmp[3], $tmp[5],"\n";
  $PKWDuda{"$tmp[1]/mazowieckie"} = $tmp[3];
  $PKWBul{"$tmp[1]/mazowieckie"} = $tmp[5];
}