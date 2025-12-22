#!/usr/bin/perl -w
# $Id: qa.pl 1.6 2005/03/20 11:19:03 wepl Exp wepl $

$| = 1;	# autoflush
$sourcefile = "qa.asm";
@reasonfiles = ( "Includes:whdload.i","../whd.i" );
$reasonfile = 'tdreason.i';
$whdloadbase = "WHDLoad Slave=QA.Slave NoReq SplashDelay=0";
$tmpfile = "T:qa.tmp";
$logfile = "qualitycheck.log";

# arguments
if (@ARGV > 0) {
  foreach (@ARGV) {
    if (/^\d+$/) {
      push @nums,$_;
    } elsif (/^(\d+)\-(\d+)$/ and $1 < $2) {
      $i = $1;
      while ($i <= $2) {
        push @nums,$i++;
      }
    } elsif (/^dump$/i) {
      $whdloadbase .= ' CoreDump';
    } elsif (/^cd32$/i) {
      $whdloadbase =~ s/WHDLoad/WHDLoadCD32/;
    } else {
      die "usage: perl qa.pl [number number-number...] [cd32] [dump]\n";
    }
  }
} else {
  @nums = ();
}

# check cpu type
$_ = `cpu`;
/System: 680(\d\d) / or die "cannot parse output from CPU command '$_'";
$cpu = $1;
if ($cpu == 30 or $cpu == 40 or $cpu == 60) { $mmu = 1 } else { $mmu = 0 }
if ($mmu == 1 and $cpu != 40) { $snoop = 1 } else { $snoop = 0 }
# check if given number should be executed on current cpu
sub ChkNum {
  $num = shift;
  if (@nums) {
    if (grep(/$num/,@nums)) { return 1 } else { return 0 }
  }
  if ($num < 10000) {
    return 1;
  } elsif ($num < 30000) {
    die "invalid number '$num'";
  } elsif ($num < 40000) {
    return $cpu == 30 ? 1 : 0;
  } elsif ($num < 60000) {
    die "invalid number '$num'";
  } elsif ($num < 70000) {
    return $cpu == 60 ? 1 : 0;
  } elsif ($num < 80000) {
    die "invalid number '$num'";
  } elsif ($num < 90000) {
    return $mmu == 1 ? 1 : 0;
  } elsif ($num < 100000) {
    return $snoop == 1 ? 1 : 0;
  } else {
    die "invalid number '$num'";
  }
}

# collect TDREASON values
if (&Newer($reasonfile,@reasonfiles)) {
  open OUT,">$reasonfile" or die "$reasonfile:$!";
  foreach $file (@reasonfiles) {
    print "parsing '$file'\n";
    open IN,$file or die "$file:$!";
    while (<IN>) {
      if (/^TDREASON_(\w+)\s*=\s*(-?\d+)/) {
        $reason{$1} = $2;
        $rsnnum{$2} = $1;
	print OUT "TDREASON_$1=$2\n";
      }
    }
    close IN;
  }
  close OUT;
} else {
  print "parsing '$reasonfile'\n";
  open IN,$reasonfile or die "$reasonfile:$!";
  while (<IN>) {
    if (/^TDREASON_(\w+)=(-?\d+)/) {
      $reason{$1} = $2;
      $rsnnum{$2} = $1;
    }
  }
  close IN;
}
sub Newer {
  my($base,$basetime,$act,$acttime);			#local variables
  $base = shift;					#first arg is base file
  if (-f $base) {
    $basetime = (stat($base))[9] || die "$base:$!";	#modification stamp
    while ($act = shift) {
      $acttime = (stat($act))[9] || return 0;		#modification stamp
      if ($acttime > $basetime) {
        return 1;
      }
    }
    return 0;
  } else {
    return 1;
  }
}
print "found " . scalar(keys(%reason)) . " TDREASON's\n";


open IN,$sourcefile or die "$!:$sourcefile";
while (<IN>) {
  if (/^\s+TAB\s+(\d+),.*;(.*?)\s*;(.*?)[\s\r\n]*$/) {
    $num = $1; &ChkNum($num) or next;
    $rsn = $2;
    $arg = $3;
    ($rsn,@pat) = split ',',$rsn;
    print "$num $arg -> ";
    $rc = system("$whdloadbase Custom1=$num $arg >$tmpfile") / 256;
    if ($rc != 0 and $rc < 100) {
      &ReadFile($tmpfile);
      die "whdload return code = $rc\n$_";
    }
    $out = &ReadFile($tmpfile);
    if ($rc == 0) { $rc = -1 } else { $rc -= 100 }
    if ($rc != $reason{$rsn}) {
      print "FAILED expected $rsn got $rsnnum{$rc}\n";
      $error = "$num using '$arg' expected $rsn got $rsnnum{$rc}\n";
    } else {
      $err = 0;
      foreach (@pat) {
	$pat = $_;
	$pat =~ s/([\$\(\)])/\\$1/g;
	if ($out !~ /$pat/) {
          $err = 1;
          last;
        }
      }
      if ($err) {
        print "FAILED $rsn pattern '$pat' not found in output\n";
        $error = "$num using '$arg' got $rsn pattern '$pat' not found\n";
      } else {
        print join(',',$rsn,@pat) . "\n";
        next;
      }
    }
    print $out;
    push @error,$error;
    &log("$error$out");
  }
}

if (@error) {
  print "the following checks had errors:\n";
  foreach (@error) {
    print $_;
  }
} else {
  print "no errors :-)\n";
}

sub log {
  open OUT,">>$logfile" or die "$logfile:$!";
  print OUT "----------------- " . &DateStamp . " -----------------\n@_";
  close OUT;
}

###########################################################################
# returns date stamp as string "01.01.1970" from time value
sub DateStamp {
  local(@t) = localtime(time);
  return sprintf("%02d.%02d.%d %02d:%02d:%02d",
    $t[3],$t[4]+1,$t[5]+1900,$t[2],$t[1],$t[0]);
}

###########################################################################
# read complete file into string variable
# 1st parameter = filename
#
sub ReadFile {
  my($name) = shift;
  local(*IN,$size);
  open(IN,$name) or die "$name:$!";
  #binmode IN;			# permit cr/lf transation under M$
  $size = (stat(IN))[7];
  ($size == sysread(IN,$_,$size)) or die "$name:$!";
  close(IN);
  return $_;
}

