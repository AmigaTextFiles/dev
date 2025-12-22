# Generated automatically from Makefile.in by configure.
CC            = gcc
OPT           = -O6 -m68020
DEFS          = -DHAVE_CONFIG_H
INCLUDE       = -I..
CFLAGS        = $(OPT) $(DEFS) $(INCLUDE)
LDFLAGS       =
SHELL         = /bin/sh

LIBRARY       = ../libmpeg.a

mpegtest:	$(LIBRARY) mpegtest.o ParseArgv.o
		$(CC) $(LDFLAGS) mpegtest.o ParseArgv.o -o $@ -L.. -lmpeg
easympeg:	$(LIBRARY) easympeg.o
		$(CC) $(LDFLAGS) easympeg.o -o $@ $(LIBRARY) -lgl_s

mpegtest.o easympeg.o: Makefile

clean:
		rm -f mpegtest easympeg
		rm -f mpegtest.o ParseArgv.o easympeg.o mpegtest easympeg

distclean:
		rm -f Makefile
