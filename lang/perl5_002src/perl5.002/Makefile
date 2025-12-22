# Makefile.SH
# This file is derived from Makefile.SH.  Any changes made here will
# be lost the next time you run Configure.
#  Makefile is used to generate GNUmakefile.  The only difference
#  is that GNUmakefile has the dependencies filled in at the end.
#
#
# I now supply perly.c with the kits, so don't remake perly.c without byacc
BYACC = byacc
CC = gcc
LD = ld

LDFLAGS = -s
CLDFLAGS = -s

SMALL = 
LARGE =  
mallocsrc = 
mallocobj = 
LNS = /bin/ln -s
RMS = rm -f
ranlib = :

# The following are mentioned only to make metaconfig include the
# appropriate questions in Configure.  If you want to change these,
# edit config.sh instead, or specify --man1dir=/wherever on
# installman commandline.
bin = /gnu/bin
scriptdir = /gnu/bin
privlib = /gnu/lib/perl5
man1dir =  
man1ext = 0
man3dir =  
man3ext = 0

# The following are used to build and install shared libraries for
# dynamic loading.
LDDLFLAGS = 
CCDLFLAGS = 
DLSUFFIX = .none
PLDLFLAGS = 
PLIBSUF = .a
SHRPENV = 

dynamic_ext =  
static_ext =   lib/auto/Fcntl/Fcntl.a lib/auto/FileHandle/FileHandle.a lib/auto/Safe/Safe.a lib/auto/GDBM_File/GDBM_File.a lib/auto/SDBM_File/SDBM_File.a
ext = $(dynamic_ext) $(static_ext)
static_ext_autoinit =  
DYNALOADER = lib/auto/DynaLoader/DynaLoader.a


libs = -lnet -lgdbm -lsdbm -lm -lc 

public = perl  utilities translators

shellflags = 

## To use an alternate make, set $altmake in config.sh.
MAKE = make

# These variables will be used in a future version to make
# the make file more portable to non-unix systems.
AR = ar
EXE_EXT = 
LIB_EXT = .a
OBJ_EXT = .o
PATH_SEP = :

FIRSTMAKEFILE = GNUmakefile

# Any special object files needed by this architecture, e.g. os2/os2.obj
ARCHOBJS = 


CCCMD = `sh $(shellflags) cflags $(perllib) $@`

private = preplibrary lib/ExtUtils/Miniperl.pm lib/Config.pm

# Files to be built with variable substitution before miniperl
# is available.
sh = Makefile.SH cflags.SH config_h.SH makeaperl.SH makedepend.SH \
	makedir.SH perl_exp.SH writemain.SH

shextract = Makefile cflags config.h makeaperl makedepend \
	makedir perl_exp writemain

# Files to be built with variable substitution after miniperl is
# available.  Dependencies handled manually below (for now).

pl = pod/pod2html.PL pod/pod2latex.PL pod/pod2man.PL pod/pod2text.PL

plextract = pod/pod2html pod/pod2latex pod/pod2man pod/pod2text

addedbyconf = UU $(shextract) $(plextract) pstruct

h1 = EXTERN.h INTERN.h XSUB.h av.h config.h cop.h cv.h dosish.h
h2 = embed.h form.h gv.h handy.h hv.h keywords.h mg.h op.h
h3 = opcode.h patchlevel.h perl.h perly.h pp.h proto.h regcomp.h
h4 = regexp.h scope.h sv.h unixish.h util.h
h = $(h1) $(h2) $(h3) $(h4)

c1 = $(mallocsrc) av.c scope.c op.c doop.c doio.c dump.c hv.c mg.c
c2 = perl.c perly.c pp.c pp_hot.c pp_ctl.c pp_sys.c regcomp.c regexec.c
c3 = gv.c sv.c taint.c toke.c util.c deb.c run.c globals.c

c = $(c1) $(c2) $(c3) miniperlmain.c perlmain.c

obj1 = $(mallocobj) gv.o toke.o perly.o op.o regcomp.o dump.o util.o mg.o
obj2 = hv.o av.o run.o pp_hot.o sv.o pp.o scope.o pp_ctl.o pp_sys.o
obj3 = doop.o doio.o regexec.o taint.o deb.o globals.o


obj = $(obj1) $(obj2) $(obj3) $(ARCHOBJS)

# Once perl has been Configure'd and built ok you build different
# perl variants (Debugging, Embedded, Multiplicity etc) by saying:
#	make clean; make perllib=libperl<type>.a
# where <type> is some combination of 'd' and(or) 'e' or 'm'.
# See cflags to understand how this works.
#
# Eventually some form of 'make-a-perl' script will automate this
# together with linking a perl executable with any desired
# static modules.
perllib = libperl$(PLIBSUF)

lintflags = -hbvxac

# grrr
SHELL = /bin/sh

.c.o:
	$(CCCMD) $(PLDLFLAGS) $*.c

all: GNUmakefile miniperl $(private) $(plextract) $(public) $(dynamic_ext)
	@echo " "; echo "	Everything is up to date."

translators:	miniperl lib/Config.pm FORCE
	@echo " "; echo "	Making x2p stuff"; cd x2p; $(MAKE) all

utilities:	miniperl lib/Config.pm FORCE
	@echo " "; echo "	Making utilities"; cd utils; $(MAKE) all


# This is now done by installman only if you actually want the man pages.
#	@echo " "; echo "	Making docs"; cd pod; $(MAKE) all;

# Phony target to force checking subdirectories.
# Apparently some makes require an action for the FORCE target.
FORCE:
	@sh -c true

# The $& notation tells Sequent machines that it can do a parallel make,
# and is harmless otherwise.
# The miniperl -w -MExporter line is a basic cheap test to catch errors
# before make goes on to run preplibrary and then MakeMaker on extensions.
# This is very handy because later errors are often caused by miniperl
# build problems but that's not obvious to the novice.
# The Module used here must not depend on Config or any extensions.

miniperl: $& miniperlmain.o $(perllib)
	$(CC) $(LARGE) $(CLDFLAGS) -o miniperl miniperlmain.o $(perllib) $(libs)
	@./miniperl -w -Ilib -MExporter -e 0 || $(MAKE) minitest

miniperlmain.o: miniperlmain.c
	$(CCCMD) $(PLDLFLAGS) $*.c

perlmain.c: miniperlmain.c config.sh GNUmakefile $(static_ext_autoinit)
	sh writemain $(DYNALOADER) $(static_ext) > tmp
	sh mv-if-diff tmp perlmain.c

perlmain.o: perlmain.c
	$(CCCMD) $(PLDLFLAGS) $*.c

# The file ext.libs is a list of libraries that must be linked in
# for static extensions, e.g. -lm -lgdbm, etc.  The individual
# static extension Makefile's add to it.
ext.libs: $(static_ext)
	-@test -f ext.libs || touch ext.libs

perl: $& perlmain.o $(perllib) $(DYNALOADER) $(static_ext) ext.libs
	$(SHRPENV) $(CC) $(LARGE) $(CLDFLAGS) $(CCDLFLAGS) -o perl perlmain.o $(perllib) $(DYNALOADER) $(static_ext) `cat ext.libs` $(libs)

pureperl: $& perlmain.o $(perllib) $(DYNALOADER) $(static_ext) ext.libs
	purify $(CC) $(LARGE) $(CLDFLAGS) $(CCDLFLAGS) -o pureperl perlmain.o $(perllib) $(DYNALOADER) $(static_ext) `cat ext.libs` $(libs)

quantperl: $& perlmain.o $(perllib) $(DYNALOADER) $(static_ext) ext.libs
	quantify $(CC) $(LARGE) $(CLDFLAGS) $(CCDLFLAGS) -o quantperl perlmain.o $(perllib) $(DYNALOADER) $(static_ext) `cat ext.libs` $(libs)

$(perllib): $& perl.o $(obj)
	rm -f $(perllib)
	$(AR) rcu $(perllib) perl.o $(obj)
	@$(ranlib) $(perllib)

# This version, if specified in Configure, does ONLY those scripts which need
# set-id emulation.  Suidperl must be setuid root.  It contains the "taint"
# checks as well as the special code to validate that the script in question
# has been invoked correctly.

suidperl: $& sperl.o perlmain.o $(perllib) $(DYNALOADER) $(static_ext) ext.libs
	$(CC) $(LARGE) $(CLDFLAGS) $(CCDLFLAGS) -o suidperl perlmain.o sperl.o $(perllib) $(DYNALOADER) $(static_ext) `cat ext.libs` $(libs)

sperl.o: perl.c perly.h patchlevel.h $(h)
	$(RMS) sperl.c
	$(LNS) perl.c sperl.c
	$(CCCMD) -DIAMSUID sperl.c
	$(RMS) sperl.c

# We have to call our ./makedir because Ultrix 4.3 make can't handle the line
#	test -d lib/auto || mkdir lib/auto
#
preplibrary: miniperl lib/Config.pm $(plextract)
	@./makedir lib/auto
	@echo "	AutoSplitting perl library"
	@./miniperl -Ilib -e 'use AutoSplit; \
		autosplit_lib_modules(@ARGV)' lib/*.pm lib/*/*.pm

# Take care to avoid modifying lib/Config.pm without reason
lib/Config.pm: config.sh miniperl
	./miniperl configpm tmp
	sh mv-if-diff tmp lib/Config.pm

lib/ExtUtils/Miniperl.pm: miniperlmain.c miniperl minimod.pl lib/Config.pm
	./miniperl minimod.pl > tmp && mv tmp $@

$(plextract):	miniperl lib/Config.pm
	./miniperl -Ilib $@.PL

install: all install.perl install.man

install.perl:	all
	./perl installperl

install.man:	all
	./perl installman

# Not implemented yet.
#install.html:	all
#	./perl installhtml

