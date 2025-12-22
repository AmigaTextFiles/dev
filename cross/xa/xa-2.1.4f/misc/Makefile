
XCBMLIB = ..

CFLAGS = 

LIBS = -lncurses -ltermcap -lm


all: ../uncpk ../printcbm ../file65 ../mkrom.sh ../reloc65 ../ld65

../uncpk: uncpk.c
	${CC} ${CFLAGS} uncpk.c -o $(XCBMLIB)/uncpk

../printcbm: printcbm.c
	${CC} ${CFLAGS} printcbm.c -o $(XCBMLIB)/printcbm

../file65: file65.c
	${CC} ${CFLAGS} file65.c -o $(XCBMLIB)/file65

../ld65: ld65.c
	${CC} ${CFLAGS} ld65.c -o $(XCBMLIB)/ld65

../reloc65: reloc65.c
	${CC} ${CFLAGS} reloc65.c -o $(XCBMLIB)/reloc65

../mkrom.sh: mkrom.sh
	cp mkrom.sh ../mkrom.sh

lt1: lt1.a
	../xa -R -c -o lt1 lt1.a

lt2: lt2.a
	../xa -R -c -o lt2 lt2.a

lt: lt1 lt2
	../ld65 -o lt lt1 lt2 

clean:
	rm -f *.o 

mrproper: clean
	rm -f ../uncpk ../printcbm ../file65 ../mkrom.sh ../reloc65 ../ld65
	rm -f lt1 lt2 lt

