CC = g++ -mcrt=newlib
AR = ar
RM = rm
CFLAGS = -c -msoft-float -O2 -fomit-frame-pointer -I. -Wcast-align

IN_CUBE = in_cube/adp.c in_cube/adx.c in_cube/decode.c \
          in_cube/afc.c in_cube/cube.c in_cube/dsp.c \
	  in_cube/pcm.c

all:
	$(CC) $(CFLAGS) pokecubed.cpp 
	$(CC) $(CFLAGS) $(IN_CUBE)
	$(AR) r libpokecubed.a *.o

clean: 
	$(RM) *.o
