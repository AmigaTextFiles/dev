CFLAGS = -O2

OBJS = mkvcdfs.o vcdisofs.o edc_ecc.o

all:	mkvcdfs vcdmplex

mkvcdfs: $(OBJS)
	gcc -o mkvcdfs $(OBJS)

vcdmplex: vcdmplex.c
	gcc -O2 -o vcdmplex vcdmplex.c

clean:
	rm -f *.o mkvcdfs vcdmplex
