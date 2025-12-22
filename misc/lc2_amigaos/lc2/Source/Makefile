SHELL=/bin/sh
CC=cc

# Objects we link together.
OBJ=lc.o get.o

all:	$(OBJ)
	$(CC) -o lc $(OBJ)

lc.o:	lc.c lc.h
get.o:	get.c lc.h

clean:
	-/bin/rm -f *.o lc core expected/*.log expected/*.2log GCTLOG


distclean:	clean
	# This is the guts of gclean, which may not be available
	# at distribution time.
	/bin/rm -f gct-ps-defs.h
	/bin/rm -f gct-map gct-map.gbk
	/bin/rm -f gct-rscript
	/bin/rm -f gct-rscript.bk
	/bin/rm -fr gct_backup
	/bin/rm -f gct-ps-defs.c
	/bin/rm -f gct-ps-defs.c~
	/bin/rm -f gct-ps-defs.h~
	/bin/rm -f gct-write.c
	/bin/rm -f gct-defs.h
