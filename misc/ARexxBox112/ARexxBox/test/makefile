#
# Aztec-makefile für test und test2
#

CFLAGS = -wcdpur0n -safmnrs -psp -qf -hi test.hdr
LIBS = -lc16

#

OBJS = test.o rx_test.o rx_test_rxcl.o rx_test_rxif.o

test: $(OBJS)
	ln -o test $(OBJS) rexxvar_manx.o $(LIBS)

rx_test.o: rx_test.c rx_test.h

rx_test_rxif.o: rx_test_rxif.c rx_test.h

rx_test_rxcl.o: rx_test_rxcl.c rx_test.h

test.o: test.c test.h rx_test.h

#

test.hdr: test.h
	cc -psp -ho test.hdr test.h

