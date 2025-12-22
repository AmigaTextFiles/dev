# ObjectiveAmiga: Makefile for libobjc.a
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -g -I.. $(PAR_GCC_FLAGS)

AR		= ar
AR_FLAGS	= rc

RANLIB		= ranlib

RM		= rm -f
CP		= cp


OBJC_O	= hash.o class.o sendmsg.o init.o archive.o \
	  selector.o Object.o Protocol.o


OBJC_H	= hash.h list.h objc.h \
	  objc-api.h \
	  Object.h Protocol.h typedstream.h


.SUFFIXES: .m


.c.o:
	$(GCC) -c $(GCC_CFLAGS) $<

.m.o:
	$(GCC) -fgnu-runtime -c $(GCC_CFLAGS) $<


all: libobjc.a install

libobjc.a: install-headers $(OBJC_O)
	$(RM) libobjc.a
	$(AR) rc libobjc.a $(OBJC_O)
	$(RANLIB) libobjc.a

install-headers:
	$(CP) $(OBJC_H) $(OBJCINCDIR)/objc/

install: install-headers
	$(CP) libobjc.a $(OBJCLIBDIR)/

clean:
	$(RM) *.o libobjc.a
