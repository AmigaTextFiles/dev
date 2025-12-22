%define name	fakebo
%define ver	0.4.1
%define rel	1

Summary: Fakes trojan servers and logs incoming requests
Name: %name
Version: %ver
Release: %rel
Copyright: GPL
Group: X11/Utilities
Source: ftp://ftp.linux.hr/pub/fakebo/fakebo-%{ver}.tar.gz
BuildRoot: /tmp/%{name}-root
URL: http://cvs.linux.hr/fakebo/
Docdir: /usr/doc
Packager: Larry Reckner <larryr@capital.net> 
Requires: /sbin/chkconfig /bin/sh

%description
FakeBO fakes trojan server responses (Back Orifice, NetBus, etc.)
and logs every attempt to a logfile or stdout. It is able to send
fake pings and replies back to the client trying to access your system.

%prep
%setup -q

%build
CFLAGS="$RPM_OPT_FLAGS" ./configure
make

%install
if [ -d $RPM_BUILD_ROOT ]; then rm -r $RPM_BUILD_ROOT ; fi
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/usr/man/man1
mkdir -p $RPM_BUILD_ROOT/etc/rc.d/init.d
install -s -m 755 -o 0 -g 0 fakebo $RPM_BUILD_ROOT/usr/bin
install -m 644 -o 0 -g 0 fakebo.1 $RPM_BUILD_ROOT/usr/man/man1
install -m 600 -o 0 -g 0 fakebo.conf.dist $RPM_BUILD_ROOT/etc
install -m 755 -o 0 -g 0 fakebo.init $RPM_BUILD_ROOT/etc/rc.d/init.d/fakebo
ln -s $RPM_BUILD_ROOT/etc/fakebo.conf.dist $RPM_BUILD_ROOT/etc/fakebo.conf

%clean
rm -rf $RPM_BUILD_ROOT

%post
/sbin/chkconfig --add fakebo

%postun
if [ $1 = 0 ]; then
    /sbin/chkconfig --del fakebo
fi

if [ -s /etc/fakebo.conf ]; then
   cp /etc/fakebo.conf.rpmsave
   ln -s /etc/fakebo.conf.dist /etc/fakebo.conf
fi

%files
/usr/bin/fakebo
/usr/man/man1/fakebo.1
/etc/rc.d/init.d/fakebo
%config /etc/fakebo.conf.dist
%doc COPYING INSTALL HACKING AUTHORS TODO NEWS ChangeLog README custom.replies

%changelog
* Wed Jun 02 1999  Dobrica Pavlinusic <dpavlin@linux.hr>

	included .spec file into mail distribution

* Thu May 13 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 TODO: this will really wait for next release!

	 HACKING: added versions of needed tools

	 fakebo.conf, fakebo.conf.dist: Rename fakebo.conf to
	  fakebo.conf.dist

	 config.c: Added defaults if no config is found

	 Makefile.am, README, TODO: don't overwrite old configuration

	 README: Added Windows NT references (yak!)

	 configure.in: comming to 0.4.0 slowly :-)

	 configure.in, global.h: time.h updates (adds UWIN support, btw!)

	 Makefile.am: removing of obsolite file

	 README: boclient changes

	 README.BeOS: informations moved to README. patch move to
	  boclient CVS tree :-)

* Thu May 13 1999  ravilov  <ravilov@iname.com>

	 NEWS: RealBO news

	 realbo.c, TODO, fakebo.c: some fixes, more RealBO commands

* Thu May 13 1999  kost  <kost@iname.com>

	 TODO: More TODOs for Dobrica

	 TODO, fakebo.c: FakeBO doesn't answer if len field is not
	  correct (like REAL bo server)

	 fakebo.c: Added more Debug informations.

	 fakebo.c: Optimized cracking routine + indented

* Thu May 13 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 Makefile.am, configure.in, global.h, misc.c: Added GNU autoconf
	  stuff for pwd.h

* Thu May 13 1999  kost  <kost@iname.com>

	 misc.c, misc.h, TODO, config.c, fakebo.1, fakebo.c, fakebo.conf,
	  global.h: FakeBO will now drop privileges if euid=0 (root)

	 AUTHORS, README: Changed URLs. Added more documentation about
	  developing and hacking.

	 AUTHORS: Splitted Developers from the Contributors

* Thu May 13 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 .cvsignore: small update

* Wed May 12 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 TODO, acconfig.h, bo.h, configure.in, fakebo.c, realbo.c, NEWS:
	  Lot of portability fixes (read NEWS!) and pre5 release

	 configure.in, fakebo.c: cleanups

	 global.h, misc.c, realbo.c, NEWS, TODO, acconfig.h, bo.h,
	  configure.in, fakebo.c: compatibility improvements, cleanups

	 Makefile.am: option -Wall is now default and checked inside
	  configure

	 TODO: more stuff to fix before relese

	 global.h: added mising sys/select.h

