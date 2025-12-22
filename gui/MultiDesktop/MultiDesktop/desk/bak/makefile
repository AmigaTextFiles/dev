desk: desklib.o desk.o error.o GER:multidesktop.catalog multidesk.o
 ln -o desk desklib.o desk.o error.o +q -lamiga -lcl32 -lm8l32
 copy desk LIBS:multidesktop.library

desklib.o: desklib.asm
 as desklib.asm -C -D

desk.o: desk.c
 cc desk.c +P -S +B +F8 +Icc:pre/lpre.pre

error.o: error.c
 cc error.c +P -S +B +F8 +Icc:pre/lpre.pre

multidesk.asm: desk_lib.fd
 cfd desk_lib.fd multidesk AUTO
 as multidesk.asm -C -D

multidesk.o: multidesk.asm
 as multidesk.asm -C -D

GER:multidesktop.catalog: cc:prgs/ml/multi.txt
 makecat cc:prgs/ml/multi.txt multidesktop.catalog

t: t.o multidesk.o
 ln t.o multidesk.o +q -lc32 -lamiga

t.o: t.c
 cc t.c +P -S +Icc:pre/pre.pre

q: q.o
 ln q.o +q -lc32

q.o: q.c
 cc q.c +L -S +Icc:pre/pre.pre

guru: guru.o multidesk.o
 ln guru.o multidesk.o +q -lc32

guru.o: guru.c
 cc guru.c +P -S

