CC=gcc
CFLAGS=-Wall -freg-struct-return -O3

%.o: %.c
	$(CC) $(CFLAGS) -I .. -c $^ 2>&1|tee $*.err
	-if test ! -s $*.err; then rm $*.err; fi

%.o: %.s
	$(CC) -c $^

exectest: exectest.o __test_init.o ../expansion/libexpansion.a ../exec/libexec.a
	$(CC) -nostdlib  $^ -o $@

__test_init.s:
	../genglue/genglue -s -r -l -p __ -q ___ exectest.fc
