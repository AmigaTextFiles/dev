package Config;
use Exporter ();
@ISA = (Exporter);
@EXPORT = qw(%Config);
@EXPORT_OK = qw(myconfig config_sh config_vars);

$] == 5.002
  or die "Perl lib version (5.002) doesn't match executable version ($])\n";

# This file was created by configpm when Perl was built. Any changes
# made to this file will be lost the next time perl is built.

##
## This file was produced by running the Configure script. It holds all the
## definitions figured out by Configure. Should you modify one of these values,
## do not forget to propagate your changes by running "Configure -der". You may
## instead choose to run each of the .SH files by yourself, or "Configure -S".
##
#
## Configuration time: Thu Feb 29 23:56:29 MET 1996
## Configured by: amiga
## Target system: localhost 
#

my $config_sh = <<'!END!';
archlibexp='/gnu/lib/perl5/Amiga/5.002'
archname='Amiga'
cc='gcc'
ccflags='-DDEBUGGING'
cppflags='-DDEBUGGING'
dlsrc='dl_none.xs'
dynamic_ext=''
extensions='Fcntl FileHandle Safe GDBM_File SDBM_File'
installarchlib='/gnu/lib/perl5/Amiga/5.002'
installprivlib='/gnu/lib/perl5'
libpth='/gnu/lib'
libs='-lnet -lgdbm -lsdbm -lm -lc'
osname='amigaos'
osvers=''
prefix='/gnu'
privlibexp='/gnu/lib/perl5'
sharpbang='#!'
shsharp='true'
sig_name='ZERO HUP INT QUIT ILL TRAP ABRT EMT FPE KILL BUS SEGV SYS PIPE ALRM TERM URG STOP TSTP CONT CHLD TTIN TTOU IO XCPU XFSZ VTALRM PROF WINCH INFO USR1 USR2 MSG IOT '
so='none'
startsh='#!/bin/sh'
static_ext='Fcntl FileHandle Safe GDBM_File SDBM_File'
Author=''
CONFIG='true'
Date='$Date'
Header=''
Id='$Id'
Locker=''
Log='$Log'
Mcc='Mcc'
PATCHLEVEL='2'
RCSfile='$RCSfile'
Revision='$Revision'
SUBVERSION='0'
Source=''
State=''
afs='false'
alignbytes='2'
aphostname=''
ar='ar'
archlib='/gnu/lib/perl5/Amiga/5.002'
archobjs=''
awk='awk'
baserev='5.0'
bash=''
bin='/gnu/bin'
binexp='/gnu/bin'
bison=''
byacc='byacc'
byteorder='4321'
c=''
castflags='0'
cat='cat'
cccdlflags=''
ccdlflags=''
cf_by='amiga'
cf_email='amiga@localhost.nowhere'
cf_time='Thu Feb 29 23:56:29 MET 1996'
chgrp=''
chmod='chmod'
chown=''
clocktype='clock_t'
comm='comm'
compress=''
contains='grep'
cp='cp'
cpio=''
cpp='cpp'
cpp_stuff='42'
cpplast='-'
cppminus='-'
cpprun='gcc -E'
cppstdin='gcc -E'
cryptlib=''
csh=''
d_Gconvert='sprintf((b),"%.*g",(n),(x))'
d_access='define'
d_alarm='define'
d_archlib='define'
d_attribut='define'
d_bcmp='define'
d_bcopy='define'
d_bsd='define'
d_bsdpgrp='undef'
d_bzero='define'
d_casti32='define'
d_castneg='define'
d_charvspr='undef'
d_chown='define'
d_chroot='undef'
d_chsize='undef'
d_closedir='define'
d_const='define'
d_crypt='define'
d_csh='undef'
d_cuserid='define'
d_dbl_dig='define'
d_difftime='define'
d_dirnamlen='define'
d_dlerror='undef'
d_dlopen='undef'
d_dlsymun='undef'
d_dosuid='undef'
d_dup2='define'
d_eofnblk='define'
d_eunice='undef'
d_fchmod='define'
d_fchown='undef'
d_fcntl='define'
d_fd_macros='define'
d_fd_set='define'
d_fds_bits='define'
d_fgetpos='define'
d_flexfnam='define'
d_flock='define'
d_fork='undef'
d_fpathconf='define'
d_fsetpos='define'
d_getgrps='define'
d_gethent='undef'
d_gethname='undef'
d_getlogin='define'
d_getpgrp2='undef'
d_getpgrp='define'
d_getppid='define'
d_getprior='define'
d_htonl='define'
d_index='undef'
d_isascii='define'
d_killpg='define'
d_link='define'
d_locconv='undef'
d_lockf='undef'
d_lstat='define'
d_mblen='define'
d_mbstowcs='define'
d_mbtowc='define'
d_memcmp='define'
d_memcpy='define'
d_memmove='define'
d_memset='define'
d_mkdir='define'
d_mkfifo='define'
d_mktime='define'
d_msg='undef'
d_msgctl='undef'
d_msgget='undef'
d_msgrcv='undef'
d_msgsnd='undef'
d_mymalloc='undef'
d_nice='define'
d_oldarchlib='undef'
d_oldsock='undef'
d_open3='define'
d_pathconf='define'
d_pause='define'
d_phostname='undef'
d_pipe='define'
d_poll='undef'
d_portable='define'
d_pwage='undef'
d_pwchange='define'
d_pwclass='define'
d_pwcomment='undef'
d_pwexpire='define'
d_pwquota='undef'
d_readdir='define'
d_readlink='define'
d_rename='define'
d_rewinddir='define'
d_rmdir='define'
d_safebcpy='define'
d_safemcpy='undef'
d_seekdir='define'
d_select='define'
d_sem='undef'
d_semctl='undef'
d_semget='undef'
d_semop='undef'
d_setegid='undef'
d_seteuid='undef'
d_setlinebuf='define'
d_setlocale='undef'
d_setpgid='undef'
d_setpgrp2='undef'
d_setpgrp='define'
d_setprior='define'
d_setregid='undef'
d_setresgid='undef'
d_setresuid='undef'
d_setreuid='undef'
d_setrgid='undef'
d_setruid='undef'
d_setsid='undef'
d_shm='undef'
d_shmat='undef'
d_shmatprototype='undef'
d_shmctl='undef'
d_shmdt='undef'
d_shmget='undef'
d_shrplib='undef'
d_sigaction='define'
d_sigintrp=''
d_sigsetjmp='undef'
d_sigvec='define'
d_sigvectr='undef'
d_socket='define'
d_sockpair='undef'
d_statblks='define'
d_stdio_cnt_lval='undef'
d_stdio_ptr_lval='undef'
d_stdiobase='undef'
d_stdstdio='undef'
d_strchr='define'
d_strcoll='define'
d_strctcpy='define'
d_strerrm='strerror(e)'
d_strerror='define'
d_strxfrm='define'
d_suidsafe='undef'
d_symlink='define'
d_syscall='undef'
d_sysconf='define'
d_sysernlst=''
d_syserrlst='define'
d_system='define'
d_tcgetpgrp='define'
d_tcsetpgrp='define'
d_telldir='define'
d_time='define'
d_times='define'
d_truncate='define'
d_tzname='define'
d_umask='define'
d_uname='define'
d_vfork='define'
d_void_closedir='undef'
d_voidsig='define'
d_voidtty=''
d_volatile='define'
d_vprintf='define'
d_wait4='define'
d_waitpid='define'
d_wcstombs='define'
d_wctomb='define'
d_xenix='undef'
date='date'
db_hashtype='int'
db_prefixtype='int'
defvoidused='15'
direntrytype='struct dirent'
dlext='none'
eagain='EAGAIN'
echo='echo'
egrep='egrep'
emacs=''
eunicefix=':'
exe_ext=''
expr='expr'
find='find'
firstmakefile='GNUmakefile'
flex=''
fpostype='fpos_t'
freetype='void'
full_csh=''
full_sed='/bin/sed'
gcc=''
gccversion='2.7.2'
gidtype='gid_t'
glibpth='/usr/shlib  /lib/pa1.1 /usr/lib/large /lib /usr/lib /usr/lib/386 /lib/386 /lib/large /usr/lib/small /lib/small /usr/ccs/lib /usr/ucblib /usr/shlib '
grep='grep'
groupcat=''
groupstype='int*'
h_fcntl='false'
h_sysfile='true'
hint='previous'
hostcat=''
huge=''
i_bsdioctl=''
i_db='define'
i_dbm='define'
i_dirent='define'
i_dld='undef'
i_dlfcn='undef'
i_fcntl='undef'
i_float='define'
i_gdbm='define'
i_grp='define'
i_limits='define'
i_locale='define'
i_malloc='undef'
i_math='define'
i_memory='undef'
i_ndbm='define'
i_neterrno='undef'
i_niin='define'
i_pwd='define'
i_rpcsvcdbm='undef'
i_sgtty='undef'
i_stdarg='define'
i_stddef='define'
i_stdlib='define'
i_string='define'
i_sysdir='define'
i_sysfile='define'
i_sysfilio='define'
i_sysin='undef'
i_sysioctl='define'
i_sysndir='undef'
i_sysparam='define'
i_sysselct='undef'
i_syssockio=''
i_sysstat='define'
i_systime='define'
i_systimek='undef'
i_systimes='define'
i_systypes='define'
i_sysun='define'
i_termio='undef'
i_termios='define'
i_time='undef'
i_unistd='define'
i_utime='define'
i_varargs='undef'
i_varhdr='stdarg.h'
i_vfork='undef'
incpath=''
inews=''
installbin='/gnu/bin'
installman1dir=''
installman3dir=''
installscript='/gnu/bin'
installsitearch='/gnu/lib/perl5/site_perl/Amiga'
installsitelib='/gnu/lib/perl5/site_perl'
intsize='4'
known_extensions='DB_File Fcntl FileHandle GDBM_File NDBM_File ODBM_File POSIX SDBM_File Safe Socket'
ksh=''
large=''
ld='ld'
lddlflags=''
ldflags='-s'
less='less'
lib_ext='.a'
libc='/gnu/lib/libc.a'
libswanted='net socket inet nsl nm ndbm gdbm dbm db malloc dl dld ld sun m c cposix posix ndir dir crypt ucb bsd BSD PW x'
line='line'
lint=''
lkflags=''
ln='ln'
lns='/bin/ln -s'
locincpth='/usr/local/include /opt/local/include /usr/gnu/include /opt/gnu/include /usr/GNU/include /opt/GNU/include'
loclibpth='/usr/local/lib /opt/local/lib /usr/gnu/lib /opt/gnu/lib /usr/GNU/lib /opt/GNU/lib'
lp=''
lpr=''
ls='ls'
lseektype='off_t'
mail=''
mailx=''
make=''
mallocobj=''
mallocsrc=''
malloctype='void *'
man1dir=' '
man1direxp=''
man1ext='0'
man3dir=' '
man3direxp=''
man3ext='0'
medium=''
mips=''
mips_type=''
mkdir='mkdir'
models='none'
modetype='mode_t'
more='more'
mv=''
myarchname='amigaos'
mydomain='.nowhere'
myhostname='localhost'
myuname='localhost '
n='-n'
nm_opt=''
nm_so_opt=''
nroff='nroff'
o_nonblock='O_NONBLOCK'
obj_ext='.o'
oldarchlib=''
oldarchlibexp=''
optimize='-O'
orderlib='false'
package='perl5'
pager='/bin/less'
passcat=''
patchlevel='2'
path_sep=':'
perl='perl'
perladmin='amiga@localhost.nowhere'
perlpath='/gnu/bin/perl'
pg='pg'
phostname='hostname'
plibpth=''
pmake=''
pr=''
prefixexp='/gnu'
privlib='/gnu/lib/perl5'
prototype='define'
randbits='31'
ranlib=':'
rd_nodata='-1'
rm='rm'
rmail=''
runnm='true'
scriptdir='/gnu/bin'
scriptdirexp='/gnu/bin'
sed='sed'
selecttype='fd_set *'
sendmail='sendmail'
sh=''
shar=''
shmattype=''
shrpdir='none'
sig_num='0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 6 '
signal_t='void'
sitearch='/gnu/lib/perl5/site_perl/Amiga'
sitearchexp='/gnu/lib/perl5/site_perl/Amiga'
sitelib='/gnu/lib/perl5/site_perl'
sitelibexp='/gnu/lib/perl5/site_perl'
sizetype='size_t'
sleep=''
smail=''
small=''
sockethdr=''
socketlib=''
sort='sort'
spackage='Perl5'
spitshell='cat'
split=''
ssizetype='int'
startperl='#!/gnu/bin/perl'
stdchar='char'
stdio_base='((fp)->_base)'
stdio_bufsiz='((fp)->_cnt + (fp)->_ptr - (fp)->_base)'
stdio_cnt='((fp)->_cnt)'
stdio_ptr='((fp)->_ptr)'
strings='/gnu/include/string.h'
submit=''
sysman='/gnu/man/man1'
tail=''
tar=''
tbl=''
test='test'
timeincl='/gnu/include/sys/time.h '
timetype='time_t'
touch='touch'
tr='tr'
troff=''
uidtype='uid_t'
uname='uname'
uniq='uniq'
usedl='undef'
usemymalloc='n'
usenm='true'
useposix='true'
usesafe='true'
usevfork='true'
usrinc='/gnu/include'
uuname=''
vi=''
voidflags='15'
xlibpth='/usr/lib/386 /lib/386'
zcat=''
!END!

