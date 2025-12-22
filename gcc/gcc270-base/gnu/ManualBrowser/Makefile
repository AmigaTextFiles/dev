# Makefile, for GNU-C 2.6.0
# Note: it seems that -fbaserel is broken, therefore I don't use it. -:(
# Note: this makefile probably doesn't work. I couldn't test it,
#       since several parts of my system are broken -:(

CPU		= 68000

DISTFILE	= ManualBrowser1_1.lha

EXEC		= ManualBrowser
CSOURCE		= main.c DynamicHost.c
SASSOURCE	= SAS_Startup.a SAS_Sprintf.a
GCCSOURCE	= GCC_Startup.s GCC_Sprintf.s HookEntryA1.s
OTHERSOURCE	= lmkfile Makefile Inlines.h Globals.h
DOCS		= ManualBrowser.guide ManualBrowser.readme COPYING
OTHER		= ManualBrowser.config

PGP_RELATED	= md5_DigestFile.asc md5_DigestFile t:md5_DigestFile stieber.asc

DISTFILES1	= $(EXEC) $(CSOURCE) $(SASSOURCE) $(OTHERSOURCE)
DISTFILES2	= $(GCCSOURCE) $(DOCS) $(OTHER)

OBJS		= $(GCCSOURCE:.s=.o) $(CSOURCE:.c=.o)

CC = gcc -m$(CPU)
CPPFLAGS = -DV39 -DUtilityBase=__UtilityBase
CFLAGS = -Wall -Wpointer-arith -Wmissing-prototypes -O2
LDFLAGS = -noixemul -nostartfiles -s
ASFLAGS = -mc$(CPU)

all: $(EXEC)

ManualBrowser: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

main.o:		main.c Globals.h Inlines.h
DynamicHost.o:	DynamicHost.c Globals.h Inlines.h

COPYING: man:GNU/COPYING
	copy man:GNU/COPYING COPYING

stieber.asc:
	pgp -kxa stieber stieber

md5_DigestFile.asc: md5_DigestFile
	pgp <>KCON:0/16/640/150/PGP -sat +clearsig=on md5_DigestFile

md5_DigestFile: $(EXEC) $(DISTFILES1) $(DISTFILES2) stieber.asc
	md5sum >t:md5_DigestFile -b $(EXEC)
	md5sum >>t:md5_DigestFile $(DISTFILES1)
	md5sum >>t:md5_DigestFile $(DISTFILES2)
	join t:md5_DigestFile stieber.asc TO md5_DigestFile
	Delete t:md5_DigestFile

clean:
	@-Delete $(OBJS) $(EXEC) $(DISTFILE) $(PGP_RELATED) COPYING

dist: $(DISTFILE)

$(DISTFILE): md5_DigestFile.asc
	@-Delete $(DISTFILE)
	lha -aAFv0 a $(DISTFILE) $(EXEC) $(DISTFILES1) $(DISTFILES2) md5_DigestFile.asc
