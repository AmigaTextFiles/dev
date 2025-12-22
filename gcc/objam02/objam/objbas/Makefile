# ObjectiveAmiga: Makefile for libobjbas.a
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -g $(PAR_GCC_FLAGS)

AR		= ar
AR_FLAGS	= rc

RANLIB		= ranlib

RM		= rm -f
CP		= cp


OBJC_O	= Array.o IdArray.o String.o
	  
OBJC_H	= Array.h IdArray.h String.h
	  


.SUFFIXES: .m


.c.o:
	$(GCC) -c $(GCC_CFLAGS) $<

.m.o:
	$(GCC) -c $(GCC_CFLAGS) $<


all: libobjbas.a install

libobjbas.a: copy-includes $(OBJC_O)
	$(RM) libobjbas.a
	$(AR) rc libobjbas.a $(OBJC_O)
	$(RANLIB) libobjbas.a

copy-includes:
	$(CP) $(OBJC_H) $(OBJCINCDIR)/objbas/

install: copy-includes
	$(CP) libobjbas.a $(OBJCLIBDIR)/

clean:
	$(RM) *.o libobjbas.a
