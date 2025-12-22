#
# ixamissl
# 

CC = gcc
CFLAGS = -O -m68000 -Wall -msoft-float -I/gg/amissl-include -Iinclude
LIBFLAGS = $(CFLAGS) -resident
LIB32FLAGS = $(CFLAGS) -m68020 -resident32
IXLIBFLAGS = $(LIBFLAGS) -malways-restore-a4

all: amissltest #amissltestix showbug_bad showbug_good

libs: lib/libamisslinit.a lib/libb/libamisslinit.a lib/libb32/libm020/libamisslinit.a lib/libraamisslinit.a lib/libra32amisslinit.a

amissltest: lib/libamisslinit.a
	$(CC) $(CFLAGS) amissltest.c -o $@ $^

amissltestix: lib/libraamisslinit.a libiastest.ixlibrary
	$(CC) $(CFLAGS) amissltest.c -DSHAREDLIB_BIN -o $@ libiastest.a

showbug_bad: lib/libraamisslinit.a libshowbug_bad.ixlibrary
	$(CC) $(CFLAGS) showbug.c -o $@ libshowbug_bad.a

showbug_good: lib/libamisslinit.a libshowbug_good.ixlibrary
	$(CC) $(CFLAGS) showbug.c -DINITAMISSL -o $@ lib/libamisslinit.a libshowbug_good.a

lib/libamisslinit.a: amisslinit.o natsocket.o
	ar -cru $@ amisslinit.o natsocket.o
	ranlib $@

lib/libb/libamisslinit.a: amisslinit.ro natsocket.ro
	ar -cru $@ amisslinit.ro natsocket.ro
	ranlib $@

lib/libb32/libm020/libamisslinit.a: amisslinit.r32o natsocket.r32o
	ar -cru $@ amisslinit.r32o natsocket.r32o
	ranlib $@

lib/libraamisslinit.a: amisslinit.rao natsocket.rao
	ar -cru $@ amisslinit.rao natsocket.rao
	ranlib $@

lib/libra32amisslinit.a: amisslinit.ra32o natsocket.ra32o
	ar -cru $@ amisslinit.ra32o natsocket.ra32o
	ranlib $@

libiastest.ixlibrary: amissltest.oo
	rm -f /gg/include/a2ixlibrary/iastest.h
	rm -f /gg/share/a2ixlibrary/ldscripts/iastest.x
# /* Amiga - pay attention to the two lines above, you will need to extract 
#  *         objects like this and then incorporate them into your library.
# */
	ar x lib/libraamisslinit.a
	ar cru libiastest.a amissltest.oo *.rao
	ranlib libiastest.a
	echo >a2ixlibrary.data.in "#define NAME iastest"
	echo >>a2ixlibrary.data.in "#define LIBRARY_ID 666"
	echo >>a2ixlibrary.data.in "#define VERSION 1"
	echo >>a2ixlibrary.data.in "#define REVISION 0"
	/c/rx gg:share/a2ixlibrary/gena2ixinst.rexx >a2ixlibrary.data filein=a2ixlibrary.data.in amissl=ixemul_errno
	a2ixlibrary -noinst

libshowbug_bad.ixlibrary: showbug.oo
	rm -f /gg/include/a2ixlibrary/showbug_bad.h
	rm -f /gg/share/a2ixlibrary/ldscripts/showbug_bad.x
	ar cru libshowbug_bad.a showbug.oo *.rao
	ranlib libshowbug_bad.a
	echo >a2ixlibrary.data.in "#define NAME showbug_bad"
	echo >>a2ixlibrary.data.in "#define LIBRARY_ID 667"
	echo >>a2ixlibrary.data.in "#define VERSION 1"
	echo >>a2ixlibrary.data.in "#define REVISION 0"
	/c/rx gg:share/a2ixlibrary/gena2ixinst.rexx >a2ixlibrary.data filein=a2ixlibrary.data.in amissl=ixemul_errno
	a2ixlibrary -noinst

libshowbug_good.ixlibrary: showbug.ooo
	rm -f /gg/include/a2ixlibrary/showbug_good.h
	rm -f /gg/share/a2ixlibrary/ldscripts/showbug_good.x
	ar cru libshowbug_good.a showbug.ooo *.rao
	ranlib libshowbug_good.a
	echo >a2ixlibrary.data.in "#define NAME showbug_good"
	echo >>a2ixlibrary.data.in "#define LIBRARY_ID 668"
	echo >>a2ixlibrary.data.in "#define VERSION 1"
	echo >>a2ixlibrary.data.in "#define REVISION 0"
	/c/rx gg:share/a2ixlibrary/gena2ixinst.rexx >a2ixlibrary.data filein=a2ixlibrary.data.in
	a2ixlibrary -noinst

.SUFFIXES: .o .oo .ooo .rao .ra32o .ro .r32o

.c.o:
	$(CC) $(CFLAGS) -c $<

.c.oo:
	$(CC) $(IXLIBFLAGS) -DSHAREDLIB -c $< -o $@

.c.ooo:
	$(CC) $(IXLIBFLAGS) -DSHAREDLIB -D_ASI_BASES_ -c $< -o $@

.c.rao:
	$(CC) $(IXLIBFLAGS) -c $< -o $@

.c.ra32o:
	$(CC) $(IXLIBFLAGS) $(LIB32FLAGS) -c $< -o $@

.c.ro:
	$(CC) $(LIBFLAGS) -c $< -o $@

.c.r32o:
	$(CC) $(LIB32FLAGS) -c $< -o $@

clean:
	-rm -f amissltest amissltestix showbug_bad showbug_good
	-rm -f *.o *.oo *.ooo *.rao *.ra32o *.ro *.r32o *.a *.ixlibrary *.data lib/*.a lib/libb/*.a lib/libb32/libm020/*.a
	/c/avail >nil: flush
