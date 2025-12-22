#!/usr/bin/perl -w
# $Id: chkslaves.pl 1.1 2003/02/25 06:44:03 wepl Exp wepl $
# list all slaves recursively

if (@ARGV < 0) {
  print STDERR "usage: chkslaves.pl [file/dir...]\n";
  exit 1;
}

#$file = shift;
#open DB,$file or die "$!:$file";
#close DB;

@ARGV > 0 or push @ARGV,'.';
foreach $rootfile (@ARGV) {
  if (-d $rootfile) {
    &ScanDir($rootfile);
  } else {
    &Check($rootfile);
  }
}

exit;

sub ScanDir {
  local($dir) = @_;			#parameters
  local(*DIR,$file);			#local filehandle/variable
  opendir(DIR,$dir);
  while(defined ($file = readdir(DIR))) {		#for all files
    if ($file !~ /^\./) {		#no dot files !
      $file = "$dir/$file";
      if (-d $file) {			#directory ?
        &ScanDir($file);		#recurse
      } else {
        if ($file =~ /\.slave$/i) {	#html file ?
          &Check($file);
        }
      }
    }
  }
  closedir(DIR);
}

sub Check {
  $filename = $_[0];
  print "reading $filename\n";
  local(*IN);
  if (!open(IN,$filename)) {
    warn "$filename:$!";
    return;
  }
  binmode IN;			# permit cr/lf transation under M$
  $size = (stat(IN))[7];
  @t = localtime((stat(IN))[8]);
  $date = sprintf("%02d.%02d.%d-%02d:%02d:%02d",$t[3],$t[4]+1,$t[5]+1900,$t[2],$t[1],$t[0]);
  $offset = 0x020;		# exe header
  if (seek(IN,$offset,0) != 1) {
    warn "$filename:$!";
    return;
  }
  if ($size-$offset != read(IN,$_,$size-$offset)) {
    warn "$filename:$!";
    return;
  }
  close(IN);
  $Security=$GameLoader=0;	# avoid warnings
  ($Security,$ID,$Version,$Flags,$BaseMemSize,$ExecInstall,$GameLoader,
  $CurrentDir,$DontCache,$keydebug,$keyexit,$ExpMem,$name,$copy,$info) =
  unpack('N a8 n n N N n n n c c N n n n',$_);
  if ($ID ne 'WHDLOADS') {
    warn "$filename: id mismatch ('$ID')";
    return;
  }
  @flags = ('Disk','NoError','EmulTrap','NoDivZero','Req68020','ReqAGA','NoKbd','EmulLineA',
    'EmulTrapV','EmulChk','EmulPriv','EmulLineF','ClearMem','Examine');
  $lFlags = pack('V',$Flags);		# vec() works with little endian!
  for ($i=0,@vFlags=();$i<16;$i++) {
    vec($lFlags,$i,1) == 1 and push @vFlags,$flags[$i];
  }
  $sFlags = join('|',@vFlags);
  $CurrentDir = &GetString($CurrentDir);
  $DontCache = &GetString($DontCache);
  printf "slave=$filename size=$size date=$date ver=$Version flags=\$%x=($sFlags) basemem=\$%x=$BaseMemSize exec=\$%x" .
  " curdir=$CurrentDir dontcache=$DontCache",
  $Flags,$BaseMemSize,$ExecInstall;
  if ($Version >= 4) {
    printf " keydebug=\$%x keyexit=\$%x",$keydebug,$keyexit;
  }
  if ($Version >= 8) {
    printf " expmem=\$%x=$ExpMem",$ExpMem;
  }
  if ($Version >= 10) {
    $name = &GetString($name);
    $copy = &GetString($copy);
    $info = &GetString($info);
    printf " name=$name copy=$copy info=$info";
  }
  print "\n";
}

sub GetString {
  $offset = $_[0];
  if ($offset) {
    $data = "'" . unpack("x$offset Z*",$_) . "'";
    $data =~ s/\n/',10,'/g;
    $data =~ s/\xff/',-1,'/g;
    $data =~ s/,'',/,/g;
    return $data;
  } else {
    return 0;
  }
}
