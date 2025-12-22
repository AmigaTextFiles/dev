# $Id: Makefile.am,v 1.2 2003/10/21 04:04:36 sarrazip Exp $
# Makefile.am

lib_LTLIBRARIES = libflatzebra-0.1.la

libflatzebra_0_1_la_LDFLAGS = -version-info 2:0:0 -no-undefined

libflatzebra_0_1_la_SOURCES = \
	Couple.h \
	RCouple.h \
	GameEngine.cpp \
	GameEngine.h \
	PixmapArray.cpp \
	PixmapArray.h \
	PixmapLoadError.cpp \
	PixmapLoadError.h \
	Sprite.cpp \
	Sprite.h \
	RSprite.cpp \
	RSprite.h \
	SoundMixer.cpp \
	SoundMixer.h \
	KeyState.h \
	font_13x7.xpm

libflatzebra_0_1_la_CXXFLAGS = \
	$(SDL_CFLAGS) \
	-I$(top_srcdir)/src

libflatzebra_0_1_la_LIBADD = \
	$(SDL_LIBS)

pkgincludedir = $(includedir)/$(PACKAGE)-$(API)/$(PACKAGE)
pkginclude_HEADERS = \
	Couple.h \
	RCouple.h \
	GameEngine.h \
	PixmapArray.h \
	PixmapLoadError.h \
	Sprite.h \
	RSprite.h \
	SoundMixer.h \
	KeyState.h

MAINTAINERCLEANFILES = Makefile.in

