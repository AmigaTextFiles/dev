CC=gcc -mcrt=newlib
CFLAGS+=-W -Wall -Wno-unused -ansi -pedantic -DNDEBUG -DCPU_IS_BIG_ENDIAN -O2 -fPIC
OBJS=effect.o error.o gus.o init.o load.o mix.o read.o seek.o

all: libpac.so libpac.a pacplay/pacplay

libpac.so:	${OBJS}
		${CC} -shared -nostartfiles -o libpac.so ${OBJS}

libpac.a:	${OBJS}
		${AR} csr libpac.a ${OBJS}

${OBJS}:	pac.h pacP.h

xmms:		${OBJS} xmms/plugin.c
		cd xmms && make

pacplay/pacplay: libpac.a pacplay/pacplay.c
		cd pacplay && make

clean:
		rm -f *~ *.o libpac.a libpac.so
