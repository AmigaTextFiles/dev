# Makefile.am for SDL_anim

lib_LTLIBRARIES = libSDL_anim.la

libSDL_animincludedir = $(includedir)/SDL
libSDL_animinclude_HEADERS =	\
	SDL_anim.h

libSDL_anim_la_SOURCES =		\
	Anim.c

EXTRA_DIST =			\
	INSTALL			\
	AUTHORS			\
	ChangeLog		\
	VisualC.zip		\
	autogen.sh		\
	planet.anim		\
	planet.ini		\
	planet.png		\
	planet.pov

libSDL_anim_la_LDFLAGS = 		\
        -release $(LT_RELEASE)	\
	-version-info $(LT_CURRENT):$(LT_REVISION):$(LT_AGE)

bin_PROGRAMS = showanim

showanim_LDADD = libSDL_anim.la

# Rule to build tar-gzipped distribution package
$(PACKAGE)-$(VERSION).tar.gz: dist

# Rule to build RPM distribution package
rpm: $(PACKAGE)-$(VERSION).tar.gz
	cp $(PACKAGE)-$(VERSION).tar.gz /usr/src/redhat/SOURCES
	rpm -ba --nodeps $(PACKAGE).spec