my $summary = <<'!END!';
Summary of my $package ($baserev patchlevel $PATCHLEVEL) configuration:
  Platform:
    osname=$osname, osver=$osvers, archname=$archname
    uname='$myuname'
    hint=$hint, useposix=$useposix 
  Compiler:
    cc='$cc', optimize='$optimize', gccversion=$gccversion
    cppflags='$cppflags'
    ccflags ='$ccflags'
    stdchar='$stdchar', d_stdstdio=$d_stdstdio, usevfork=$usevfork
    voidflags=$voidflags, castflags=$castflags, d_casti32=$d_casti32, d_castneg=$d_castneg
    intsize=$intsize, alignbytes=$alignbytes, usemymalloc=$usemymalloc, randbits=$randbits
  Linker and Libraries:
    ld='$ld', ldflags ='$ldflags'
    libpth=$libpth
    libs=$libs
    libc=$libc, so=$so
  Dynamic Linking:
    dlsrc=$dlsrc, dlext=$dlext, d_dlsymun=$d_dlsymun, ccdlflags='$ccdlflags'
    cccdlflags='$cccdlflags', lddlflags='$lddlflags'

!END!
my $summary_expanded = 0;

sub myconfig {
	return $summary if $summary_expanded;
	$summary =~ s/\$(\w+)/$Config{$1}/ge;
	$summary_expanded = 1;
	$summary;
}

