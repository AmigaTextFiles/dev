CROSS := ppc-amigaos
CC := $(CROSS)-gcc
AR := $(CROSS)-ar
RM := rm -f

CFLAGS := -O2 -g -Wall -Werror -I. -Ilibart_lgpl
LDFLAGS := 
LIBS := 

SRCS := $(wildcard libart_lgpl/*.c)
OBJS := $(SRCS:.c=.o)

.PHONY: all
all: libart_lgpl_2.a tests/testart tests/testuta tests/testdisp

tests/testart: tests/testart.o libart_lgpl_2.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

tests/testuta: tests/testuta.o libart_lgpl_2.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

tests/testdisp: tests/testdisp.o libart_lgpl_2.a
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS) -lauto

libart_lgpl_2.a: $(OBJS)
	$(AR) -crv $@ $^

.PHONY: clean
clean:
	$(RM) tests/testart tests/testuta tests/testdisp tests/*.o libart_lgpl_2.a libart_lgpl/*.o
