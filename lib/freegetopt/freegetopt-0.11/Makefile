##############################################################################
# $Header: /cvsroot/freegetopt/freegetopt/Makefile,v 1.2 2003/10/26 03:10:19 vindaci Exp $

CC=gcc -mcrt=newlib
OBJECTS=getopt.o
BINARIES=test


##############################################################################
# PHONIES

all: test

clean:
	rm -f $(BINARIES) *.o


##############################################################################
# FILES

all: test libfreegetopt.a

test: test.o $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS)

libfreegetopt.a: $(OBJECTS)
	ar -crv $@ $^

test.o: test.c
	$(CC) $(CFLAGS) -c -o $@ $<

getopt.o: getopt.c
	$(CC) $(CFLAGS) -c -o $@ $<
