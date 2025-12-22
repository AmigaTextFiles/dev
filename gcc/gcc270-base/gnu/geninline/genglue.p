$state = 0;

next_line: while (<STDIN>) {
  if (/.even/) {
    close (OUTY) if $state == 2;
    $state = 1;
  }
  elsif (/.globl _(\w+)/) {
    $state = 2;
    if (! open (OUTY, ">$1.s")) {
      print STDERR "Can't open $1.s, $!\n"; 
      $state = 0;
      next next_line;
    }
    print OUTY ".text; .even; $_\n";
  }
  elsif ($state == 2) {
    print OUTY "$_";
  }
}

