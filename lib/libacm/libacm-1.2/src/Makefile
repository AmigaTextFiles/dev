CROSS := ppc-amigaos
CC := $(CROSS)-gcc
AR := $(CROSS)-ar
RANLIB := $(CROSS)-ranlib
RM := rm -f

CFLAGS := -O2 -g -Wall -Werror -DHAVE_AO
LDFLAGS := -use-dynld
LIBS := -lao -ldl

.PHONY: all
all: libacm.a acmtool

libacm.a: decode.o util.o
	$(AR) -crv $@ $^
	$(RANLIB) $@

acmtool: acmtool.o libacm.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

.PHONY: clean
clean:
	$(RM) acmtool libacm.a *.o
