all:	bcpp calib qb2c x11 clean 

navig.o:	navig.c drill.h
	gcc -s -O4 -bi486-unknown-linuxaout -c navig.c

mrproper:	
	rm -f  *.o libqbX11.a bcc brun run bhelp

bcpp:	bcpp.c
	gcc -ansi -O2 -o bcpp bcpp.c

qb2c:	qb2c.c
	gcc -ansi -O2 -o qb2c qb2c.c -lm

calib:	calib.c
	gcc -ansi -o calib calib.c 

x11:	x11int.c rotated.c gifencode.c gifdecode.c pickpalette.c
	gcc -c -ansi -w -O2 x11int.c rotated.c gifencode.c gifdecode.c pickpalette.c
	ar -cr libqbX11.a x11int.o rotated.o gifencode.o gifdecode.o pickpalette.o

clean:	
	rm -f *.o tmp-*.b2c

install:	qb2c bcpp calib
	cp qb2c /usr/local/bin
	cp bcpp /usr/local/bin
	cp calib /usr/local/bin
