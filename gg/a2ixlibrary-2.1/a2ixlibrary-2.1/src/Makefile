# Generated automatically from Makefile.in by configure.
# GNU-Makefile for a2ixlibrary package

# If configure doesn't work for you ({} globbed in config.cache), your
# pdksh is outdated, get a version newer than November 95.

# You may prefer simply . (current directory)
srcdir =	.

prefix =	/usr/local
exec_prefix =	${prefix}

bindir =	$(exec_prefix)/bin
a2ixdir =	$(prefix)/share/a2ixlibrary

INSTALL =	/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA =	${INSTALL} -m 644

SHELL =		/bin/sh
CC =		gcc
RM =		rm
DEFS =		 
LIBS =		
# flags ignored, Fred Fish's configure throws -O2 into CFLAGS
CFLAGS =	-g -O2
LDFLAGS =	

DATAFILES =	amiga_exe_script.x amiga_exe_baserel_script.x \
		amiga_lib_script.x auto_init.c deltadata.pl \
		deltafunctions.pl instance.c setvars.c start.S \
		relocate.c

.c.o:
		$(CC) $(CFLAGS) -c $<

all:		postlink string_hash a2ixgetsize a2ixsafename

postlink:	postlink.c
		$(CC) $(CFLAGS) $(LDFLAGS) -resident -o $@ $^

string_hash:	string_hash.c
		$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

a2ixgetsize:	a2ixgetsize.c
		$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

a2ixsafename:	a2ixsafename.c
		$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

install:	installdirs
		$(INSTALL_PROGRAM) postlink $(bindir)/postlink
		$(INSTALL_PROGRAM) $(srcdir)/a2ixlibrary $(bindir)/a2ixlibrary
		$(INSTALL_PROGRAM) string_hash $(a2ixdir)/string_hash
		$(INSTALL_PROGRAM) a2ixgetsize $(a2ixdir)/a2ixgetsize
		$(INSTALL_PROGRAM) a2ixsafename $(a2ixdir)/a2ixsafename
		for i in $(DATAFILES); do $(INSTALL_DATA) $(srcdir)/$$i $(a2ixdir)/$$i ; done

installdirs:	mkinstalldirs
		$(srcdir)/mkinstalldirs $(bindir) $(a2ixdir)

clean:
		$(RM) -f *.o

clobber:	clean
		$(RM) -f postlink string_hash a2ixgetsize a2ixsafename Makefile config.*

Makefile:	Makefile.in config.status
		CONFIG_FILES=Makefile CONFIG_HEADERS= $(SHELL) ./config.status
