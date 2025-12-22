# Makefile for GNU patch using SAS/C 6.3.

CC = sc

LIBS =

CFLAGS = IGN=85+94+100+154+161+304 DEF=AMIGA OPT
LDFLAGS = LINK STRIPDBG

SRCS = backupfile.c getopt.c getopt1.c inp.c patch.c pch.c util.c \
	version.c rename.c alloca.c
OBJS = backupfile.o getopt.o getopt1.o inp.o patch.o pch.o util.o \
	version.o alloca.o
HDRS = EXTERN.h INTERN.h backupfile.h common.h getopt.h \
	inp.h patchlevel.h pch.h util.h version.h

all: patch

.c.o:
	$(CC) $(CFLAGS) $<

patch: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) $(LIBS) TO=$@

backupfile.o: backupfile.c config.h backupfile.h
getopt.o: getopt.c getopt.h
getopt1.o: getopt1.c getopt.h
inp.o: inp.c config.h common.h inp.h util.h EXTERN.h INTERN.h pch.h
patch.o: patch.c config.h common.h inp.h pch.h util.h version.h backupfile.h \
	INTERN.h EXTERN.h getopt.h
pch.o: pch.c config.h common.h pch.h util.h EXTERN.h INTERN.h
util.o: util.c config.h common.h util.h backupfile.h EXTERN.h INTERN.h
version.o: version.c config.h common.h version.h patchlevel.h util.h \
	EXTERN.h INTERN.h
