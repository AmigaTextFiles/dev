#CC = gcc -g -pg -a	# profiling flags
#CC = gcc -O5
CC = gcc -g -Wall

all:
	cat README

clean:
	rm -f *.o listswf listswf.exe \
		  bindump bindump.exe \
		  hexdump hexdump.exe \
		  listfdb listfdb.exe \
		  listjpeg listjpeg.exe \
		  listmp3 listmp3.exe \
		  makefdb makefdb.exe \
		  swftophp swftophp.exe \
		  png2dbl png2dbl.exe \
		  gif2dbl gif2dbl.exe \
		  gif2mask gif2mask.exe core

#.o: .c .h

listswf: blocktypes.o decompile.o read.o listswf.c
	#${CC} listswf.c blocktypes.o decompile.o read.o -o listswf -lm -lz
	${CC} listswf.c blocktypes.o decompile.o read.o -o listswf -lz -Xlinker -s

decompile.o: action.h

listswf_nd: blocktypes.o decompile.o read.o listswf.c
	${CC} -DNODECOMPILE listswf.c blocktypes.o decompile.o read.o -o listswf -lz -Xlinker -s

listaction: blocktypes.o read.o listswf.c
	${CC} -DNODECOMPILE listswf.c blocktypes.o read.o -o listaction -Xlinker -s

swftophp: blocktypes.o decompile.o read.o swftophp.c
	${CC} swftophp.c blocktypes.o decompile.o read.o -o swftophp -Xlinker -s

makefdb: blocktypes.o makefdb.c read.o
	${CC} makefdb.c read.o blocktypes.o -o makefdb -Xlinker -s

gif2mask: gif2mask.c
	${CC} gif2mask.c -o gif2mask -lgif  -lz -Xlinker -s

png2dbl: png2dbl.c
	${CC} png2dbl.c -o png2dbl -lz -lpng -Xlinker -s

gif2dbl: gif2dbl.c
	${CC} gif2dbl.c -o gif2dbl -lz -lungif -Xlinker -s

