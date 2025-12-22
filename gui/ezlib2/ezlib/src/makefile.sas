# SAS/C users will have to do their own lmk file or whatever it is that
# SAS uses.  I use make and that's pretty standard, so that's what I'm
# providing here.

CFLAGS =

OBJS= getstring.o string_gadget.o prop_gadget.o bool_gadget.o getfont.o getyn.o\
      window.o screen.o libs.o pick_color.o img_gadget.o

all : ez.lib

ez.lib : $(OBJS)
	 c:join $(OBJS) TO ez.lib

# unfortunately the make I use doesn't support implicit .c.o rules (sigh)
# so I have to explicitly do it all here...
pick_color.o : pick_color.c ezlib.h
	      lc $(CFLAGS) pick_color.c

img_gadget.o : img_gadget.c ezlib.h
	      lc $(CFLAGS) img_gadget.c

libs.o : libs.c ezlib.h
	   lc $(CFLAGS) libs.c

screen.o  : screen.c ezlib.h
	   lc $(CFLAGS) screen.c

window.o  : window.c ezlib.h
	   lc $(CFLAGS) window.c

bool_gadget.o  : bool_gadget.c ezlib.h
	   lc $(CFLAGS) bool_gadget.c

string_gadget.o : string_gadget.c ezlib.h
	   lc $(CFLAGS) string_gadget.c

prop_gadget.o : prop_gadget.c ezlib.h
	      lc $(CFLAGS) prop_gadget.c

getyn.o    : getyn.c  ezlib.h
	   lc $(CFLAGS) getyn.c

getfont.o  : getfont.c ezlib.h
	   lc $(CFLAGS) getfont.c

getstring.o   : getstring.c  ezlib.h
	   lc $(CFLAGS) getstring.c



