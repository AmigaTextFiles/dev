#
# libX11-1.00 >>> 1.01 modified by megacz@usa.com (13-04-07)
#
# NOTES:
#       - 'images.c' was way problematic bastard, i had to make some
#         trickery around 'X11Setup_Tile', compiles well but is this
#         ok, im not sure... 
#
#       - put 'os-include/proto/dos.h' to 'include/' before compiling.
#
#       - there will be LOTS of warnings, dont worry.
#    
#       - dont use 'ndk 3.9', use the original 'sdk 3.1' from
#         Commodore or else the library will be faulty!!!
#
#       - check out all the comments in this file!
#
#       - i have left the objects after compilation for 68040,
#         just in case(do 'make clean' first if u want fresh build).


CPUTYPE=68040
H2A=hunk2aout
EAS=PhxAss
EASFLAGS= M=$(CPUTYPE) NOEXE OPT=2 SC
MV=mv
RM=rm
CC=gcc
CFLAGS= -c -m$(CPUTYPE) -Os -Wno-implicit -Wno-return-type -DNeedFunctionPrototypes \
        -DMOTIF -DXTSTRINGDEFINES -DXMSTRINGDEFINE -DXMUI -DXTMUI -DDEBUG=0

# debugging/misc opts
#
# -DMWDEBUG=1 -DDEBUGXEMUL_WARNING=1 -DDEBUGXEMUL_ENTRY -DNO020  
# -DDEBUGXEMUL0 -DDEBUGXEMUL -DXMUIAPP


LIBOBJS=xtoolkit.o x11events.o x11windows.o x11text.o x11display.o x11colormaps.o \
	x11drawing.o clipping.o xmui.o xmdrawing.o x11fonts.o images.o x11cursors.o \
	filling.o regions.o x11resources.o context.o visuals.o lists.o gc.o class.o \
	xtmui.o xemul2.o xemul3.o xemul4.o base.o map.o x11mui.o x11winsupport.o \
	pixmaps.o imagecache.o setmouse.o timing.o x11p2c.o x11c2p.o

 
libX11.a: $(LIBOBJS)
	-$(RM) libX11.a
	ar cr libX11.a $(LIBOBJS)
	ranlib libX11.a


# these two first objects must me build with stand alone assembler
# like 'PhxAss' or 'snma' without startup code(noexe) and then
# converted to 'gcc' object convention with 'hunk2aout' !!!
#
x11c2p.o: x11c2p.s
	$(EAS) $(EASFLAGS) x11c2p.s
	$(H2A) x11c2p.o
	$(MV) -f -v obj.* x11c2p.o

x11p2c.o: x11p2c.s
	$(EAS) $(EASFLAGS) x11p2c.s
	$(H2A) x11p2c.o
	$(MV) -f -v obj.* x11p2c.o

x11events.o: x11events.c x11events.h debug.h
	$(CC) $(CFLAGS) x11events.c

x11windows.o: x11windows.c x11windows.h x11events.h
	$(CC) $(CFLAGS) x11windows.c

x11display.o: x11display.c x11display.h x11windows.h x11events.h images.h debug.h
	$(CC) $(CFLAGS) x11display.c

x11text.o: x11text.c x11text.h debug.h
	$(CC) $(CFLAGS) x11text.c

xemul2.o: xemul2.c xemul2.h
	$(CC) $(CFLAGS) xemul2.c

x11colormaps.o: x11colormaps.c x11colormaps.h
	$(CC) $(CFLAGS) x11colormaps.c

imagecache.o: imagecache.c imagecache.h
	$(CC) $(CFLAGS) imagecache.c

x11colormap.o: x11colormap.c
	$(CC) $(CFLAGS) x11colormap.c

setmouse.o: setmouse.c
	$(CC) $(CFLAGS) setmouse.c

pixmaps.o: pixmaps.c
	$(CC) $(CFLAGS) pixmaps.c

map.o: map.c map.h
	$(CC) $(CFLAGS) map.c

x11drawing.o: x11drawing.c x11drawing.h debug.h
	$(CC) $(CFLAGS) x11drawing.c

clipping.o: clipping.c clipping.h
	$(CC) $(CFLAGS) clipping.c

xmdrawing.o: xmdrawing.c xmdrawing.h
	$(CC) $(CFLAGS) xmdrawing.c

xtoolkit.o: xtoolkit.c xtoolkit.h
	$(CC) $(CFLAGS) xtoolkit.c

x11fonts.o: x11fonts.c x11fonts.h
	$(CC) $(CFLAGS) x11fonts.c

images.o: images.c images.h x11drawing.h debug.h
	$(CC) $(CFLAGS) images.c

x11cursors.o: x11cursors.c x11cursors.h
	$(CC) $(CFLAGS) x11cursors.c

filling.o: filling.c filling.h
	$(CC) $(CFLAGS) filling.c

xemul3.o: xemul3.c xemul3.h
	$(CC) $(CFLAGS) xemul3.c

xemul4.o: xemul4.c xemul4.h
	$(CC) $(CFLAGS) xemul4.c

timing.o: timing.c timing.h
	$(CC) $(CFLAGS) timing.c

x11resources.o: x11resources.c x11resources.h
	$(CC) $(CFLAGS) x11resources.c

resource_list.o: resource_list.c resource_list.h
	$(CC) $(CFLAGS) resource_list.c

context.o: context.c context.h
	$(CC) $(CFLAGS) context.c

visuals.o: visuals.c visuals.h
	$(CC) $(CFLAGS) visuals.c

regions.o: regions.c regions.h
	$(CC) $(CFLAGS) regions.c

lists.o: lists.c lists.h
	$(CC) $(CFLAGS) lists.c

xmui.o: xmui.c
	$(CC) $(CFLAGS) xmui.c

x11mui.o: x11mui.c
	$(CC) $(CFLAGS) x11mui.c

gc.o: gc.c
	$(CC) $(CFLAGS) gc.c

class.o: class.c
	$(CC) $(CFLAGS) class.c

xtmui.o: xtmui.c
	$(CC) $(CFLAGS) xtmui.c

base.o: base.c
	$(CC) $(CFLAGS) base.c

clean:
	$(RM) $(LIBOBJS) libX11.a
