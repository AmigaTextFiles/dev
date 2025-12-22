#
# GNU-makefile for test2
#

#
# ATT: In "inline/stubs.h" you need to add the line
#	struct Isrvstr;
# before compiling to avoid warnings!
#

CFLAGS = -O2
LIBS = -lc -lamiga

#

OBJS2 = test2.o rx_test2.o rx_test2_rxcl.o rx_test2_rxif.o

RXIF = /rxif/rx_alias.c /rxif/rx_cmdshell.c /rxif/rx_disable.c \
	/rxif/rx_enable.c /rxif/rx_fault.c /rxif/rx_help.c \
	/rxif/rx_rx.c

test2: $(OBJS2)
	gcc -o test2 $(OBJS2) $(LIBS)

rx_test2.o: rx_test2.c rx_test2.h

rx_test2_rxif.o: rx_test2_rxif.c rx_test2.h $(RXIF)

rx_test2_rxcl.o: rx_test2_rxcl.c rx_test2.h

test2.o: test2.c test2.h rx_test2.h

