# Generated automatically from Makefile.in by configure.
CC     = gcc
CFLAGS = -m68040 -mstackcheck -Wall -fstrength-reduce -ffast-math -pipe -fno-exceptions -Os -I../ncurses-5.5/include -I../aalib-1.2 -I/PARTY/SCAM/!sources_new/xaos-3.0/src/include
LIBS   = -lpng040 -lz040 -l68881_040 -laa040 -lncurses -lX11_040 -L../aalib-1.2 -L../aalib-1.2
#LIBS   = -lpng -l68881 -laa -lncurses   -lX11   -lX11   -lX11 -L../aalib-1.2 -L../aalib-1.2
LFLAGS = -O
AR     = ar
RANLIB = ranlib

SRCS = image.c \
       palette.c \
       random.c \
       filter.c

OBJS = $(SRCS:.c=.o)

TLIB = ../lib/libfilter.a


all:	$(TLIB)

$(TLIB):$(OBJS)
	rm -f $@
	$(AR) rc $@ $(OBJS)
	$(RANLIB) $@ 

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
