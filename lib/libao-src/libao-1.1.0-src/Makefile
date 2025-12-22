CROSS  := ppc-amigaos
CC     := $(CROSS)-gcc
AR     := $(CROSS)-ar
RANLIB := $(CROSS)-ranlib
STRIP  := $(CROSS)-strip
RM     := rm -f
CP     := cp
LN     := ln

PREFIX := /SDK/local/newlib

CFLAGS := -O2 -g -Wall -Werror -Wwrite-strings -Iinclude -Iinclude/ao \
	-DAO_BUILDING_LIBAO -DHAVE_AHI
PIC    := -fPIC -DPIC
LIBS   := 

SRCS := src/ao_ahi.c src/ao_au.c \
	src/ao_null.c src/ao_raw.c \
	src/ao_wav.c src/audio_out.c \
	src/config.c

OBJS   := $(SRCS:.c=.o)
S_OBJS := $(SRCS:.c=.lo)

.PHONY: all
all: libao.a libao.so.4

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.lo: %.c
	$(CC) $(CFLAGS) $(PIC) -c -o $@ $<

libao.a: $(OBJS)
	$(AR) -crv $@ $^
	$(RANLIB) $@

libao.so.4: $(S_OBJS)
	$(CC) -shared -Wl,-soname,$@ -o $@ $^

.PHONY: clean
clean:
	$(RM) libao.a libao.so.4 src/*.o src/*.lo

.PHONY: install
install:
	$(CP) -r include/* $(PREFIX)/include/
	$(CP) libao.a libao.la libao.so.4 $(PREFIX)/lib/
	$(LN) -s -f libao.so.4 $(PREFIX)/lib/libao.so
	$(CP) ao.pc $(PREFIX)/lib/pkgconfig/