tie %Config, Config;
sub TIEHASH { bless {} }
sub FETCH { 
    # check for cached value (which maybe undef so we use exists not defined)
    return $_[0]->{$_[1]} if (exists $_[0]->{$_[1]});
 
    my($value); # search for the item in the big $config_sh string
    return undef unless (($value) = $config_sh =~ m/^$_[1]='(.*)'\s*$/m);
 
    $value = undef if $value eq 'undef'; # So we can say "if $Config{'foo'}".
    $_[0]->{$_[1]} = $value; # cache it
    return $value;
}
 
my $prevpos = 0;

sub FIRSTKEY {
    $prevpos = 0;
    my($key) = $config_sh =~ m/^(.*?)=/;
    $key;
}

sub NEXTKEY {
    my $pos = index($config_sh, "\n", $prevpos) + 1;
    my $len = index($config_sh, "=", $pos) - $pos;
    $prevpos = $pos;
    $len > 0 ? substr($config_sh, $pos, $len) : undef;
}

sub EXISTS { 
     exists($_[0]->{$_[1]})  or  $config_sh =~ m/^$_[1]=/m; 
}

sub STORE  { die "\%Config::Config is read-only\n" }
sub DELETE { &STORE }
sub CLEAR  { &STORE }


sub config_sh {
    $config_sh
}
sub config_vars {
    foreach(@_){
	my $v=(exists $Config{$_}) ? $Config{$_} : 'UNKNOWN';
	$v='undef' unless defined $v;
	print "$_='$v';\n";
    }
}

