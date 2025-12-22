# Copyright (C) 1999, 2000, Lorenzo Bettini <lorenzo.bettini@penteres.it>
#  
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without 
# modifications, as long as this notice is preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

PROGNAME = $(top_builddir)/src/cpp2html$(EXEEXT)

SUFFIXES = .stamp .text .cc.html .c.html .ggo

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

if NO_GENGETOPT
.ggo.c:
	touch $@
else
.ggo.c:
	$(GENGETOPT) --input $< --unamed-opts
endif

%.h.html: %.h
	$(PROGNAME) < $< > $@ --css="mono.css"

bin_PROGRAMS = cpp2html

cpp2html_SOURCES = copyright.text \
                    cmdline.c main.cc generators.cc tags.cc messages.cc \
                    optparser.yy \
                    optscanner.ll scanner.ll \
                    optparser.stamp optscanner.stamp 

# EXTRA_cpp2html_SOURCES = yywrap.c
# EXTRA_cpp2html_SOURCES = getopt.c getopt1.c

cpp2html_LDADD = @LIBOBJS@ @LEXLIB@

EXTRA_DIST =        main.h colors.h decorators.h generators.h \
                    keys.h list.h optparser.h tags.h textgen.h \
                    tokens.h version.h messages.h copyright.h helptext.h \
                    cmdline.h \
                    getopt.h \
                    options_defs.sed \
                    cmdline.ggo \
                    tags.j2h \
                    header.html footer.html \
                    main.cc.html generators.cc.html tags.cc.html \
                    messages.cc.html cmdline.c.html \
                    cpp2html.css mono.css mono-alt.css \
                    main.h.html decorators.h.html \
                    generators.h.html \
                    list.h.html tags.h.html cmdline.h.html

BUILT_SOURCES = optparser.stamp optscanner.stamp

cpp2htmldata_DATA = tags.j2h 

cpp2htmldoc_DATA = main.cc.html generators.cc.html tags.cc.html \
                   messages.cc.html cmdline.c.html \
                   main.h.html decorators.h.html \
                   generators.h.html \
                   list.h.html tags.h.html cmdline.h.html \
                   cpp2html.css mono.css mono-alt.css \
                   header.html footer.html

# because sources are C++
ETAGS_ARGS = -C

MAINTAINERCLEANFILES = optparser.cc optparser.h optscanner.cc scanner.cc \
                   main.cc.html generators.cc.html tags.cc.html \
                   messages.cc.html cmdline.c.html \
                   main.h.html decorators.h.html \
                   generators.h.html \
                   list.h.html tags.h.html cmdline.h.html

html-clean:
	rm -f *.html
