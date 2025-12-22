include ../rules.make

all: libsolibglue.a libsolib.a libsolib_brel.a libdl.a libdl_brel.a

lib.o: lib.c
	$(CXX) $(CFLAGS) -O2 -I$(TOPDIR)include -ggdb -c lib.c -o lib.o

clib2_glue.o: clib2_glue.c
	$(CC) $(CFLAGS) -mbaserel -O2 -I$(TOPDIR)include -ggdb -c clib2_glue.c -o clib2_glue.o

libdl.o: libdl.c
	$(CC) $(CFLAGS) -O2 -I$(TOPDIR)include -ggdb -c libdl.c -o libdl.o

libdl_brel.o: libdl.c
	$(CC) $(CFLAGS) -O2 -I$(TOPDIR)include -mbaserel -ggdb -c libdl.c -o libdl_brel.o

linklib.o: linklib.c
	$(CC) $(CFLAGS) -O2 -I$(TOPDIR)include -ggdb -c linklib.c -o linklib.o

linklib_brel.o: linklib.c
	$(CC) $(CFLAGS) -O2 -I$(TOPDIR)include -mbaserel -ggdb -c linklib.c -o linklib_brel.o

libsolibglue.a: lib.o clib2_glue.o
	$(AR) rcv libsolibglue.a lib.o clib2_glue.o

libsolib.a: linklib.o
	$(AR) rvc libsolib.a linklib.o

libsolib_brel.a: linklib_brel.o
	$(AR) rvc libsolib_brel.a linklib_brel.o
	
libdl.a: libdl.o
	$(AR) rcv libdl.a libdl.o

libdl_brel.a: libdl_brel.o
	$(AR) rcv libdl_brel.a libdl_brel.o
	
clean:
	-$(RM) *.o *.a
	
install: libsolibglue.a
	$(CP) libsolibglue.a $(LINSTDIR)lib/baserel
	$(CP) libdl.a $(LINSTDIR)lib
	$(CP) libdl_brel.a $(LINSTDIR)lib/baserel/libdl.a
	$(CP) libsolib.a $(LINSTDIR)lib
	$(CP) libsolib_brel.a $(LINSTDIR)lib/baserel/libsolib.a
	$(CP) $(TOPDIR)include/interfaces/solib.h $(LINSTDIR)include/interfaces
	$(CP) $(TOPDIR)include/dlfcn.h $(LINSTDIR)include
	$(CP) $(TOPDIR)include/solib.h $(LINSTDIR)include
