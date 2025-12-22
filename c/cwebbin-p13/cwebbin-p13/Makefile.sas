# This file, makefile.sas, is part of CWEBBIN (Version 3.4 [p13]).
# It is distributed WITHOUT ANY WARRANTY, express or implied.
#
# Modified for SAS/C 6.55 under AmigaOS 2.1 on an AMIGA 2000 by
# <scherer@genesis.informatik.rwth-aachen.de>, March 1993
# Last updated by Andreas Scherer, September 19, 1995

# Copyright (C) 1987,1990,1993 Silvio Levy and Donald E. Knuth
#
# The following copyright notice extends to this Amiga Makefile only,
# not to any part of the original CWEB distribution.
#
# Copyright (C) 1993 Andreas Scherer

# Permission is granted to make and distribute verbatim copies of this
# document provided that the copyright notice and this permission notice
# are preserved on all copies.

# Permission is granted to copy and distribute modified versions of this
# document under the conditions for verbatim copying, provided that the
# entire resulting derived work is distributed under the terms of a
# permission notice identical to this one.

# 
# Read the README file, then edit this file to reflect local conditions
#

# directory for TeX inputs (cwebmac.tex and (X|d|f|i)cwebmac.tex and
# the 8-bit encodings go here)
MACROSDIR = TeXMF:tex/plain/cweb
# ((d|f|i)cweb.sty go here)
LMACROSDIR = TeXMF:tex/latex/cweb

# directory for CWEB inputs in @i files
CWEBINPUTS = Local:cwebinputs

# extension for manual pages ("l" distinguishes local from system stuff)
MANEXT = l
#MANEXT = 1

# directory for manual pages (cweb.1 goes here)
MANDIR =

# destination directory for executables; must end in /
DESTDIR = Local:bin/

# directory for GNU EMACS Lips code (cweb.el goes here)
EMACSDIR = s:

# directory for language catalogs with message texts of the script file
CATDIR = Locale:catalogs/

# directory for the language header file "cweb.h"
CATINCLUDE = bin/catalogs/

# Set DESTPREF to null if you want to call the executables "tangle" and "weave"
# (probably NOT a good idea; we recommend leaving DESTPREF = c)
DESTPREF = c

# Set CCHANGES to comm-foo.ch if you need changes to common.w
CCHANGES = comm-p13.ch

# Set HCHANGES to comm-foo.hch if you need changes to common.h
HCHANGES = comm-p13.hch

# Set HPATCH to comm-foo.h if you apply changes to common.h
# default should be common.h
HPATCH = comm-p13.h

# Set TCHANGES to ctang-foo.ch if you need changes to ctangle.w
TCHANGES = ctang-p13.ch

# Set WCHANGES to cweav-foo.ch if you need changes to cweave.w
WCHANGES = cweav-p13.ch

# Set MCHANGES to wmerge-foo.ch if you need changes to wmerge.w
MCHANGES = wmerg-p13.ch

# Set EXTENSION to either `c' if you want to treat CWEB as a system
# of ordinary ANSI-C programs, or to `cc', `cxx', `cpp' or similar
# if you want to treat CWEB as a system of C++ programs.  Your
# compiler should be able to distinguish between the two forms
# according to the source file extension.  Even with ANSI-C programs
# it is strongly recommended to use C++ compilers, because of the
# much stricter checking of type conversions and module interfaces.
# For highest portability, all of the extra features of C++ are
# avoided in the CWEB system, thus using something like C--.
EXTENSION = cxx

# These lists of arguments are specific for SC and SLINK.
# Change, add or delete things here to suit your personal conditions.
OBJS = LIB:cres.o
LIBS = LIB:sc.lib
CFLAGS = CPU=ANY INCLUDEDIR=$(CATINCLUDE) DEFINE=_DEV_NULL="NIL:" \
	DEFINE=_STRICT_ANSI DEFINE=CWEBINPUTS="$(CWEBINPUTS)" \
	DEFINE=SEPARATORS=",/:" NOSTACKCHECK NOICONS VERBOSE \
	IGNORE=304+1597 OPTIMIZE
LINKFLAGS = VERBOSE NOICONS STRIPDEBUG LIB $(LIBS) FROM $(OBJS)

# The `f' flag is turned off to save paper
# The `lX' flag includes Xcwebmac.tex
# The `s' flag displays some statistics
WFLAGS = -f +lX +s
TFLAGS = +s

# What C compiler are you using?
CC = SC
LINK = SLink
MAKE = SMake

# RM and CP are used below in case rm and cp are aliased
RM = delete
CP = copy
INSTALL = copy

##########  You shouldn't have to change anything after this point #######

CWEAVE = cweave
CTANGLE = ctangle
WMERGE = wmerge

# The following files come from the original CWEB distribution and
# are completely unmodified.

SOURCES = common.w common.h ctangle.w cweave.w prod.w examples/wmerge.w

