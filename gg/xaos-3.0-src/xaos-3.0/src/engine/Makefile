# Generated automatically from Makefile.in by configure.
CC     = gcc
CFLAGS = -m68040 -O6 -Wall -fstrength-reduce -ffast-math -fforce-mem -fforce-addr -funroll-loops -pipe -fmove-all-movables -frerun-loop-opt -I/PARTY/SCAM/!sources_new/xaos-3.0/src/include
LIBS   = -lpng040 -lz040 -l68881_040 -laa040 -lncurses -lX11_040 -L../aalib-1.2 -L../aalib-1.2
#LIBS   = -lpng -l68881 -laa -lncurses   -lX11   -lX11   -lX11 -L../aalib-1.2 -L../aalib-1.2
LFLAGS = -O
AR     = ar
RANLIB = ranlib

SRCS = formulas.c \
       fractal.c  \
       btrace.c \
       palettef.c \
       emboss.c \
       star.c \
       dither.c \
       edge.c \
       edge2.c \
       rotate.c \
       zoom.c \
       blur.c \
       interlace.c \
       itersmall.c \
       stereogram.c \
       subwindow.c \
       plane.c \
       julia.c \
       i386.c

OBJS = $(SRCS:.c=.o)

TLIB = ../lib/libengine.a


all:	$(TLIB)

$(TLIB):$(OBJS)
	rm -f $@
	$(AR) rc $@ $(OBJS)
	$(RANLIB) $@ 

formulas.o: docalc.c


clean:
	rm -f $(TLIB)
	rm -f *.[oas]
	rm -f *~
	rm -f core 

distclean:clean
	rm  Makefile

#dep:
#	rm -f .depend
#	make .depend
#
#.depend:
#	echo '# Program dependencies' >.depend
#	gcc -I svgalib $(DEFINES) -MM $(patsubst %.o,%.c,$(OBJS)) >>.depend
#
#include .depend
