GCC = g++ # gcc
NEWLIB = -newlib
DEFINES = -DDEBUG=1
CFLAGS = $(DEFINES) $(NEWLIB) -O3 -Wall -c

test: test.o memguardian.o
	$(GCC) $(NEWLIB) -o $@ test.o memguardian.o

test.o: test.c memguardian.h makefile
	$(GCC) $(CFLAGS) test.c

memguardian.o: memguardian.c memguardian.h makefile
	$(GCC) $(CFLAGS) memguardian.c


