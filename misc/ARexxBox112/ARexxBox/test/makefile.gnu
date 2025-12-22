#
# GNU-makefile für test
#

#
# Anmerkung: Im Header "inline/stubs.h" fehlt die Zeile
#	struct Isrvstr;
# Bitte vor dem Compilieren ergänzen!
#

CFLAGS = -O2
LIBS = -lc -lamiga

#

OBJS = test.o rx_test.o rx_test_rxcl.o rx_test_rxif.o

test: $(OBJS)
	gcc -o test $(OBJS) $(LIBS)

rx_test.o: rx_test.c rx_test.h

rx_test_rxif.o: rx_test_rxif.c rx_test.h

rx_test_rxcl.o: rx_test_rxcl.c rx_test.h

test.o: test.c test.h rx_test.h