* Wed May 12 1999  kost  <kost@iname.com>

	 fakebo.1: Manual page updated for new options

	 fakebo.conf: Added suport for option in executescipt to expand percent 
	  to [nb] or [bo] (depending on attack)

	 fakebo.c: Added option in executescript to expand percent to bo or 
	  netbus (depending on attack)

	 fakebo.c: Removed some code from main() to stand-alone functions()

	 fakebo.c, misc.c, misc.h: Short GNU Licence is now in misc.c (to 
	  reduce the lines in main())

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 Makefile.am: Added missing README.BeOS

	 TODO: Tommorow is a new day...

* Tue May 11 1999  kost  <kost@iname.com>

	 NEWS, configure.in: 0.3.4pre4 release

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 misc.c: fixed syslog

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 fakebo.c, misc.c: removeunprintable() fix

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 misc.c, fakebo.c: More BeOS tweaking

	 configure.in: nuked unused functions

	 global.h, configure.in, fakebo.c: favour sigaction over signal and
	  waitpid over wait3

	 misc.c, misc.h, realbo.c, Makefile.am, fakebo.c: move of more 
	  functions to misc.

* Tue May 11 1999  kost  <kost@iname.com>

	 realbo.c: added more realbo answers

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 Makefile.am, configure.in, fakebo.c: more advanced signal hadling 
	  (sigaction or signal)

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 fakebo.c: More #ifdef DEBUG

	 bo.h, config.c, fakebo.c, global.h, misc.c: Fixes...

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 fakebo.c: more autoconf usage

	 Makefile.am, bo.h, configure.in, fakebo.c, global.h: Portability, 
	  misc. [broken!]

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 global.h: byte def

* Tue May 11 1999  kost  <kost@iname.com>

	 config.c, global.h, misc.c, misc.h, realbo.c: Splitted long files 
	  to short

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 bo.h, configure.in, fakebo.c: Added check for size of int and 
	  long -- uses the one which has 32 bits

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 realbo.c: realbo: global.h

	 fakebo.c: Fixed recvfrom() bug

	 fakebo.c: select(): EINTR crash

* Tue May 11 1999  kost  <kost@iname.com>

	 realbo.c: Fixed malloc bug (few ifs...)

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 TODO: TODO: make strip

	 README.BeOS: Wordwrap

	 realbo.c: Fixed RealBO even more ;)

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 HACKING: Coding style howto (kind of :-)

	 realbo.c: indent changes

	 fakebo.c: indent changes...

* Tue May 11 1999  kost  <kost@iname.com>

	 fakebo.c, realbo.c: Added more DEBUG #ifdefs. Fixed a pointer 
	  uninitialized.

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 NEWS: finally, a decent NEWS file (for users, developers should 
	  use ChangeLog or rcs2log!)

	 INSTALL, NEWS, acconfig.h, autogen.sh, configure.in, realbo.c:
	  Added support for --enable-debug

* Tue May 11 1999  ravilov  <ravilov@iname.com>

	 fakebo.c, realbo.c: Started fixing weird freezing...
	  [still broken, realbo]

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 README.BeOS: How to use FakeBO and BO client for unix on BeOS

* Tue May 11 1999  kost  <kost@iname.com>

	 TODO: Added more TODO targets

	 bo.h: it now cracks faster (it goes from 0 to 0xFFFF not 0xFFFFFF
	  as before)

* Tue May 11 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 NEWS: Added BeOS success report

	 autogen.sh: typo changes, don't check for libtool (we don't use it)

	 acconfig.h, configure.in, fakebo.c, global.h, NEWS, TODO:
	  Changes to support compiling on BeOS and increase portability

* Mon May 10 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 install-sh: Sorry, I was wrong. install-sh ISN'T needed. My
	  installation had install-sh in parent dir, so it took it from 
	  there :-(

	 install-sh: install-sh is needed for autoconf. automake will add
	  rest of the files when used with switch --add-missing, but this one
	  is needed (?!)

	 configure, install-sh, missing, mkinstalldirs, stamp-h.in, 
	  Makefile.in, aclocal.m4, autogen.sh, config.h.in: this files
	  should be created with autogen.sh (you have to have automake
	  and autoconf installed for that, though!)

* Mon May 10 1999  ravilov  <ravilov@iname.com>

	 ChangeLog, NEWS: Changed `NEWS' file

* Sat May  8 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 .cvsignore: It should ignore things that shouldn't go into cvs now!

* Fri May  5 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 AUTHORS: added CVS: field specifaing CVS login (for tracing changes)

* Thu May  4 1999  Dobrica Pavlinusic  <dpavlin@linux.hr>

	 ChangeLog: announce for CVS

	 COPYING, INSTALL, Makefile.am, Makefile.in, NEWS, aclocal.m4,
	  config.h.in, configure.in, install-sh, missing, mkinstalldirs,
	  stamp-h.in: Import of FakeBO 0.3.4-pre2

* Thu May  4 1999  kost  <kost@iname.com>

	 AUTHORS, ChangeLog, README, bo.h, configure, custom.replies, 
	  fakebo.1, fakebo.c, fakebo.conf, global.h, nb.h, realbo.c:
	  Import of FakeBO 0.3.4-pre2
