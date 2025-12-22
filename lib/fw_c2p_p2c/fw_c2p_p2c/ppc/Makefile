CROSS = 
AS = $(CROSS)as
AR = $(CROSS)ar
RM = rm

ASFLAGS = -mregnames

all: libc2p.a libp2c.a

libc2p.a: c2p.o
	$(AR) -crv $@ $^

libp2c.a: p2c.o
	$(AR) -crv $@ $^

c2p.o: c2p/*.s
p2c.o: p2c/*.s

clean:
	$(RM) *.o lib*.a
