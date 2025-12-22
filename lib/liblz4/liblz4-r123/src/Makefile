CROSS  := ppc-amigaos
CC     := $(CROSS)-gcc
AR     := $(CROSS)-ar
RANLIB := $(CROSS)-ranlib
RM     := rm -f

CFLAGS  := -O2 -g -Wall -Werror -Wwrite-strings

.PHONY: all
all: liblz4.a liblz4.so lz4programs

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.lo: %.c
	$(CC) $(CFLAGS) -fPIC -DPIC -c -o $@ $<

liblz4.a: lz4.o lz4hc.o
	$(AR) -crv $@ $^
	$(RANLIB) $@

liblz4.so: lz4.lo lz4hc.lo
	$(CC) -shared -Wl,-soname,liblz4.so -o $@ $^

.PHONY: lz4programs
lz4programs:
	$(MAKE) -C programs all

.PHONY: clean
clean:
	$(RM) liblz4.a liblz4.so *.o *.lo
	$(MAKE) -C programs clean

