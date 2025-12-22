.SUFFIXES: .a .o .c
CC              =  gcc
CFLAGS          =  -Wall -funsigned-char -c

BINS = dcetest
ALL = $(BINS)

DCE_OBJS = dcetest.o tcpstuff.o

dcetest: $(DCE_OBJS)
	$(CC) -o dcetest $(DCE_OBJS) -Xlinker -s

clean:
	rm -f *~ *.bak
	rm -f include/*~ include/*.bak
	rm -f *.o
	rm -f dcetest