# I now supply perly.c with the kits, so the following section is
# used only if you force byacc to run by saying
# 	make run_byacc
# Since we patch up the byacc output, the perly.fixer script needs
# to run with precisely the same version of byacc as I use.  You
# normally shouldn't remake perly.[ch].

run_byacc:	FORCE
	@ echo 'Expect' 130 shift/reduce and 1 reduce/reduce conflict
	$(BYACC) -d perly.y
	sh $(shellflags) ./perly.fixer y.tab.c perly.c
	mv y.tab.h perly.h
	echo 'extern YYSTYPE yylval;' >>perly.h
	- perl vms/vms_yfix.pl perly.c perly.h vms/perly_c.vms vms/perly_h.vms

# We don't want to regenerate perly.c and perly.h, but they might
# appear out-of-date after a patch is applied or a new distribution is
# made.
perly.c: perly.y
	-@touch perly.c

perly.h: perly.y
	-@touch perly.h

# The following three header files are generated automatically
#	keywords.h:	keywords.pl
#	opcode.h:	opcode.pl
#	embed.h:  	embed.pl global.sym interp.sym
# The correct versions should be already supplied with the perl kit,
# in case you don't have perl available.
# To force them to run, type
#	make regen_headers
regen_headers:	FORCE
	perl keywords.pl
	perl opcode.pl
	perl embed.pl

# Extensions:
# Names added to $(dynamic_ext) or $(static_ext) will automatically
# get built.  There should ordinarily be no need to change any of
# this part of GNUmakefile.
#
# The dummy dependency is a place holder in case $(dynamic_ext) or
# $(static_ext) is empty.
#
# DynaLoader may be needed for extensions that use Makefile.PL.

$(DYNALOADER):	miniperl preplibrary FORCE
	@sh ext/util/make_ext static $@ LIBPERL_A=$(perllib)

d_dummy $(dynamic_ext):	miniperl preplibrary $(DYNALOADER) FORCE
	@sh ext/util/make_ext dynamic $@ LIBPERL_A=$(perllib)

s_dummy $(static_ext):	miniperl preplibrary $(DYNALOADER) FORCE
	@sh ext/util/make_ext static $@ LIBPERL_A=$(perllib)

clean:
	rm -f *.o *.a all perlmain.c
	rm -f perl.exp ext.libs
	-cd pod; $(MAKE) clean
	-cd utils; $(MAKE) clean
	-cd x2p; $(MAKE) clean
	-@for x in $(DYNALOADER) $(dynamic_ext) $(static_ext) ; do \
	sh ext/util/make_ext clean $$x ; \
	done
	rm -f perl suidperl miniperl $(perllib)

realclean: clean
	-cd os2; rm -f Makefile
	-cd pod; $(MAKE) realclean
	-cd utils; $(MAKE) realclean
	-cd x2p; $(MAKE) realclean
	-@for x in $(DYNALOADER) $(dynamic_ext) $(static_ext) ; do \
	sh ext/util/make_ext realclean $$x ; \
	done
	rm -f *.orig */*.orig *~ */*~ core t/core t/c t/perl
	rm -rf $(addedbyconf)
	rm -f GNUmakefile GNUmakefile.old
	rm -f $(private)
	rm -rf lib/auto
	rm -f lib/.exists
	rm -f h2ph.man pstruct
	rm -rf .config
	@echo "Note that make realclean does not delete config.sh"

clobber:	realclean
	rm -f config.sh cppstdin

distclean:	clobber

# The following lint has practically everything turned on.  Unfortunately,
# you have to wade through a lot of mumbo jumbo that can't be suppressed.
# If the source file has a /*NOSTRICT*/ somewhere, ignore the lint message
# for that spot.

lint: perly.c $(c)
	lint $(lintflags) $(defs) perly.c $(c) > perl.fuzz

GNUmakefile:	Makefile
	$(MAKE) depend

config.h: config.sh
	/bin/sh config_h.SH

# When done, touch perlmain.c so that it doesn't get remade each time.
depend: makedepend
	./makedepend
	- test -s perlmain.c && touch perlmain.c
	cd x2p; $(MAKE) depend

test: miniperl perl preplibrary $(dynamic_ext)
	- cd t && chmod +x TEST */*.t
	- cd t && (rm -f perl; $(LNS) ../perl perl) && ./perl TEST </dev/tty

minitest: miniperl
	- cd t && chmod +x TEST */*.t
	- cd t && (rm -f perl; $(LNS) ../miniperl perl) \
		&& ./perl TEST base/*.t comp/*.t cmd/*.t io/*.t op/*.t </dev/tty

clist:	$(c)
	echo $(c) | tr ' ' '\012' >.clist

hlist:  $(h)
	echo $(h) | tr ' ' '\012' >.hlist

shlist: $(sh)
	echo $(sh) | tr ' ' '\012' >.shlist

pllist: $(pl)
	echo $(pl) | tr ' ' '\012' >.pllist

# AUTOMATICALLY GENERATED MAKE DEPENDENCIES--PUT NOTHING BELOW THIS LINE
# If this runs make out of memory, delete /usr/include lines.
