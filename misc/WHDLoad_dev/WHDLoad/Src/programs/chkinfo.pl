#!/usr/bin/perl -w
# $Id$
# list tooltypes of a .info file

use strict;
my %icontype = (1,'Disk',2,'Drawer',3,'Tool',4,'Project',5,'Garbage',6,'Device',7,'Kick',8,'AppIcon');

if (@ARGV < 1) {
  die "usage: chkinfo.pl infofile\n";
}

my($file) = shift;
my(@tt) = &GetTT($file);
foreach (@tt) {
	print "'$_'\n";
}

sub GetTT {
  my($filename) = shift;
  my($size,@tt);
  local(*IN);
  if (!open(IN,$filename)) {
    warn "$filename:$!";
    return;
  }
  binmode IN;			# permit cr/lf transation under M$
  $size = (stat(IN))[7];
  if ($size != read(IN,$_,$size)) {
    warn "$filename:$!";
    close(IN);
    return;
  }
  close(IN);
  my $fullsize = $size;
  # decode structure DiskObject (workbench.i)
  my (	$magic,$version,$ggnext,$ggleft,$ggtop,$ggwidth,$ggheight,$ggflags,
	$ggacti,$ggtype,$gggadget,$ggselect,$ggtext,$ggmutual,$ggspecial,$ggid,$gguser,
	$type,$pad,$defaulttool,$tooltypes,$currentx,$currenty,$drawerdata,$toolwindow,$stacksize
  ) = unpack('n n N n n n n n n n N N N N N n N C C N N N N N N N',$_);
  $currentx == 0x80000000 and $currentx = 'nopos';
  $currenty == 0x80000000 and $currenty = 'nopos';
  if ($magic != 0xe310) {
    warn "$filename: magic mismatch ($magic)";
    return;
  }
  if ($version != 1) {
    warn "$filename: version mismatch ($version)";
    return;
  }
  printf "icon=$filename size=$size\n" .
  	"	type=$type=$icontype{$type} dt=%x tt=%x x=$currentx y=$currenty drawerdata=%x toolwin=$toolwindow\n" .
  	"	stack=$stacksize ggnext=$ggnext ggleft=$ggleft ggtop=$ggtop ggwid=$ggwidth gghei=$ggheight\n" .
	"	ggflags=$ggflags ggacti=$ggacti ggtype=$ggtype gggadget=%x ggselect=$ggselect\n" .
	"	ggtext=$ggtext ggmutual=%x ggspecial=$ggspecial ggid=$ggid gguser=%x\n"
	,$defaulttool,$tooltypes,$drawerdata,$gggadget,$ggmutual,$gguser;
  $_ = substr($_,0x4e);
  $size -= 0x4e;
  if ($drawerdata) {
    # decode structure DrawerData (workbench.i) which includes NewWindow (intuition.i)
    my ($nwleft,$nwtop,$nwwidth,$nwheight,$nwdpen,$nwbpen,$nwidcmp,$nwflags,$nwgadget,$nwcheck,$nwtitle,$nwscreen,$nwbitmap,
    	$nwminwidth,$nwminheight,$nwmaxwidth,$nwmaxheight,$nwtype,$ddx,$ddy) =
    unpack('n n n n c c N N N N N N N n n n n n N N',$_);
    $ddx = unpack('s',pack('S',$ddx));
    $ddy = unpack('s',pack('S',$ddy));
    printf "drawerdata(%x): left=$nwleft top=$nwtop wid=$nwwidth hei=$nwheight detailpen=$nwdpen blockpen=$nwbpen idcmp=$nwidcmp\n" .
    	"	flags=%x gadget=$nwgadget checkmark=$nwcheck title=$nwtitle screen=$nwscreen bitmap=$nwbitmap\n" .
    	"	minwid=$nwminwidth minhei=$nwminheight maxwid=$nwmaxwidth maxhei=$nwmaxheight type=$nwtype x=$ddx y=$ddy\n",
    	$fullsize-$size,$nwflags;
    $_ = substr($_,56);
    $size -= 56;
  }
  if ($gggadget) {
    # decode structure Image (intuition.i)
    my ($igleft,$igtop,$igwidth,$igheight,$igdepth,$igdata,$igpick,$igonoff,$ignext) =
    unpack('n n n n n N c c N',$_);
    $igdepth = unpack('s',pack('S',$igdepth));
    my($imgsize) = int(($igwidth+15)/16)*2 * $igheight * unpack("%8b*",pack('c',$igpick));
    printf "image(%x): left=$igleft top=$igtop wid=$igwidth hei=$igheight, depth=$igdepth" .
    	" data=%x pick=$igpick onoff=$igonoff\n" .
    	"	next=%x imgsize=$imgsize=%x\n",
    	$fullsize-$size,$igdata,$ignext,$imgsize;
    $_ = substr($_,20);
    $size -= 20;
    if ($igdata) {
      $_ = substr($_,$imgsize);
      $size -= $imgsize;
    }
  }
  if ($ggselect) {
    # decode structure Image (intuition.i)
    my ($igleft,$igtop,$igwidth,$igheight,$igdepth,$igdata,$igpick,$igonoff,$ignext) =
    unpack('n n n n n N c c N',$_);
    $igdepth = unpack('s',pack('S',$igdepth));
    my($imgsize) = int(($igwidth+15)/16)*2 * $igheight * unpack("%8b*",pack('c',$igpick));
    printf "image(%x): left=$igleft top=$igtop wid=$igwidth hei=$igheight, depth=$igdepth" .
    	" data=%x pick=$igpick onoff=$igonoff\n" .
    	"	next=%x imgsize=$imgsize=%x\n",
    	$fullsize-$size,$igdata,$ignext,$imgsize;
    $_ = substr($_,20);
    $size -= 20;
    if ($igdata) {
      $_ = substr($_,$imgsize);
      $size -= $imgsize;
    }
  }
  if ($defaulttool) {
    my ($dtlen,$dt) = unpack('N Z*',$_);
    printf "defaulttool(%x): '$dt'\n",$fullsize-$size;
    $_ = substr($_,4 + $dtlen);
    $size -= 4 + $dtlen;
  }
  if ($tooltypes) {
    my ($ttlen,$tt);
    my ($ttcnt) = unpack('N',$_) /4 - 1;
    printf "tooltypes(%x): $ttcnt\n",$fullsize-$size;
    $_ = substr($_,4);
    $size -= 4;
    die "too many tooltypes" unless $ttcnt < 10;
    while ($ttcnt) {
      ($ttlen,$tt) = unpack('N Z*',$_);
      $_ = substr($_,4 + $ttlen);
      $size -= 4 + $ttlen;
      print "\t'$tt'\n";
      push @tt,$tt;
      $ttcnt--;
    }
  }
  if ($size) {
  	if (substr($_,0,4) eq 'FORM') {
  		# color icon data in iff structure
  		my ($id,$len) = unpack('N N',$_);
  		printf "coloricon(%x): size=$len\n",$fullsize-$size;
		$_ = substr($_,8+$len);
		$size -= 8+$len;
	}
  }
  $size and warn sprintf("size = $size should be zero! offset=%x",$fullsize-$size);
  return @tt;
}
