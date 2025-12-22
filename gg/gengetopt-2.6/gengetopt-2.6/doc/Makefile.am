# Copyright (C) 1999, 2000, 2001  Free Software Foundation, Inc.
#  
# This file is part of GNU gengetopt 
#
# GNU gengetopt is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 2, or (at your option) 
# any later version. 
#
# GNU gengetopt is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details. 
#
# You should have received a copy of the GNU General Public License along 
# with gengetopt; see the file COPYING. If not, write to the Free Software 
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 

PROGNAME = $(top_builddir)/src/gengetopt$(EXEEXT)
MAKE_SAMPLES = $(MAKE) $(AM_MAKEFLAGS) $(EXTRA_PROGRAMS)
SAMPLES_STAMP = samples.stamp
GGO_FILES = $(srcdir)/sample1.ggo $(srcdir)/sample2.ggo 

# we don't have to link to anything
LIBS =

# check if we need to link with getopt.o and strdup.o
if NO_GETOPTLONG
GETOPTLONG_O = $(top_builddir)/src/getopt.o $(top_builddir)/src/getopt1.o
else
GETOPTLONG_O =
endif

if NO_STRDUP
STRDUP_O = $(top_builddir)/src/strdup.o
else
STRDUP_O =
endif

# if cpp2html is not installed we simply ignore the changes
# FIXME: maybe we have to notify the developer about it
if NO_CPP2HTML
cmdline1.c.html: cmdline1.c
	touch $@
else
cmdline1.c.html: cmdline1.c
	$(CPP2HTML) -i $< --doc
endif

# man page
man_MANS = gengetopt.1

EXTRA_PROGRAMS = sample1 sample2
sample1_SOURCES = cmdline1.c main1.cc
sample2_SOURCES = cmdline2.c main2.c

LDADD = $(GETOPTLONG_O) $(STRDUP_O)

INCLUDES = -I@top_srcdir@/src/

gengetoptdoc_DATA = gengetopt.html \
                    cmdline1.c.html \
                    man_getopt.html no_getopt_long.txt old_changes.html

gengetoptexamples_DATA = sample1.ggo sample2.ggo main1.cc main2.c \
                         cmdline1.c cmdline1.h cmdline2.c cmdline2.h

# info_TEXINFOS = gengetopt.texi

EXTRA_DIST = sample1.ggo sample2.ggo samples.stamp \
             cmdline1.c cmdline1.h cmdline2.c cmdline2.h cmdline1.c.html \
             $(man_MANS).in $(gengetoptdoc_DATA) cxxconfig.h \
             testdata

cmdline1.c: sample1.ggo
	$(PROGNAME) -i$< -Fcmdline1 --long-help -u

cmdline2.c: sample2.ggo
	$(PROGNAME) --input=$< --func-name=my_cmdline_parser --file-name=cmdline2 --unamed-opts --no-handle-help --no-handle-version

cmdline1.o: cmdline1.c
	$(CC) $(INCLUDES) -c $<

cmdline2.o: cmdline2.c
	$(CC) $(INCLUDES) -DPACKAGE=\"sample2\" -DVERSION=\"2.0\" -c $<

# session for tests
RUN_SAMPLE1 = ./sample1$(EXEEXT) -i 10 --flag-opt cmdline?.c
RUN_SAMPLE1_1 = ./sample1$(EXEEXT) --help --int-opt -34
# the next one generates an error 'cause -i option is not given
RUN_SAMPLE1_2 = ./sample1$(EXEEXT) -F
RUN_SAMPLE2 = ./sample2$(EXEEXT) -i 10 -l 20
RUN_SAMPLE2_1 = ./sample2$(EXEEXT) --version
RUN_SAMPLE2_2 = ./sample2$(EXEEXT) --help

check: testdata
	rm -f test.out
	touch $(GGO_FILES)
	$(MAKE) $(AM_MAKEFLAGS) sample1$(EXEEXT) sample2$(EXEEXT)
	$(RUN_SAMPLE1) >> test.out && \
	$(RUN_SAMPLE1_1) >> test.out && \
	$(RUN_SAMPLE2) >> test.out || \
	$(RUN_SAMPLE1_2) 2>> test.out
	$(RUN_SAMPLE2_1) >> test.out 
	$(RUN_SAMPLE2_2) >> test.out 
	@echo expect no output from diff
	diff $(srcdir)/testdata test.out

testdata:
	rm -f testdata
	$(RUN_SAMPLE1) >> testdata
	$(RUN_SAMPLE1_1) >> testdata
	$(RUN_SAMPLE2) >> testdata || \
	$(RUN_SAMPLE1_2) 2>> testdata
	$(RUN_SAMPLE2_1) >> testdata
	$(RUN_SAMPLE2_2) >> testdata

# this is to build samples once gengetopt has changed
# this is for development only.
samples: $(SAMPLES_STAMP)
	$(MAKE) $(AM_MAKEFLAGS) $(EXTRA_PROGRAMS)
#	echo timestamp > $(SAMPLES_STAMP)

$(SAMPLES_STAMP): $(PROGNAME)
	touch $(GGO_FILES)
	echo timestamp > $(SAMPLES_STAMP)

CLEANFILES = $(EXTRA_PROGRAMS)
MAINTAINERCLEANFILES = cmdline1.c cmdline2.c cmdline1.h cmdline2.h \
                       $(SAMPLES_STAMP)