ORIGINAL = $(SOURCES) comm-amiga.ch comm-bs.ch comm-man.ch comm-pc.ch \
	comm-vms.ch common.c ctang-bs.ch ctang-man.ch ctang-pc.ch \
	ctang-vms.ch ctangle.c cweav-bs.ch cweav-man.ch cweav-pc.ch \
	cweav-vms.ch cweb.1 cweb.el cwebmac.tex cwebman.tex Makefile \
	Makefile.bs README comm-os2.ch \
        examples/extex.w examples/kspell.el examples/Makefile \
	examples/oemacs.el examples/oemacs.w examples/README \
	examples/treeprint.w examples/wc.w examples/wc-dos.ch \
	examples/wmerg-pc.ch examples/wmerge.w~ examples/wordtest.w \
	examples/xlib_types.w examples/xview_types.w

# The following files make the body of this patched distribution
# of CWEB.

PATCH = $(CCHANGES) $(HCHANGES) $(HPATCH) $(TCHANGES) $(WCHANGES) \
	$(MCHANGES) common.$(EXTENSION) ctangle.$(EXTENSION) \
	wmerge.$(EXTENSION) cwebmana.ch README.p13 \
	Makefile.bcc Makefile.sas Makefile.unix

AREXX = arexx/\#?

BIN = bin/\#?

EXAMPLES = examples/cct.w examples/commonwords.w examples/extex.ch \
	examples/Makefile.sas examples/matrix.wxx examples/primes.ch \
	examples/primes.w examples/README.p11 examples/sample.w \
	examples/treeprint.ch examples/wc.ch examples/wordtest.ch

INCLUDE = cwebinputs/\#?

MACROS = texinputs/\#?

ALL = $(ORIGINAL) $(PATCH) $(AREXX) $(BIN) $(EXAMPLES) $(INCLUDE) $(MACROS)

.SUFFIXES: .dvi .tex .w

.w.tex:
	$(CWEAVE) $(WFLAGS) $* $*

.tex.dvi:	
	virtex &plain "\\language=\\USenglish \\input " $<

.w.dvi:
	$(MAKE) $*.tex
	$(MAKE) $*.dvi

.$(EXTENSION).o:
	$(CC) $(CFLAGS) $*.$(EXTENSION)

.w.o:
	$(MAKE) $*.$(EXTENSION)
	$(MAKE) $*.o

# When you say `smake' without any arguments, `smake' will jump to this item
default: ctangle cweave

# The complete set of files contains the two programs `ctangle' and
# `cweave' plus the program `wmerge', the manuals `cwebman' and `cwebmana'
# and the source documentations.
all: progs docs

# The objects of desire
progs: ctangle cweave wmerge

cautiously: ctangle
	$(CP) common.$(EXTENSION) SAVEcommon.$(EXTENSION)
	$(CTANGLE) $(TFLAGS) common $(CCHANGES) common.$(EXTENSION)
	diff common.$(EXTENSION) SAVEcommon.$(EXTENSION)
	$(RM) SAVEcommon.$(EXTENSION)
	$(CP) ctangle.$(EXTENSION) SAVEctangle.$(EXTENSION)
	$(CTANGLE) $(TFLAGS) ctangle $(TCHANGES) ctangle.$(EXTENSION)
	diff ctangle.$(EXTENSION) SAVEctangle.$(EXTENSION)
	$(RM) SAVEctangle.$(EXTENSION)

SAVEctangle.$(EXTENSION):
	$(CP) ctangle.$(EXTENSION) SAVEctangle.$(EXTENSION)

SAVEcommon.$(EXTENSION):
	$(CP) common.$(EXTENSION) SAVEcommon.$(EXTENSION)

common.$(EXTENSION): common.w $(CCHANGES)
	$(CTANGLE) $(TFLAGS) common $(CCHANGES) common.$(EXTENSION)

common.o: common.$(EXTENSION) $(CATINCLUDE)cweb.h

ctangle: ctangle.o common.o
	$(LINK) $(LINKFLAGS) common.o ctangle.o TO ctangle

ctangle.$(EXTENSION): ctangle.w $(TCHANGES) $(HPATCH)
	$(CTANGLE) $(TFLAGS) ctangle $(TCHANGES) ctangle.$(EXTENSION)

ctangle.o: ctangle.$(EXTENSION) $(CATINCLUDE)cweb.h $(HPATCH)

cweave: cweave.o common.o
	$(LINK) $(LINKFLAGS) common.o cweave.o TO cweave

cweave.$(EXTENSION): cweave.w $(WCHANGES) $(HPATCH)
	$(CTANGLE) $(TFLAGS) cweave $(WCHANGES) cweave.$(EXTENSION)

cweave.o: cweave.$(EXTENSION) $(CATINCLUDE)cweb.h $(HPATCH)
	$(CC) $(CFLAGS) code=FAR cweave.$(EXTENSION)

