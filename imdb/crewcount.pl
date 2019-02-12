##
##
open (T, "title.basics.WMovies.tsv");

while (<T>) { chomp();
  @tmp =  split /\t/, $_;
  $Ws{$tmp[0]}=$tmp[2]; ### id = nazwa
}

close(T);

### nazwiska
open (N, "name.basics.tsv");

while (<N>) { chomp();
  @tmp =  split /\t/, $_;
  $NN{$tmp[0]}=$tmp[1];
  $BB{$tmp[0]}=$tmp[2];
}

close(N);

###
###
open (C, "title.principals.tsv");

while (<C>) { chomp();
  @tmp =  split /\t/, $_;
  $idt = $tmp[0]; ## titleid
  $idc = $tmp[2];
  $idr = $tmp[3]; ## rola = actor/actress nas interesuje
  $name = $tmp[5];

  if (exists $Ws{$idt} && ( $idr =~ /actor/ || $idr =~ /actress/ )) {
     $Ns{$idc}++;
     $Ts{$idc} .= "$Ws{$idt}|";
  }
}

close(C);

for $n (sort {$Ns{$a} <=> $Ns{$b} } keys %Ns) {
   print "$n;$NN{$n};$Ns{$n};$BB{$n};$Ts{$n}\n";
}
