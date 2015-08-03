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

%PKWDuda = (
	    'dolnośląskie' 	=> 554269,
	    'kujawsko-pomorskie'=> 366053,
	    'lubelskie' 	=> 614512,
	    'lubuskie' 	        => 155481,
	    'łódzkie' 	 	=> 608325,
	    'małopolskie' 	=> 955102,
	    'mazowieckie' 	=> 1448847,
	    'opolskie' 	 	=> 159545,
	    'podkarpackie' 	=> 665377,
	    'podlaskie' 	=> 290681,
	    'pomorskie' 	=> 397943,
	    'śląskie' 		=> 961706,
	    'świętokrzyskie' 	=> 328202,
	    'warmińsko-mazurskie' 	=> 236314,
	    'wielkopolskie' 	=> 617184,
	    'zachodniopomorskie'=> 271086,
	  );

%PKWBul = (
'dolnośląskie' 	        =>662381,
'kujawsko-pomorskie' 	=>475177,
'lubelskie' 	        =>311377,
'lubuskie' 	        =>234764,
'łódzkie' 	 	=>523359,
'małopolskie' 	 	=>583182,
'mazowieckie' 	 	=>1255756,
'opolskie' 	 	=>217370,
'podkarpackie' 	        =>266656,
'podlaskie' 	        =>199412,
'pomorskie' 	        =>591373,
'śląskie' 		=>1008849,
'świętokrzyskie' 	=>203376,
'warmińsko-mazurskie' 	=>303754,
'wielkopolskie' 	=>867404,
'zachodniopomorskie' 	=>408121,
);


while(<>) {

 @tmp = split /;/, $_;
  $woj = $tmp[5];
  $duda = $tmp[13];
  $bul = $tmp[14];

  $WynikBul{$woj} += $bul;
  $WynikDuda{$woj} += $duda;
  $Bul+=$bul;
  $Duda+=$duda;

}

# ** Jest błąd w woj mazowieckim **
for $w (keys %WynikBul ) {
  $diffBul = $WynikBul{$w} - $PKWBul{$w}; $diffDuda =  $WynikDuda{$w}- $PKWDuda{$w};

  printf "%s %d %d [%d] %d %d [%d]\n", $w, $WynikBul{$w}, $PKWBul{$w}, $diffBul,
    $WynikDuda{$w}, $PKWDuda{$w}, $diffDuda ;

}
