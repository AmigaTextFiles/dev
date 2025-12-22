# $Id: Makefile.am,v 1.2 2003/06/02 17:18:49 sarrazip Exp $

SUBDIRS = src

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = $(PACKAGE)-$(API).pc

docdir = $(datadir)/doc/$(PACKAGE)-$(VERSION)
doc_DATA = \
	AUTHORS \
	COPYING \
	INSTALL \
	NEWS \
	README \
	TODO

RPMBUILD = rpmbuild
rpm: dist
	$(RPMBUILD) -ta $(distdir).tar.gz

check:
	test "`PKG_CONFIG_PATH=. pkg-config --modversion $(PACKAGE)-$(API)`" \
		= $(VERSION)
	test -n "`PKG_CONFIG_PATH=. pkg-config --cflags $(PACKAGE)-$(API)`"
	test -n "`PKG_CONFIG_PATH=. pkg-config --libs $(PACKAGE)-$(API)`"

M4_MACROS = \
	macros/ac_compile_warnings.m4 \
	macros/sdl_image.m4 \
	macros/try-link-sdl-mixer.m4

EXTRA_DIST = \
	bootstrap \
	autogen.sh \
	$(PACKAGE)-$(API).spec \
	$(M4_MACROS) \
	ltmain.sh
#
# Including ltmain.sh explicitly is necessary to avoid having 'make distcheck'
# fail with an error message like this:
# ../../libtool: No such file or directory

ACLOCAL_AMFLAGS = -I macros

MAINTAINERCLEANFILES = \
	Makefile.in \
	aclocal.m4 \
	configure \
	config.guess \
	config.sub \
	depcomp \
	install-sh \
	ltmain.sh \
	missing \
	mkinstalldirs

