DIRS = libutil libvm main
CC = gcc
CFLAGS = -I../include -I/Warp3D/Include -m68040 -O2 -noixemul
#CFLAGS = INCDIR=../include INCDIR=Warp3D:Include MATH=8 CPU=68040 DEBUG=FULLFLUSH DATA=FAR

all: subdirs

subdirs:
	set -e; for i in $(DIRS); do $(MAKE) --no-print-directory -C $$i CC="$(CC)" CFLAGS="$(CFLAGS)"; done


test:
	$(MAKE) --no-print-directory -C test CC="$(CC)" CFLAGS="$(CFLAGS)"

clean:
	rm -f `find . -name '*.o' -print`
	rm -f `find . -name 'lib*.a' -print`
	rm -f Engine
