CC= sc
CFLAGS=
MAKE= make

all: knight rain worms fm


knight: knight.c
	$(CC) $(CFLAGS) link LIB llib:curses.lib lib:scm.lib $@

rain: rain.c
	$(CC) $(CFLAGS) link LIB llib:curses.lib lib:scm.lib $@

worms: worms.c
	$(CC) $(CFLAGS) link LIB llib:curses.lib lib:scm.lib $@

fm: fm.c
	$(CC) $(CFLAGS) link LIB llib:curses.lib $@

clean:
	-delete \#?.lnk \#?.o \#?.info

clobber:
	$(MAKE) clean
	-delete knight
	-delete rain
	-delete worms
	-delete fm
