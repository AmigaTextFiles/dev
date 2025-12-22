
CC = wla
CFLAGS = -lc

SFILES = src/speed.s
LFILES = speed.lib

all: $(LFILES) makefile

speed.lib: src/speed.s
	$(CC) $(CFLAGS) src/speed.s speed.lib

clean:
	rm -f $(LFILES) core *~
