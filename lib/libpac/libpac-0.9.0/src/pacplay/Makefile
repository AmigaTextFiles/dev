CC=gcc -mcrt=newlib
CFLAGS+=-W -Wall -Wno-unused -O2 -DNDEBUG -DCPU_IS_BIG_ENDIAN -I..
LIBS=-lm -lao

pacplay:	pacplay.o ../libpac.a
		${CC} ${CFLAGS} pacplay.o ../libpac.a -o pacplay ${LIBS} 

libpac.a:	
		cd .. && make libpac.a

clean:
		rm -rf *~ pacplay.o pacplay
