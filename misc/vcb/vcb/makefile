.c.o:
	cc -so -hi cpre:level1 -o $@ $*.c

VCB = vcbclass.o

VCX = vcxclass.o

HOOK = callhook.o setuphook.o hookentry.o

BOOPSUP = domethod.o

LIB = $(VCB) $(VCX) $(BOOPSUP) $(HOOK)

vcb.lib: $(LIB)
	lb vcb.lib $(LIB)

test:	test.o vcb.lib
	ln -w -o $@ test.o -lvcb -lc

test2:	test2.o vcb.lib
	ln -w -o $@ test2.o -lvcb -lc

vcxtest:	vcxtest.o vcb.lib
	ln -w -o $@ vcxtest.o -lvcb -lc

vcb.doc: vcb.n
	nro >$@ vcb.n

public:	vcb.lib vcb.h
	copy vcb.lib clib:
	copy vcb.h cinc:vcb
