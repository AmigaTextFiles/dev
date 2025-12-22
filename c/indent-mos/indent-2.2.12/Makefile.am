## Process this file with automake to produce Makefile.in
AUTOMAKE_OPTIONS = no-texinfo.tex

SUBDIRS = intl src doc po man regression

BUILT_SOURCES = 

DISTFILES = $(DIST_COMMON:README=README.md) $(DIST_SOURCES) $(TEXINFOS) $(EXTRA_DIST)

EXTRA_DIST = 	README.md \
		config/config.rpath \
		ChangeLog-1990 ChangeLog-1998 ChangeLog-2001 \
		aclocal/UTIMBUF.m4 \
		miscel/Makefile.mingw32 \
		miscel/README.vc++ \
		bootstrap \
		regression

DISTCLEANFILES=config/config.cache config/config.log config.h

ps:
	cd doc && $(MAKE) @PACKAGE@.ps

pdf:
	cd doc && $(MAKE) @PACKAGE@.pdf

html:
	cd doc && $(MAKE) html

html-split:
	cd doc && $(MAKE) html-split

# --------------- Maintainer's Section

MAINTAINERCLEANFILES = intl/* aclocal.m4 Makefile.in \
	config.h.in config/* \
	po/Makefile.in.in po/Rules-quot po/boldquot.sed po/en@boldquot.header \
	po/en@quot.header po/insert-header.sin po/quot.sed po/remove-potcdate.sin \
	stamp-h1 stamp-h.in configure \
	@PACKAGE@-1.spec \
	@PACKAGE@.lsm indent-2.spec .gdbinit \
	INSTALL ABOUT-NLS 

## Use -g when in maintainer mode
if MAINTAINER_MODE
CFLAGS+= -g -Wall -I.
else
CFLAGS+= -I.
endif

if MAINTAINER_MODE
README: README.md
	ln -s $< $@

@PACKAGE@.lsm :%: Makefile %.in
	sed -e 's%!VERSION!%@VERSION@%g' $@.in > $@
endif


ACLOCAL_AMFLAGS = -I m4
