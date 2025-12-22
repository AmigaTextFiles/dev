# Generated automatically from Makefile.in by configure.
# Makefile.in generated automatically by automake 1.4 from Makefile.am

# Copyright (C) 1994, 1995-8, 1999 Free Software Foundation, Inc.
# This Makefile.in is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# Copyright (C) 1999, 2000, Lorenzo Bettini <lorenzo.bettini@penteres.it>
#  
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without 
# modifications, as long as this notice is preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


SHELL = /bin/sh

srcdir = .
top_srcdir = ..
prefix = /usr/local
exec_prefix = ${prefix}

bindir = ${exec_prefix}/bin
sbindir = ${exec_prefix}/sbin
libexecdir = ${exec_prefix}/libexec
datadir = ${prefix}/share
sysconfdir = ${prefix}/etc
sharedstatedir = ${prefix}/com
localstatedir = ${prefix}/var
libdir = ${exec_prefix}/lib
infodir = ${prefix}/info
mandir = ${prefix}/man
includedir = ${prefix}/include
oldincludedir = /usr/include

DESTDIR =

pkgdatadir = $(datadir)/cpp2html
pkglibdir = $(libdir)/cpp2html
pkgincludedir = $(includedir)/cpp2html

top_builddir = ..

ACLOCAL = aclocal
AUTOCONF = autoconf
AUTOMAKE = automake
AUTOHEADER = autoheader

INSTALL = /bin/install -c
INSTALL_PROGRAM = ${INSTALL} $(AM_INSTALL_PROGRAM_FLAGS)
INSTALL_DATA = ${INSTALL} -m 644
INSTALL_SCRIPT = ${INSTALL_PROGRAM}
transform = s,x,x,

NORMAL_INSTALL = :
PRE_INSTALL = :
POST_INSTALL = :
NORMAL_UNINSTALL = :
PRE_UNINSTALL = :
POST_UNINSTALL = :
AWK = 
CC = gcc
CXX = c++
EXEEXT = 
GENGETOPT = 
LEX = flex
LFLAGS =  -l -L
MAKEINFO = /LS2/work/Porting/cpp2html-1.1/missing makeinfo
PACKAGE = cpp2html
TAR = /bin/tar
TXTC = $(SHELL) $(top_builddir)/txtc.sh
VERSION = 1.1
YACC = bison -y
YFLAGS =  -d -o y.tab.c -l
cpp2htmldatadir = ${prefix}/share/cpp2html
cpp2htmldocdir = ${prefix}/share/doc/cpp2html

PROGNAME = $(top_builddir)/src/cpp2html$(EXEEXT)

SUFFIXES = .stamp .text .cc.html .c.html .ggo

bin_PROGRAMS = cpp2html

cpp2html_SOURCES = copyright.text                     cmdline.c main.cc generators.cc tags.cc messages.cc                     optparser.yy                     optscanner.ll scanner.ll                     optparser.stamp optscanner.stamp 


# EXTRA_cpp2html_SOURCES = yywrap.c
# EXTRA_cpp2html_SOURCES = getopt.c getopt1.c

cpp2html_LDADD =  getopt.o getopt1.o -lfl

EXTRA_DIST = main.h colors.h decorators.h generators.h                     keys.h list.h optparser.h tags.h textgen.h                     tokens.h version.h messages.h copyright.h helptext.h                     cmdline.h                     getopt.h                     options_defs.sed                     cmdline.ggo                     tags.j2h                     header.html footer.html                     main.cc.html generators.cc.html tags.cc.html                     messages.cc.html cmdline.c.html                     cpp2html.css mono.css mono-alt.css                     main.h.html decorators.h.html                     generators.h.html                     list.h.html tags.h.html cmdline.h.html


BUILT_SOURCES = optparser.stamp optscanner.stamp

cpp2htmldata_DATA = tags.j2h 

cpp2htmldoc_DATA = main.cc.html generators.cc.html tags.cc.html                    messages.cc.html cmdline.c.html                    main.h.html decorators.h.html                    generators.h.html                    list.h.html tags.h.html cmdline.h.html                    cpp2html.css mono.css mono-alt.css                    header.html footer.html


# because sources are C++
ETAGS_ARGS = -C

MAINTAINERCLEANFILES = optparser.cc optparser.h optscanner.cc scanner.cc                    main.cc.html generators.cc.html tags.cc.html                    messages.cc.html cmdline.c.html                    main.h.html decorators.h.html                    generators.h.html                    list.h.html tags.h.html cmdline.h.html

