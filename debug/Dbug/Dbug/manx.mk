#
#  FILE
#
#	manx.mk    Makefile for dbug package
#
#  SCCS ID
#
#	@(#)manx.mk	1.1	7/25/89
#
#  DESCRIPTION
#
#	Makefile for the dbug package (AmigaDOS, Manx C compiler)
#

# Define NO_VARARGS if you have no <varargs.h> to include.
VARARGS =	-DNO_VARARGS=1

CFLAGS =	$(VARARGS) -Damiga=1
CC =		cc

#	The default thing to do is remake the local runtime support
#	library.

all :		dbug.lib dbug32.lib factorial analyze

#	Note that we cannot simply rename dbug.o to dbug.lib since
#	the rename will fail if dbug.lib already exists.  And we
#	can't just arbitrarily delete it, since that will fail if
#	it doesn't exist.  Sigh.

dbug.lib :	dbug.c dbug.h
		$(CC) $(CFLAGS) dbug.c
		copy dbug.o dbug.lib
		delete dbug.o

dbug32.lib :	dbug.c dbug.h
		$(CC) +L $(CFLAGS) dbug.c
		copy dbug.o dbug32.lib
		delete dbug.o

#
#	Make the test/example program "factorial".
#
#	Note that the objects depend on the LOCAL dbug.h file and
#	the compilations are set up to find dbug.h in the current
#	directory even though the sources have "#include <dbug.h>".
#	This allows the examples to look like the code a user would
#	write but still be used as test cases for new versions
#	of dbug.

factorial :	main.o factorial.o dbug32.lib
		ln -o $@ main.o factorial.o dbug32.lib -lc32

main.o :	main.c dbug.h
		$(CC) +L $(CFLAGS) main.c

factorial.o :	factorial.c dbug.h
		$(CC) +L $(CFLAGS) factorial.c

#	Make the analyze program for runtime profiling support.

analyze :	analyze.o dbug32.lib
		ln -o $@ analyze.o dbug32.lib -lm32 -lc32

analyze.o :	analyze.c useful.h dbug.h
		$(CC) +L $(CFLAGS) analyze.c
