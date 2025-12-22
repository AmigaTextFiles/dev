#
# Aztec makefile for test2
#

CFLAGS = -wcdpur0n -safmnrs -psp -qf -hi test2.hdr
LIBS = -lc16

#

OBJS2 = test2.o rx_test2.o rx_test2_rxcl.o rx_test2_rxif.o
RXIF = /rxif/rx_alias.c /rxif/rx_cmdshell.c /rxif/rx_disable.c \
	/rxif/rx_enable.c /rxif/rx_fault.c /rxif/rx_help.c \
	/rxif/rx_rx.c

test2: $(OBJS2)
	ln -o test2 $(OBJS2) rexxvar_manx.o $(LIBS)

rx_test2.o: rx_test2.c rx_test2.h

rx_test2_rxif.o: rx_test2_rxif.c rx_test2.h $(RXIF)

rx_test2_rxcl.o: rx_test2_rxcl.c rx_test2.h

test2.o: test2.c test2.h rx_test2.h

#

test2.hdr: test2.h
	cc -psp -ho test2.hdr test2.h