mkinstalldirs = $(SHELL) $(top_srcdir)/mkinstalldirs
CONFIG_HEADER = ../config.h
CONFIG_CLEAN_FILES = 
bin_PROGRAMS =  cpp2html$(EXEEXT)
PROGRAMS =  $(bin_PROGRAMS)


DEFS = -DHAVE_CONFIG_H -I. -I$(srcdir) -I..
CPPFLAGS =  
LDFLAGS = 
LIBS = -lfl 
cpp2html_OBJECTS =  cmdline.o main.o generators.o tags.o \
messages.o optparser.o optscanner.o scanner.o
cpp2html_DEPENDENCIES =   getopt.o getopt1.o
cpp2html_LDFLAGS = 
CXXFLAGS = -DCPP2HTML_DATA_DIR=\"${prefix}/share/cpp2html\" -g -O2
CXXCOMPILE = $(CXX) $(DEFS) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CXXFLAGS) $(CXXFLAGS)
CXXLD = $(CXX)
CXXLINK = $(CXXLD) $(AM_CXXFLAGS) $(CXXFLAGS) $(LDFLAGS) -o $@
LEX_OUTPUT_ROOT = lex.yy
LEXLIB = -lfl
YLWRAP = $(srcdir)/ylwrap
CFLAGS = -g -O2
COMPILE = $(CC) $(DEFS) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CFLAGS) $(CFLAGS)
CCLD = $(CC)
LINK = $(CCLD) $(AM_CFLAGS) $(CFLAGS) $(LDFLAGS) -o $@
DATA =  $(cpp2htmldata_DATA) $(cpp2htmldoc_DATA)

DIST_COMMON =  Makefile.am Makefile.in getopt.c getopt1.c optparser.cc \
optscanner.cc scanner.cc ylwrap yywrap.c


DISTFILES = $(DIST_COMMON) $(SOURCES) $(HEADERS) $(TEXINFOS) $(EXTRA_DIST)

GZIP_ENV = --best
SOURCES = $(cpp2html_SOURCES)
OBJECTS = $(cpp2html_OBJECTS)

all: all-redirect
.SUFFIXES:
.SUFFIXES: .S .c .c.html .cc .cc.html .ggo .ll .o .s .stamp .text .yy
$(srcdir)/Makefile.in: Makefile.am $(top_srcdir)/configure.in $(ACLOCAL_M4) 
	cd $(top_srcdir) && $(AUTOMAKE) --gnu --include-deps src/Makefile

Makefile: $(srcdir)/Makefile.in  $(top_builddir)/config.status
	cd $(top_builddir) \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status


mostlyclean-binPROGRAMS:

clean-binPROGRAMS:
	-test -z "$(bin_PROGRAMS)" || rm -f $(bin_PROGRAMS)

distclean-binPROGRAMS:

maintainer-clean-binPROGRAMS:

install-binPROGRAMS: $(bin_PROGRAMS)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(bindir)
	@list='$(bin_PROGRAMS)'; for p in $$list; do \
	  if test -f $$p; then \
	    echo "  $(INSTALL_PROGRAM) $$p $(DESTDIR)$(bindir)/`echo $$p|sed 's/$(EXEEXT)$$//'|sed '$(transform)'|sed 's/$$/$(EXEEXT)/'`"; \
	     $(INSTALL_PROGRAM) $$p $(DESTDIR)$(bindir)/`echo $$p|sed 's/$(EXEEXT)$$//'|sed '$(transform)'|sed 's/$$/$(EXEEXT)/'`; \
	  else :; fi; \
	done

uninstall-binPROGRAMS:
	@$(NORMAL_UNINSTALL)
	list='$(bin_PROGRAMS)'; for p in $$list; do \
	  rm -f $(DESTDIR)$(bindir)/`echo $$p|sed 's/$(EXEEXT)$$//'|sed '$(transform)'|sed 's/$$/$(EXEEXT)/'`; \
	done

.c.o:
	$(COMPILE) -c $<

.s.o:
	$(COMPILE) -c $<

.S.o:
	$(COMPILE) -c $<

mostlyclean-compile:
	-rm -f *.o core *.core

clean-compile:

distclean-compile:
	-rm -f *.tab.c

maintainer-clean-compile:

cpp2html$(EXEEXT): $(cpp2html_OBJECTS) $(cpp2html_DEPENDENCIES)
	@rm -f cpp2html$(EXEEXT)
	$(CXXLINK) $(cpp2html_LDFLAGS) $(cpp2html_OBJECTS) $(cpp2html_LDADD) $(LIBS)
.cc.o:
	$(CXXCOMPILE) -c $<
