CFLAGS		= -O

icint:		icint.o interp.o sub.o
		$(CC) $(LDFLAGS) $(CFLAGS) -o $@ icint.o interp.o sub.o

icint.o:	icint.c icint.h

interp.o:	interp.c icint.h

sub.o:		sub.c icint.h