1;
__END__

=head1 NAME

Config - access Perl configuration information

=head1 SYNOPSIS

    use Config;
    if ($Config{'cc'} =~ /gcc/) {
	print "built by gcc\n";
    } 

    use Config qw(myconfig config_sh config_vars);

    print myconfig();

    print config_sh();

    config_vars(qw(osname archname));


=head1 DESCRIPTION

The Config module contains all the information that was available to
the C<Configure> program at Perl build time (over 900 values).

Shell variables from the F<config.sh> file (written by Configure) are
stored in the readonly-variable C<%Config>, indexed by their names.

Values stored in config.sh as 'undef' are returned as undefined
values.  The perl C<exists> function can be used to check is a
named variable exists.

=over 4

=item myconfig()

Returns a textual summary of the major perl configuration values.
See also C<-V> in L<perlrun/Switches>.

=item config_sh()

Returns the entire perl configuration information in the form of the
original config.sh shell variable assignment script.

=item config_vars(@names)

Prints to STDOUT the values of the named configuration variable. Each is
printed on a separate line in the form:

  name='value';

Names which are unknown are output as C<name='UNKNOWN';>.
See also C<-V:name> in L<perlrun/Switches>.

=back

=head1 EXAMPLE

Here's a more sophisticated example of using %Config:

    use Config;

    defined $Config{sig_name} || die "No sigs?";
    foreach $name (split(' ', $Config{sig_name})) {
	$signo{$name} = $i;
	$signame[$i] = $name;
	$i++;
    }   

    print "signal #17 = $signame[17]\n";
    if ($signo{ALRM}) { 
	print "SIGALRM is $signo{ALRM}\n";
    }   

=head1 WARNING

Because this information is not stored within the perl executable
itself it is possible (but unlikely) that the information does not
relate to the actual perl binary which is being used to access it.

The Config module is installed into the architecture and version
specific library directory ($Config{installarchlib}) and it checks the
perl version number when loaded.

=head1 NOTE

This module contains a good example of how to use tie to implement a
cache and an example of how to make a tied variable readonly to those
outside of it.

=cut

