#
# besselmath-0.0.1 (Makefile(gcc) by megacz@usa.com)
#


#
# compiler flags
CFLAGS = -O6 -m68000 -pipe -Wall -fstrength-reduce -ffast-math -fomit-frame-pointer


#
# compiler frontend
CC = gcc 


#
# rules
all: libbesselmath.a i0.c i1.c j0.c j1.c k0.c k1.c y0.c y1.c

libbesselmath.a: i0.o i1.o j0.o j1.o k0.o k1.o y0.o y1.o 
	ar cru $@ i0.o i1.o j0.o j1.o k0.o k1.o y0.o y1.o
	ranlib $@

i0.o: i0.c
	$(CC) $(CFLAGS) -c i0.c -o i0.o

i1.o: i1.c
	$(CC) $(CFLAGS) -c i1.c -o i1.o

j0.o: j0.c
	$(CC) $(CFLAGS) -c j0.c -o j0.o

j1.o: j1.c
	$(CC) $(CFLAGS) -c j1.c -o j1.o

k0.o: k0.c
	$(CC) $(CFLAGS) -c k0.c -o k0.o

k1.o: k1.c
	$(CC) $(CFLAGS) -c k1.c -o k1.o

y0.o: y0.c
	$(CC) $(CFLAGS) -c y0.c -o y0.o

y1.o: y1.c
	$(CC) $(CFLAGS) -c y1.c -o y1.o  


clean:
	rm -f i0.o i1.o j0.o j1.o k0.o k1.o y0.o y1.o
	rm -f libbesselmath.a