wmerge: wmerge.o
	$(LINK) $(LINKFLAGS) wmerge.o TO wmerge

wmerge.o: wmerge.$(EXTENSION)
	$(CC) $(CFLAGS) wmerge.$(EXTENSION)

wmerge.$(EXTENSION): examples/wmerge.w $(MCHANGES)
	$(CTANGLE) $(TFLAGS) examples/wmerge $(MCHANGES) wmerge.$(EXTENSION)

# Take a good lecture for bedtime reading
docs: cwebman.dvi cwebmana.dvi common.dvi ctangle.dvi cweave.dvi wmerge.dvi

cwebman.dvi: cwebman.tex
cwebmana.dvi: cwebmana.tex
common.dvi: common.tex
ctangle.dvi: ctangle.tex
cweave.dvi: cweave.tex
wmerge.dvi: wmerge.tex

usermanual: cwebmana.dvi

fullmanual: usermanual $(SOURCES) comm-man.ch ctang-man.ch cweav-man.ch
	$(MAKE) cweave
	$(CWEAVE) common.w comm-man.ch
	$(MAKE) common.dvi
	$(CWEAVE) ctangle.w ctang-man.ch
	$(MAKE) ctangle.dvi
	$(CWEAVE) cweave.w cweav-man.ch
	$(MAKE) cweave.dvi
	$(CWEAVE) examples/wmerge.w
	$(MAKE) wmerge.dvi

cwebmana.tex: cwebman.tex cwebmana.ch
	$(WMERGE) cwebman.tex cwebmana.ch cwebmana.tex

# for making the documentation we will have to include the change files
ctangle.tex: ctangle.w $(HPATCH) $(TCHANGES)
	$(CWEAVE) $(WFLAGS) ctangle $(TCHANGES)

cweave.tex: cweave.w $(HPATCH) $(WCHANGES)
	$(CWEAVE) $(WFLAGS) cweave $(WCHANGES)

common.tex: common.w $(CCHANGES)
	$(CWEAVE) $(WFLAGS) common $(CCHANGES)

wmerge.tex: examples/wmerge.w $(MCHANGES)
	$(CWEAVE) $(WFLAGS) examples/wmerge $(MCHANGES)

# be sure to leave ctangle.$(EXTENSION) and common.$(EXTENSION)
# and $(HPATCH) for bootstrapping
clean:
	- $(RM) \#?.(o|lnk|bak|log|dvi|toc|idx|scn)
	- $(RM) common.tex cweave.tex cweave.$(EXTENSION) ctangle.tex
	- $(RM) cweave ctangle cwebmana.tex wmerge.tex wmerge

# Install the new program versions where they can be found
install: progs
	$(INSTALL) cweave $(DESTDIR)$(DESTPREF)weave
	$(INSTALL) ctangle $(DESTDIR)$(DESTPREF)tangle
	$(INSTALL) wmerge $(DESTDIR)wmerge
	$(INSTALL) cwebmac.tex $(MACROSDIR)
	$(INSTALL) texinputs/?cwebmac.tex $(MACROSDIR)
	$(INSTALL) texinputs/(ecma94|hp8|mac8|pc850).sty $(MACROSDIR)
	$(INSTALL) texinputs/?cweb.sty $(LMACROSDIR)
	$(INSTALL) cwebinputs/\#? $(CWEBINPUTS)

# Make a shipable archive
cweb.lha:
	lha -x -r -a u $@ $(ALL)
cwebpatch.lha:
	lha -x -r -a u $@ $(PATCH)
	lha -x -r -a u $@ $(AREXX)
	lha -x -r -a u $@ $(BIN)
	lha -x -r -a u $@ $(EXAMPLES)
	lha -x -r -a u $@ $(INCLUDE)
	lha -x -r -a u $@ $(MACROS)
cweborig.lha:
	lha -x -r -a u $@ $(ORIGINAL)

cweb.tar.gz:
	tar cvf cweb.tar $(ALL)
	gzip cweb.tar

# Remove the patch completely
remove: clean
	- $(RM) $(CCHANGES) $(HCHANGES) $(HPATCH) $(TCHANGES) $(WCHANGES) $(MCHANGES)
	- $(RM) common.$(EXTENSION) ctangle.$(EXTENSION) wmerge.$(EXTENSION)
	- $(RM) cwebmana.ch README.p13
	- $(RM) Makefile.bcc Makefile.sas Makefile.unix
	- $(RM) arexx bin all
	- $(RM) examples/cct.w examples/commonwords.w examples/extex.ch
	- $(RM) examples/Makefile.sas examples/matrix.wxx examples/primes.ch
	- $(RM) examples/primes.w examples/README.p11 examples/sample.w
	- $(RM) examples/treeprint.ch examples/wc.ch examples/wordtest.ch
	- $(RM) cwebinputs texinputs all

# End of Makefile.sas