.ll.cc:
	$(SHELL) $(YLWRAP) "$(LEX)" $< $(LEX_OUTPUT_ROOT).c $@ -- $(AM_LFLAGS) $(LFLAGS)
.yy.cc:
	$(YACC) $(AM_YFLAGS) $(YFLAGS) $< && mv y.tab.c $*.cc
	if test -f y.tab.h; then \
	if cmp -s y.tab.h $*.h; then rm -f y.tab.h; else mv y.tab.h $*.h; fi; \
	else :; fi
optparser.hh: optparser.cc


install-cpp2htmldataDATA: $(cpp2htmldata_DATA)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(cpp2htmldatadir)
	@list='$(cpp2htmldata_DATA)'; for p in $$list; do \
	  if test -f $(srcdir)/$$p; then \
	    echo " $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(cpp2htmldatadir)/$$p"; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(cpp2htmldatadir)/$$p; \
	  else if test -f $$p; then \
	    echo " $(INSTALL_DATA) $$p $(DESTDIR)$(cpp2htmldatadir)/$$p"; \
	    $(INSTALL_DATA) $$p $(DESTDIR)$(cpp2htmldatadir)/$$p; \
	  fi; fi; \
	done

uninstall-cpp2htmldataDATA:
	@$(NORMAL_UNINSTALL)
	list='$(cpp2htmldata_DATA)'; for p in $$list; do \
	  rm -f $(DESTDIR)$(cpp2htmldatadir)/$$p; \
	done

install-cpp2htmldocDATA: $(cpp2htmldoc_DATA)
	@$(NORMAL_INSTALL)
	$(mkinstalldirs) $(DESTDIR)$(cpp2htmldocdir)
	@list='$(cpp2htmldoc_DATA)'; for p in $$list; do \
	  if test -f $(srcdir)/$$p; then \
	    echo " $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(cpp2htmldocdir)/$$p"; \
	    $(INSTALL_DATA) $(srcdir)/$$p $(DESTDIR)$(cpp2htmldocdir)/$$p; \
	  else if test -f $$p; then \
	    echo " $(INSTALL_DATA) $$p $(DESTDIR)$(cpp2htmldocdir)/$$p"; \
	    $(INSTALL_DATA) $$p $(DESTDIR)$(cpp2htmldocdir)/$$p; \
	  fi; fi; \
	done

uninstall-cpp2htmldocDATA:
	@$(NORMAL_UNINSTALL)
	list='$(cpp2htmldoc_DATA)'; for p in $$list; do \
	  rm -f $(DESTDIR)$(cpp2htmldocdir)/$$p; \
	done

tags: TAGS

ID: $(HEADERS) $(SOURCES) $(LISP)
	list='$(SOURCES) $(HEADERS)'; \
	unique=`for i in $$list; do echo $$i; done | \
	  awk '    { files[$$0] = 1; } \
	       END { for (i in files) print i; }'`; \
	here=`pwd` && cd $(srcdir) \
	  && mkid -f$$here/ID $$unique $(LISP)

TAGS:  $(HEADERS) $(SOURCES)  $(TAGS_DEPENDENCIES) $(LISP)
	tags=; \
	here=`pwd`; \
	list='$(SOURCES) $(HEADERS)'; \
	unique=`for i in $$list; do echo $$i; done | \
	  awk '    { files[$$0] = 1; } \
	       END { for (i in files) print i; }'`; \
	test -z "$(ETAGS_ARGS)$$unique$(LISP)$$tags" \
	  || (cd $(srcdir) && etags $(ETAGS_ARGS) $$tags  $$unique $(LISP) -o $$here/TAGS)

mostlyclean-tags:

clean-tags:

distclean-tags:
	-rm -f TAGS ID

maintainer-clean-tags:

distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)

subdir = src

distdir: $(DISTFILES)
	@for file in $(DISTFILES); do \
	  d=$(srcdir); \
	  if test -d $$d/$$file; then \
	    cp -pr $$/$$file $(distdir)/$$file; \
	  else \
	    test -f $(distdir)/$$file \
	    || ln $$d/$$file $(distdir)/$$file 2> /dev/null \
	    || cp -p $$d/$$file $(distdir)/$$file || :; \
	  fi; \
	done
cmdline.o: cmdline.c ../config.h getopt.h cmdline.h
generators.o: generators.cc textgen.h main.h decorators.h tags.h list.h \
	colors.h keys.h
main.o: main.cc version.h ../config.h main.h colors.h tags.h list.h \
	keys.h textgen.h decorators.h generators.h messages.h cmdline.h \
	copyright.h
