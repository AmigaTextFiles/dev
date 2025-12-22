CROSS = 
CC = $(CROSS)gcc
AR = $(CROSS)ar
RM = rm

CPU_CFLAGS = 

# uncomment if target CPU is big endian
#CPU_CFLAGS = -DWORDS_BIGENDIAN

CFLAGS = -O3 -Wall -I../include $(CPU_CFLAGS)

all: libc2p.a libp2c.a

libc2p.a: c2p.o
	$(AR) -crv $@ $^

libp2c.a: p2c.o
	$(AR) -crv $@ $^

c2p.o: c2p/*.c
p2c.o: p2c/*.c

clean:
	$(RM) *.o lib*.a
