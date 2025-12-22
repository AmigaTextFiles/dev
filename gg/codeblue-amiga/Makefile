# Makefile for codeblue
CC=gcc

all:
	-gcc -g -D_GNU_SOURCE -O2 -Iinclude -Wall -o codeblue codeblue.c -Xlinker -s

install:
	-install ./codeblue /usr/local/sbin/codeblue

clean:
	@echo Cleaning up...
	-rm -f *.o
	-rm -f codeblue
	@echo done.

