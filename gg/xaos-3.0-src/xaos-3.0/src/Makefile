# Generated automatically from Makefile.in by configure.
CC     = gcc
CFLAGS = -m68040 -mstackcheck -Wall -fstrength-reduce -ffast-math -pipe -fno-exceptions -Os -I../ncurses-5.5/include -I../aalib-1.2 -I/PARTY/SCAM/!sources_new/xaos-3.0/src/include
LIBS   = -lpng040 -lz040 -l68881_040 -laa040 -lncurses -lX11_040 -L../aalib-1.2 -L../aalib-1.2
#LIBS   = -lpng -lz -l68881 -laa -lncurses -lX11 -L../aalib-1.2 -L../aalib-1.2 
LFLAGS = -O
AR     = ar
RANLIB = ranlib


TLIBS= \
       lib/libui.a \
       lib/libengine.a \
       lib/libutil.a \
       lib/libfilter.a \
       lib/libuix11.a
       #lib/libuiaa.a \
       #lib/libuicurses.a \

DIRS= \
       filter \
       engine \
       ui \
       util \
       ui/ui-drv/x11
#ui/ui-drv/aa \       
#ui/ui-drv/curses \ 

PROG= /PARTY/SCAM/!sources_new/xaos-3.0/bin/xaos
OBJS = $(SRCS:.c=.o)

TLIB = 


all default:	$(PROG)

/PARTY/SCAM/!sources_new/xaos-3.0/bin:
	mkdir $@

/PARTY/SCAM/!sources_new/xaos-3.0/src/lib:
	mkdir $@

libs:
	@for name in $(DIRS) ; do sh -c "cd $$name ; $(MAKE) all"; done

$(PROG): /PARTY/SCAM/!sources_new/xaos-3.0/bin /PARTY/SCAM/!sources_new/xaos-3.0/src/lib include/config.h libs
	$(CC) $(CFLAGS) $(LFLAGS) -o $@ $(TLIBS) $(LIBS)

include/config.h:
	cp include/config/config.autoconf include/config.h

clean:
	@for name in $(DIRS) ; do sh -c "cd $$name ; $(MAKE) $@"; done
	rm -f include/config.h
	rm -f $(PROG)

distclean:clean
	rm  -f Makefile

#dep:
#	rm -f .depend
#	make .depend
#
#.depend:
#	echo '# Program dependencies' >.depend
#	gcc -I svgalib $(DEFINES) -MM $(patsubst %.o,%.c,$(OBJS)) >>.depend
#
#include .depend
