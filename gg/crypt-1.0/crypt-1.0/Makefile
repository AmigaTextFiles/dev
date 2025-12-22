
CC:=gcc
CFLAGS=-g -O2

prefix:=/usr

all: crypt

crypt: crypt.o libcrypt.a
	$(CC) -o $@ crypt.o libcrypt.a

libcrypt.a: encrypt.o
	ar rv $@ encrypt.o

encrypt.o: encrypt.h

distclean: clean

clean:
	-rm *.o *.exe *.a

install: all
	install -s crypt.exe $(prefix)/bin
	install encrypt.h $(prefix)/include/crypt.h
	install libcrypt.a $(prefix)/lib

