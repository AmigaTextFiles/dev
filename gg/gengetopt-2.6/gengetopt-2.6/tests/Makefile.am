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


# .ggonu is used in this test suite for command line parsers that have
# to be created without --unamed-opt

SUFFIXES = .ggo .ggonu

PROGNAME = $(top_builddir)/src/gengetopt$(EXEEXT)

GGO_COMPILE = $(PROGNAME) --input $< --unamed-opt --func-name $*_parser --file-name $*

.ggo.c:
	$(GGO_COMPILE)

.ggonu.c:
	$(PROGNAME) --input $< --func-name $*_parser --file-name $*

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

INCLUDES = -I@top_srcdir@/src/

# INCLUDES is added to LDFLAGS because .ggo file are sources, and thus
# the .c files are passed to the linker, which also compiles, thus
# the include options should be passed to it as well
LDFLAGS = $(DEFS) $(INCLUDES)

LDADD = $(GETOPTLONG_O) $(STRDUP_O)

EXPECT = 1

TESTS = no_strings no_unamed no_optgiven.sh more_than_once.sh canonize-names \
default_values default_cmdline

check_PROGRAMS = no_strings no_unamed no_optgiven more_than_once \
canonize-names default_values default_cmdline

no_strings_SOURCES = no_strings_cmd.ggo no_strings.c
no_unamed_SOURCES = no_unamed_cmd.ggonu no_unamed.c
no_optgiven_SOURCES = no_optgiven_cmd.ggo no_optgiven.c
more_than_once_SOURCES = more_than_once_cmd.ggo more_than_once.c
canonize_names_SOURCES = canonize-names-cmd.ggo canonize-names.c
default_values_SOURCES = default_values_cmd.ggo default_values.c
default_cmdline_SOURCES = cmdline.ggo default_cmdline.c

no_optgiven_cmd.c: no_optgiven_cmd.ggo
	$(GGO_COMPILE) --no-handle-error

canonize-names-cmd.c: canonize-names-cmd.ggo
	$(PROGNAME) --input $< --func-name $*-parser --file-name $*

cmdline.c: cmdline.ggo
	$(PROGNAME) --input $<

EXTRA_DIST = no_optgiven.sh.in more_than_once.sh.in

CLEANFILES = *_cmd.c *_cmd.h cmdline.c cmdline.h
