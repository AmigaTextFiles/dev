# Generated automatically from Makefile.in by configure.
CC     = gcc
CFLAGS = -O3 -fstrength-reduce -ffast-math -fforce-mem -fforce-addr -funroll-loops -I../aalib-1.2
LIBS   = -laa -lncurses -lm  -L../aalib-1.2 -L../aalib-1.2
LFLAGS = -O
prefix = /usr/local
exec_prefix = ${prefix}
datadir= ${prefix}/share
bindir= ${exec_prefix}/bin
mandir= ${prefix}/man
infodir= ${prefix}/info


INCL = config.h 
 
OBJS = main.o \
       ui.o \
       shrink.o \
       image.o 

OBJS1 = flip.o \
        general.o

all:	aview aaflip


aview:  $(OBJS)
	$(CC) $(CFLAGS) $(LFLAGS) -o aview $(OBJS) $(LIBS)


aaflip: $(OBJS1)
	$(CC) $(CFLAGS) $(LFLAGS) -o aaflip $(OBJS1) $(LIBS)

clean:
	rm -f aview
	rm -f aaflip
	rm -f core `find . -name '*.[oas]' -print`
	rm -f core `find . -name '*~' -print`
	rm -f core `find . -type f -name 'core' -print`

distclean:clean
	rm -f config.log config.status config.cache Makefile

install:
	/bin/install -c -s aview ${bindir}
	/bin/install -c -s aaflip ${bindir}
	/bin/install -c asciiview ${bindir}

