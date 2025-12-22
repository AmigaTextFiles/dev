CC = gcc
CFLAGS = -noixemul -W -Wall
LDFLAGS = -s

app: amigamain.o app.o
	$(CC) $(CFLAGS) -o $@ amigamain.o app.o $(LDFLAGS)

amigamain.c: ex1.tg
	tg ex1.tg

amigamain.o: amigamain.c amigamain.h app.h
	$(CC) $(CFLAGS) -c -o $@ $<

app.o: app.c app.h amigamain.h
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o
	rm -f app

