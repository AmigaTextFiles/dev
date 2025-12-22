OBJECTS = blitlab.o bits.o initialize.o render.o gadgets.o mem.o parse.o \
          math.o doblit.o blitsim.o save.o

.c.o:
	cc -e300 +istructures.b $*.c

all: blit

blit: $(OBJECTS)
	ln -o blitlab $(OBJECTS) -lc

$(OBJECTS): structures.b

structures.b: structures.h
	cc -a +hstructures.b structures.h
	delete structures.asm

count:
	wc makefile structures.h bits.c blitlab.c initialize.c \
	render.c gadgets.c mem.c parse.c math.c doblit.c blitsim.c \
	save.c

clean:
	delete #?.log #?.dvi #?.o #?.b #?.uu
