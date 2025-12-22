PREFIX=/usr/local

ALL: cwtext cwpcm 

install: ALL
	install -sc cwtext ${PREFIX}/bin
	install -sc cwpcm ${PREFIX}/bin

cwpcm: cwpcm.o morse.o pcm.o
	gcc -o cwpcm -lm $^ -Xlinker -s

cwtext: cwtext.o morse.o
	gcc -o cwtext  $^ -Xlinker -s

cwpcm.o: cwpcm.c morse.h pcm.h
	gcc -c cwpcm.c

cwtext.o: cwtext.c morse.h
	gcc -c cwtext.c

morse.o: cw.h morse.h morse.h
	gcc -c morse.c

pcm.o: pcm.c pcm.h
	gcc -c pcm.c

cw.h: gencw.py
	python gencw.py > cw.h


clean:
	-rm -f *.o cwpcm cwtext core
