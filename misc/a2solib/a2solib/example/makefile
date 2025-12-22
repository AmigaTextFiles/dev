include ../rules.make

all: static_lib/libtest.a static_lib/libdbg.a test.so solib_test dlfcn_test dlfcn_test2 test2.so

static_lib/libtest.a: test.c
	$(CC) $(CFLAGS) -o static_lib/test.o -mbaserel -c test.c -O
	$(AR) rcv static_lib/libtest.a static_lib/test.o

static_lib/libtest2.a: dlfcn_test_lib.c
	$(CC) $(CFLAGS) -o static_lib/dlfcn_test_lib.o -mbaserel -c dlfcn_test_lib.c -O
	$(AR) rcv static_lib/libtest2.a static_lib/dlfcn_test_lib.o

static_lib/libdbg.a: dbg.c
	$(CC) $(CFLAGS) -o static_lib/dbg.o -mbaserel -c dbg.c -O
	$(AR) rcv static_lib/libdbg.a static_lib/dbg.o
	
solib_test: solib_test.c test.so dbg.so
	$(CC) $(CFLAGS) -o solib_test solib_test.c -Llib -ldbg -ltest -lsolib
	
dlfcn_test: dlfcn_test.c
	$(CC) $(CFLAGS) -o dlfcn_test dlfcn_test.c -ldl	-lsolib

dlfcn_test2: dlfcn_test2.c
	$(CC) $(CFLAGS) -o dlfcn_test2 dlfcn_test2.c -ldl -lsolib

test.so: static_lib/libtest.a dbg.so
	genso --cflags=$(CFLAGS)\ -ggdb --ldflags=$(LDFLAGS) --libs=-Llib/baserel\ -ldbg\ -lsolib static_lib/libtest.a
	-$(RM) lib/libtest.a
	-$(RM) lib/baserel/libtest.a
	$(MV) libtest.a lib
	$(MV) libtest.a-brel lib/baserel/libtest.a

dbg.so: static_lib/libdbg.a
	genso --cflags=$(CFLAGS)\ -ggdb --ldflags=$(LDFLAGS) static_lib/libdbg.a
	-$(RM) lib/libdbg.a
	-$(RM) lib/baserel/libdbg.a
	$(MV) libdbg.a lib
	$(MV) libdbg.a-brel lib/baserel/libdbg.a


test2.so: static_lib/libtest2.a
	genso --cflags=$(CFLAGS)\ -ggdb --ldflags=$(LDFLAGS) --libs=-Llib/baserel\ -ldl\ -lsolib static_lib/libtest2.a
	-$(RM) lib/libtest2.a
	-$(RM) lib/baserel/libtest2.a
	$(MV) libtest2.a lib
	$(MV) libtest2.a-brel lib/baserel/libtest2.a

	
clean:
	-$(RM) *.o *.so *.a dlfcn_test dlfcn_test2 solib_test
	
install:
