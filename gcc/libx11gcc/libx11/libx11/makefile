
cc=gcc
CFLAGS= -c -O3 -Wno-implicit -Wno-return-type -DNeedFunctionPrototypes -DMOTIF\
-DXTSTRINGDEFINES -DXMSTRINGDEFINE -DXMUI

# -DMWDEBUG=1 -DDEBUGXEMUL_WARNING=1 -DDEBUGXEMUL_ENTRY -DNO020  
# -DDEBUGXEMUL0 -DDEBUGXEMUL -DDEBUG=0 -DXTMUI -DXMUI -DXMUIAPP

LIBOBJS=xtoolkit.o x11events.o x11windows.o x11text.o x11display.o x11colormaps.o\
	x11drawing.o clipping.o xmui.o xmdrawing.o x11fonts.o images.o x11cursors.o\
	filling.o regions.o x11resources.o context.o visuals.o lists.o gc.o class.o\
	xtmui.o xemul2.o xemul3.o xemul4.o base.o map.o x11mui.o x11winsupport.o\
	pixmaps.o imagecache.o setmouse.o timing.o x11p2c.o x11c2p.o

# alloca.o tcp.o tcp2.o context.o unix.o lists.o xaw.o assoc.o 

RM= delete quiet

libX11.a: $(LIBOBJS)
	-$(RM) libX11.a
	ar -q libX11.a $(LIBOBJS)

alloca.o: alloca.c
	$(cc) $(CFLAGS) PARAMS=STACK alloca.c

x11events.o: x11events.c x11events.h debug.h
	$(cc) $(CFLAGS) x11events.c

x11windows.o: x11windows.c x11windows.h x11events.h
	$(cc) $(CFLAGS) x11windows.c

x11display.o: x11display.c x11display.h x11windows.h x11events.h images.h debug.h
	$(cc) $(CFLAGS) x11display.c

x11text.o: x11text.c x11text.h debug.h
	$(cc) $(CFLAGS) x11text.c

xemul2.o: xemul2.c xemul2.h
	$(cc) $(CFLAGS) xemul2.c

x11colormaps.o: x11colormaps.c x11colormaps.h
	$(cc) $(CFLAGS) x11colormaps.c

x11drawing.o: x11drawing.c x11drawing.h debug.h
	$(cc) $(CFLAGS) x11drawing.c

clipping.o: clipping.c clipping.h
	$(cc) $(CFLAGS) clipping.c

xmdrawing.o: xmdrawing.c xmdrawing.h
	$(cc) $(CFLAGS) xmdrawing.c

xtoolkit.o: xtoolkit.c xtoolkit.h
	$(cc) $(CFLAGS) xtoolkit.c

x11fonts.o: x11fonts.c x11fonts.h
	$(cc) $(CFLAGS) x11fonts.c

images.o: images.c images.h x11drawing.h debug.h
	$(cc) $(CFLAGS) images.c

x11cursors.o: x11cursors.c x11cursors.h
	$(cc) $(CFLAGS) x11cursors.c

filling.o: filling.c filling.h
	$(cc) $(CFLAGS) filling.c

xemul3.o: xemul3.c xemul3.h
	$(cc) $(CFLAGS) xemul3.c

xemul4.o: xemul4.c xemul4.h
	$(cc) $(CFLAGS) xemul4.c

timing.o: timing.c timing.h
	$(cc) $(CFLAGS) timing.c

resources.o: resources.c resources.h
	$(cc) $(CFLAGS) resources.c

resource_list.o: resource_list.c resource_list.h
	$(cc) $(CFLAGS) resource_list.c

context.o: context.c context.h
	$(cc) $(CFLAGS) context.c

visuals.o: visuals.c visuals.h
	$(cc) $(CFLAGS) visuals.c

regions.o: regions.c regions.h
	$(cc) $(CFLAGS) regions.c

lists.o: lists.c lists.h
	$(cc) $(CFLAGS) lists.c

xmui.o: xmui.c
	$(cc) $(CFLAGS) xmui.c

x11mui.o: x11mui.c
	$(cc) $(CFLAGS) x11mui.c

x11c2p.o: x11c2p.s
	$(cc) $(CFLAGS) x11c2p.s

x11p2c.o: x11p2c.s
	$(cc) $(CFLAGS) x11p2c.s

tcp.o: tcp.c
	$(cc) $(CFLAGS) tcp.c

gc.o: gc.c
	$(cc) $(CFLAGS) gc.c

unix.o: unix.c
	$(cc) $(CFLAGS) unix.c

class.o: class.c
	$(cc) $(CFLAGS) class.c

xtmui.o: xtmui.c
	$(cc) $(CFLAGS) xtmui.c

base.o: base.c
	$(cc) $(CFLAGS) base.c

clean:
	$(RM) $(LIBOBJS)
