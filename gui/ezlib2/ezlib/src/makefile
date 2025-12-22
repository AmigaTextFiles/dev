# just type 'make' to build ezlib

CFLAGS = -so -hiheader.h

OBJS= getstring.o string_gadget.o prop_gadget.o bool_gadget.o getfont.o getyn.o\
      window.o screen.o libs.o pick_color.o img_gadget.o

all : header.h ez.lib

header.h :  aztec.h
	 cc -hoheader.h aztec.h

ez.lib : $(OBJS)
	 lb ez $(OBJS)

# unfortunately the make I use isn't smart enough to do implicit .c.o
# rules (sigh).  So I do them by hand....

pick_color.o : pick_color.c ezlib.h
	      cc $(CFLAGS) pick_color.c

img_gadget.o : img_gadget.c ezlib.h
	      cc $(CFLAGS) img_gadget.c

libs.o : libs.c ezlib.h
	   cc $(CFLAGS) libs.c

screen.o  : screen.c ezlib.h
	   cc $(CFLAGS) screen.c

window.o  : window.c ezlib.h
	   cc $(CFLAGS) window.c

bool_gadget.o  : bool_gadget.c ezlib.h
	   cc $(CFLAGS) bool_gadget.c

string_gadget.o : string_gadget.c ezlib.h
	   cc $(CFLAGS) string_gadget.c

prop_gadget.o : prop_gadget.c ezlib.h
	      cc $(CFLAGS) prop_gadget.c

getyn.o    : getyn.c  ezlib.h
	   cc $(CFLAGS) getyn.c

getfont.o  : getfont.c ezlib.h
	   cc $(CFLAGS) getfont.c

getstring.o   : getstring.c  ezlib.h
	   cc $(CFLAGS) getstring.c


