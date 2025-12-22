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

SUFFIXES = .text

.text.o:
	$(TXTC) $<

bin_PROGRAMS = gengetopt

gengetopt_SOURCES = copyright.text reportbugs.text parser.y scanner.l \
                    argsdef.c cmdline.c gengetopt.c gm.c yyerror.c \
                    gengetopt_strdup.text

gengetopt_LDADD = @LIBOBJS@ @LEXLIB@

EXTRA_DIST = parser.h argsdef.h gengetopt.h ggos.h gm.h getopt.h \
             cmdline.ggo cmdline.h cxxconfig.h

PROGNAME = $(top_builddir)/src/gengetopt$(EXEEXT)

# it may happen, usually if the sources have been downloaded from CVS
# repository, that cmdline.ggo is more recent than cmdline.c, but
# cmdline.c cannot be re-generated, even because gengetopt has
# to be built first. For instance if you only change spaces in cmdline.ggo
# cmdline.c will not be different, and thus it is not updated in the CVS
# repository; then when you make a checkout on another place, make
# would try to build cmdline.c, but to do this it would need gengetopt
# which is not built yet; so we simply touch cmdline.c (and this is safe)
%.c: %.ggo
	if test -f $(PROGNAME); then \
	$(PROGNAME) --input=$< --no-handle-version --no-handle-help \
        --no-handle-error; \
	else touch $@ ; fi

# automatically generate gengetopt_strdup() from the replacement function
# strdup().
gengetopt_strdup.text: strdup.c
	echo "/* gengetopt_strdup(): automatically generated from strdup.c. */" > $@
	cat $< | sed -e 's/^strdup (/gengetopt_&/' \
               -e 's/^char \* *$$/static &/' \
               -e '/^#include.*$$/D' -e '/^$$/D' >> $@

# we distribute these files because who uses gengetopt might need them
# these are installed in $(prefix)/share/gengetopt
pkgdata_DATA = getopt.h getopt.c getopt1.c

# yywrap.c is added only if it is not found on lex (flex) lib, and will be
# added automatically by automake

# automake (maybe due to a bug) doesn't added these files well,
# so we explicitely declare them
MAINTAINERCLEANFILES = scanner.c parser.h parser.c gengetopt_strdup.text
