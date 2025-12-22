CC = gcc
CFLAGS = -noixemul -W -Wall
LDFLAGS = -s

app: amigamain.o app.o
	$(CC) $(CFLAGS) -o $@ amigamain.o app.o $(LDFLAGS)

amigamain.c: ex3.tg
	tg ex3.tg

app_strings.h: ex3.cd
	catcomp $< CFILE $@

amigamain.o: amigamain.c amigamain.h app.h app_strings.h
	$(CC) $(CFLAGS) -c -o $@ $<

app.o: app.c app.h amigamain.h app_strings.h
	$(CC) $(CFLAGS) -c -o $@ $<

ctfile:
	catcomp ex3.cd CTFILE deutsch.ct

catalog:
	catcomp ex3.cd deutsch.ct CATALOG catalogs/deutsch/app.catalog

clean:
	rm -f *.o
	rm -f app

