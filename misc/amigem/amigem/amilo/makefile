TARGET=amilo

CC=gcc
CFLAGS=-Wall -freg-struct-return -O3

%.o: %.c
	$(CC) $(CFLAGS) -I .. -c $^ 2>&1|tee $*.err
	-if test ! -s $*.err; then rm $*.err; fi

amilo: amilo.o utility.o init.o /gnu/os-lib/libamiga.a
	$(CC) $^ -o $@

init.s:
	../genglue/genglue -s -l amilo.fc
