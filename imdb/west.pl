##
## awk -F '\t' '$9 ~ "Western" { print $0}' title.basics.Movies.tsv | perl west.pl
##
%Skip = ('the' =>1, 'for' => 1, 'and'=>1, 'from'=>1, 'los' =>1, 'del' => 1, 'your' => 1, 'with' => 1);

open (W, ">title.basics.WMovies.tsv");

while (<>) { chomp();
  $skip_ = 0;
  $all_titles++;
  @tmp = split /\t/, $_;

  @title = split (/ /, $tmp[2]);
  @genres = split (",", $tmp[8]);
  ##print STDERR ">> $tmp[8]\n";

  for $g (@genres) {
    $g = lc($g); 
    ##print STDERR ">$g<\n";

    #action = 931 adult = 22 adventure = 656 animation = 9 biography = 41 comedy = 650
    #crime = 95 documentary = 91 drama = 957 family = 79 fantasy = 27 history = 78 horror = 93
    #music = 202 musical = 80 mystery = 73 news = 1 romance = 458 sci-fi = 35 short = 1
    #sport = 8 thriller = 100 war = 49 western = 6949
    # Skip untipical
    if ($g eq 'adult' || $g eq 'animation' || $g eq 'biography' || $g eq 'comedy' ||
        $g eq 'documentary' || $g eq 'fantasy' || $g eq 'horror' || $g eq 'music' ||
        $g eq 'musical' || $g eq 'mystery' || $g eq 'news' || $g eq 'romance' ||
        $g eq 'sci-fi' || $g eq 'short' || $g eq 'sport' || $g eq 'thriller') { $skip_ =1 }
    else {$GG{$g}=1; }

    $G{$g}++;

  }

  if ($skip_ > 0 ) { ##print STDERR "### Skipped...\n";  
    next; } ### skip untipical

  print W "$_\n";

  $Y{$tmp[5]}++;
  $selected_titles++;
  
  $titleLen = $#title +1;

  if ($titleLen > 9 ) { print "TL10 = $tmp[2] ($tmp[8])\n"; }
 
  for $w (@title) { $w = lc($w); 
 
    if ($w eq "dollars")   {$w = 'dollar'}
    if ($w eq "raiders")   {$w = 'raider'}
    if ($w eq "rides")     {$w = 'ride'}
    if ($w eq "riders")    {$w = 'rider'}
    if ($w eq "hills")     {$w = 'hill'}
    if ($w eq "trails")    {$w = 'trail'}
    if ($w eq "men")       {$w = 'man'}
    if ($w eq "rivers")    {$w = 'river'}
    if ($w eq "guns")      {$w = 'gun'}
    if ($w eq "kids")      {$w = 'kid'}
    if ($w eq "cowboys")   {$w = 'cowboy'}
    if ($w eq "zorro's")   {$w = 'zorro'}
    if ($w eq "billy's")   {$w = 'billy'}
    if ($w eq "kings")     {$w = 'king'}
    if ($w eq "mountains") {$w = 'mountains'}
 
    $wl = length($w);
    
    unless (exists $Skip{$w} ) { 
      if ($wl > 2 ) {  $T{$w}++ }; 
    }
  }

  unless ($tmp[2] eq '\\N') {
    $TL{$titleLen}++;
    $TLT{$titleLen} .= "$tmp[2];";
  }
}

close(W);

printf "All titles: %i\n", $all_titles;

for $g (sort keys %G ) { print $g, " = ", $G{$g}, "\n"; }

print "====\n";

printf "Selected titles: %i\n",  $selected_titles;

@sgs= keys %GG;
print "Selected genres: @sgs\n";

for $y (sort keys %Y ) { print $y, " = ", $Y{$y}, "\n"; }

print "====\n";

for $t (sort {$a <=> $b} keys %TL ) { print $t, " + ", $TL{$t}, "\n"; }

print "====\n";

for $w ( sort { $T{$b} <=> $T{$a} } %T ) { 
 $next++; 
 if ($next > 155) {exit}
 printf "%2i %s (%i)\n", $next, $w, $T{$w};
}