messages.o: messages.cc messages.h
optparser.o: optparser.cc ../config.h tags.h list.h colors.h keys.h \
	messages.h
optscanner.o: optscanner.cc getopt.h tags.h list.h colors.h tokens.h \
	optparser.h
scanner.o: scanner.cc getopt.h tags.h list.h colors.h tokens.h main.h
tags.o: tags.cc tags.h list.h colors.h keys.h

info-am:
info: info-am
dvi-am:
dvi: dvi-am
check-am: all-am
check: check-am
installcheck-am:
installcheck: installcheck-am
install-exec-am: install-binPROGRAMS
install-exec: install-exec-am

install-data-am: install-cpp2htmldataDATA install-cpp2htmldocDATA
install-data: install-data-am

install-am: all-am
	@$(MAKE) $(AM_MAKEFLAGS) install-exec-am install-data-am
install: install-am
uninstall-am: uninstall-binPROGRAMS uninstall-cpp2htmldataDATA \
		uninstall-cpp2htmldocDATA
uninstall: uninstall-am
all-am: Makefile $(PROGRAMS) $(DATA)
all-redirect: all-am
install-strip:
	$(MAKE) $(AM_MAKEFLAGS) AM_INSTALL_PROGRAM_FLAGS=-s install
installdirs:
	$(mkinstalldirs)  $(DESTDIR)$(bindir) $(DESTDIR)$(cpp2htmldatadir) \
		$(DESTDIR)$(cpp2htmldocdir)


mostlyclean-generic:

clean-generic:

distclean-generic:
	-rm -f Makefile $(CONFIG_CLEAN_FILES)
	-rm -f config.cache config.log stamp-h stamp-h[0-9]*

maintainer-clean-generic:
	-test -z "optscannerllscannerlloptparserhhoptparsercc$(BUILT_SOURCES)$(MAINTAINERCLEANFILES)" || rm -f optscannerll scannerll optparserhh optparsercc $(BUILT_SOURCES) $(MAINTAINERCLEANFILES)
mostlyclean-am:  mostlyclean-binPROGRAMS mostlyclean-compile \
		mostlyclean-tags mostlyclean-generic

mostlyclean: mostlyclean-am

clean-am:  clean-binPROGRAMS clean-compile clean-tags clean-generic \
		mostlyclean-am

clean: clean-am

distclean-am:  distclean-binPROGRAMS distclean-compile distclean-tags \
		distclean-generic clean-am

distclean: distclean-am

maintainer-clean-am:  maintainer-clean-binPROGRAMS \
		maintainer-clean-compile maintainer-clean-tags \
		maintainer-clean-generic distclean-am
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."

maintainer-clean: maintainer-clean-am

.PHONY: mostlyclean-binPROGRAMS distclean-binPROGRAMS clean-binPROGRAMS \
maintainer-clean-binPROGRAMS uninstall-binPROGRAMS install-binPROGRAMS \
mostlyclean-compile distclean-compile clean-compile \
maintainer-clean-compile uninstall-cpp2htmldataDATA \
install-cpp2htmldataDATA uninstall-cpp2htmldocDATA \
install-cpp2htmldocDATA tags mostlyclean-tags distclean-tags clean-tags \
maintainer-clean-tags distdir info-am info dvi-am dvi check check-am \
installcheck-am installcheck install-exec-am install-exec \
install-data-am install-data install-am install uninstall-am uninstall \
all-redirect all-am all installdirs mostlyclean-generic \
distclean-generic clean-generic maintainer-clean-generic clean \
mostlyclean distclean maintainer-clean


.cc.stamp:
	sed -f $(srcdir)/options_defs.sed $< > __temp.cc
	cp -f __temp.cc $<
	rm -f __temp.cc
	if test -f $*.h ; then \
	sed -f $(srcdir)/options_defs.sed $*.h > __temp.h ;\
	cp -f __temp.h $*.h ;\
	rm -f __temp.h ;\
	else :; fi
	echo timestamp > $@

.text.o:
	$(TXTC) $<

.cc.cc.html:
	$(PROGNAME) --doc $<

.c.c.html:
	$(PROGNAME) -i $< -o $@ --css="cpp2html.css" --header="$(srcdir)/header.html" --footer="$(srcdir)/footer.html"

.ggo.c:
	touch $@
#.ggo.c:
#	$(GENGETOPT) --input $< --unamed-opts

%.h.html: %.h
	$(PROGNAME) < $< > $@ --css="mono.css"

html-clean:
	rm -f *.html

# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
