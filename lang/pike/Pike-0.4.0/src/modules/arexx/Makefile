
SRCDIR=.
VPATH=.:./../..:../..
PREFLAGS=$(DEFINES) -I$(SRCDIR) -I$(SRCDIR)/../.. -I../..
CFLAGS=$(PREFLAGS) $(OTHERFLAGS)

FILES=arexx.o

arexx.a: $(FILES)
	-rm -f arexx.a
	ar cq arexx.a $(FILES)
	-ranlib arexx.a

clean:
	-rm -f *.o *.a
