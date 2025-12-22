CC =		lc
CFLAGS =	-cm -O -dfseek=unixfseek

O1 =		tty.o getsFF.o scan-asm.o wmatch.o bitops.o scan-c.o
O2 =		bitsvec.o gets0.o hash.o bzero.o opensrc.o lid.o bitcount.o
O3 =		document.o uerror.o fid.o idx.o paths.o bsearch.o mkid.o
O4 =		basename.o init.o amiga.o stoi.o amiga_getenv.o getscan.o
O5 =		raw.o sendpacket.o test.o
OBJ =		$(O1) $(O2) $(O3) $(O4) $(O5)

all :		fid idx lid mkid test

fid :		$(OBJ)
		blink with fid.lnk

idx :		$(OBJ)
		blink with idx.lnk

lid :		$(OBJ)
		blink with lid.lnk

mkid :		$(OBJ)
		blink with mkid.lnk

test :		$(OBJ)
		blink with test.lnk

