CC = gcc
#uncomment the following line if the host is a little endian machine
#(the Amiga is *not* little endian :-)
#ENDIANNESS = -DLITTLE_ENDIAN

#Comment the following line if your compiler doesn't like it
#or if you absolutely want ixemul
AFLAGS = -noixemul

GccFindHit: GccFindHit.c defs.h
	$(CC) $(AFLAGS) -Wall -O $(ENDIANNESS) GccFindHit.c -o GccFindHit
