all: pucrunch

pucrunch: pucrunch.c pucrunch.h
	gcc -mcrt=newlib -Wall -funsigned-char pucrunch.c -o pucrunch -O -lm -Dstricmp=strcasecmp

pucrunch-mos: pucrunch.c pucrunch.h
	$(CC) pucrunch.c -Wall -O2 -o ../$@
	strip -R.comment ../$@
