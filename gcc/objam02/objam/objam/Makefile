# ObjectiveAmiga: Makefile for libobjam.a
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -g $(PAR_GCC_FLAGS)

AR		= ar
AR_FLAGS	= rc

RANLIB		= ranlib

RM		= rm -f
CP		= cp


OBJC_O	= RexxHost.o Application.o FlatList.o ExecList.o FileList.o \
	  ArgumentParser.o
	  
OBJC_H	= RexxHost.h Application.h FlatList.h ExecList.h FileList.h \
	  ArgumentParser.h \
	  objam.h
	  

.SUFFIXES: .m

.m.o:
	$(GCC) -c $(GCC_CFLAGS) $<


all: libobjam.a install

libobjam.a: copy-includes $(OBJC_O)
	$(RM) libobjam.a
	$(AR) rc libobjam.a $(OBJC_O)
	$(RANLIB) libobjam.a

copy-includes:
	$(CP) $(OBJC_H) $(OBJCINCDIR)/objam/

install: copy-includes
	$(CP) libobjam.a $(OBJCLIBDIR)/

clean:
	$(RM) *.o libobjam.a
