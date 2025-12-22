
CC = wla-gb
CFLAGS = -o
LD = wlalink
LDFLAGS = -vb

SFILES = setup.s main.s
IFILES = defines1.i defines2.i
OFILES = main.o setup.o

all: $(OFILES) makefile
	$(LD) $(LDFLAGS) linkfile linked.gb

main.o: main.s defines1.i gb_memory1.i
	$(CC) $(CFLAGS) main.s main.o

setup.o: setup.s defines2.i gb_memory2.i
	$(CC) $(CFLAGS) setup.s setup.o


$(OFILES): $(HFILES)


clean:
	rm -f $(OFILES) core *~ linked.gb
