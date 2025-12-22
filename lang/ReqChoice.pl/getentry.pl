#!/gg/bin/perl/
# getentry.pl checks for an entry and exits on a carriage-return-only entry
# exits on esc, control characters cr
# tested on Amithlon under Amiga OS 3.9 and v5.7.1 built for m68k-amigaos
# Comments and suggestions to Bonnie Dalzell
# 5100 Hydes Rd
# Hydes MD USA 
# 410-592-5512 - within the USA I do have flat rate long distance so if you want
# to discuss perl on the amiga I can call you back at no expense
# bdalzell@qis.net



$entry='a';

print "this accepts non-control keyboard entries and exits on a carriage return\n";
until($entry  eq ""){
    $entry = &getentry;
  if ($entry ne ""){
    print "you entered $entry\n";
  }#endif
}#until
  
 print "you entered only a carriage return. goodbye. \n";

sub getentry {
  print "enter something :";
  my $something=<STDIN>;
  chomp($something);
  return $something;
}#endsub
