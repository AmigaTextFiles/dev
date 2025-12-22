CROSS  := ppc-amigaos
CC     := $(CROSS)-gcc
STRIP  := $(CROSS)-strip
RM     := rm -f

CFLAGS  := -O2 -g -Wall -Werror -Wwrite-strings -I..
LDFLAGS := -use-dynld
LIBS    := -lunix

.PHONY: all
all: lz4 lz4c

lz4: CFLAGS += -DDISABLE_LZ4C_LEGACY_OPTIONS
lz4: lz4cli.c lz4io.c bench.c ../xxhash.c ../liblz4.so
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@.debug $^ $(LIBS)
	$(STRIP) -R.comment -o $@ $@.debug

lz4c: lz4cli.c lz4io.c bench.c ../xxhash.c ../liblz4.so
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@.debug $^ $(LIBS)
	$(STRIP) -R.comment -o $@ $@.debug

.PHONY: clean
clean:
	$(RM) lz4 lz4c *.debug

