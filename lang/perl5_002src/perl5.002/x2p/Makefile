# $RCSfile: Makefile.SH,v 2177240Revision: 4.1 2177240Date: 92/08/07 18:29:07 $
#
# $Log:	Makefile.SH,v $

CC = gcc
BYACC = byacc
LDFLAGS = -s
SMALL = 
LARGE =  
mallocsrc = 
mallocobj = 
shellflags = 

libs = -lnet -lgdbm -lsdbm -lm -lc

CCCMD = `sh $(shellflags) cflags $@`

public = a2p s2p find2perl

private = 

manpages = a2p.man s2p.man

util =

sh = Makefile.SH cflags.SH
shextract = Makefile cflags

pl = find2perl.PL s2p.PL
plextract = find2perl s2p

addedbyconf = $(shextract) $(plextract)

h = EXTERN.h INTERN.h ../config.h handy.h hash.h a2p.h str.h util.h

c = hash.c $(mallocsrc) str.c util.c walk.c

obj = hash.o $(mallocobj) str.o util.o walk.o

lintflags = -phbvxac

# grrr
SHELL = /bin/sh

.c.o:
	$(CCCMD) $*.c

all: $(public) $(private) $(util)
	touch all

a2p: $(obj) a2p.o
	$(CC) $(LDFLAGS) $(obj) a2p.o $(libs) -o a2p

# I now supply a2p.c with the kits, so the following section is
# used only if you force byacc to run by saying
# make  run_byacc

run_byacc:	FORCE
	@ echo Expect many shift/reduce and reduce/reduce conflicts
	$(BYACC) a2p.y
	mv y.tab.c a2p.c

# We don't want to regenerate a2p.c, but it might appear out-of-date
# after a patch is applied or a new distribution is made.
a2p.c: a2p.y
	-@touch a2p.c

a2p.o: a2p.c a2py.c a2p.h EXTERN.h util.h INTERN.h handy.h ../config.h str.h hash.h
	$(CCCMD) $(LARGE) a2p.c

clean:
	rm -f a2p *.o

realclean: clean
	rm -f *.orig core $(addedbyconf) all malloc.c
	rm -f GNUmakefile GNUmakefile.old

# The following lint has practically everything turned on.  Unfortunately,
# you have to wade through a lot of mumbo jumbo that can't be suppressed.
# If the source file has a /*NOSTRICT*/ somewhere, ignore the lint message
# for that spot.

lint:
	lint $(lintflags) $(defs) $(c) > a2p.fuzz

depend: $(mallocsrc) ../makedepend
	../makedepend

clist:
	echo $(c) | tr ' ' '\012' >.clist

hlist:
	echo $(h) | tr ' ' '\012' >.hlist

shlist:
	echo $(sh) | tr ' ' '\012' >.shlist

# These should be automatically generated

$(plextract):
	../miniperl -I../lib $@.PL

malloc.c: ../malloc.c
	rm -f malloc.c
	sed <../malloc.c >malloc.c \
	    -e 's/"perl.h"/"..\/perl.h"/' \
	    -e 's/my_exit/exit/'

# AUTOMATICALLY GENERATED MAKE DEPENDENCIES--PUT NOTHING BELOW THIS LINE
$(obj):
	@ echo "You haven't done a "'"make depend" yet!'; exit 1
makedepend: depend
