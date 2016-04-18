while (<>) { chomp();
   @tmp = split /;/, $_;

   $teryt = $tmp[1];
   if (length($teryt) < 6) { $teryt = "0" . $teryt  }
   print "$tmp[0];$teryt;$tmp[2];$tmp[3];$tmp[4];$tmp[5];$tmp[6];$tmp[7];$tmp[8];$tmp[9];$tmp[10]\n";
   ##print "$tmp[0];$teryt;$tmp[2];$tmp[3];$tmp[4];$tmp[5];$tmp[6]\n";

}
