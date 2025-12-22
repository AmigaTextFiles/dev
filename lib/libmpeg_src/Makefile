# Generated automatically from Makefile.in by configure.
#
# Makefile.in for the MPEG Library -- this has to be processed by
# `configure' to be meaningful!
#


# Various programs and their options

CC            = gcc
OPT           = -O6 -m68020
DEFS          = -DHAVE_CONFIG_H
INCLUDES      = -I.
CFLAGS        = $(OPT) $(DEFS) $(INCLUDES) -noixemul
AR            = ar
ARFLAGS       = ru
RANLIB        = ranlib
SHELL         = /bin/sh


# Source for the library itself -- note that we define LIBSRC and
# LIBOBJ this way (instead of just LIBOBJ=$(LIBSRC:.c=.o) because
# HP-UX make is stupid.

DECODER_SRC   = util.c video.c parseblock.c motionvector.c decoders.c \
		jrevdct.c wrapper.c globals.c 24bit.c gdith.c
DITHER_SRC    = fs2.c fs2fast.c fs4.c hybrid.c hybriderr.c 2x2.c gray.c \
		mono.c ordered.c ordered2.c mb_ordered.c
LIBSRC        = $(DECODER_SRC) $(DITHER_SRC)
LIBOBJ        = $(DECODER_SRC:.c=.o) $(DITHER_SRC:.c=.o)


# Other files of interest

LIBRARY       = libmpeg.a
MPEGTEST      = mpegtest

# Targets for all platforms

all:		$(LIBRARY)  mpegtest

$(LIBRARY):	$(LIBOBJ)
		$(AR) $(ARFLAGS) $(LIBRARY) $(LIBOBJ)
		$(RANLIB) $(LIBRARY)

$(LIBOBJ):	Makefile


# Makefile fragment to compile stuff in extras/ (regardless of 
# whether it can be built or not -- that's decided in the main
# Makefile)

mpegtest:	extras/mpegtest libmpeg.a
		rm -f mpegtest
		ln -s extras/mpegtest .

extras/mpegtest:extras
		(cd extras ; $(MAKE) mpegtest)

easympeg:	extras/easympeg libmpeg.a
		rm -f easympeg
		ln -s extras/easympeg .

extras/easympeg:extras
		(cd extras ; $(MAKE) easympeg)

check:		mpegtest
		./mpegtest -checksum test.mpg

clean:
		rm -f $(LIBRARY) mpegtest core $(LIBOBJ)
		(cd extras ; $(MAKE) clean)

distclean: clean
		rm -f config.cache config.log config.status Makefile config.h
		cd extras && $(MAKE) distclean

# Include a system-specific Makefile fragment, if any


