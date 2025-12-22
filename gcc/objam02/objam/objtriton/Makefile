# ObjectiveAmiga: Makefile for libobjtriton.a
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -g $(PAR_GCC_FLAGS)

AR		= ar
AR_FLAGS	= rc

RANLIB		= ranlib

RM		= rm -f
CP		= cp


OBJC_O	= TRApplication.o TRWindow.o
	  
OBJC_H	= TRApplication.h TRWindow.h
	  

.SUFFIXES: .m

.m.o:
	$(GCC) -c $(GCC_CFLAGS) $<


all: libobjtriton.a install

libobjtriton.a: copy-includes $(OBJC_O)
	$(RM) libobjtriton.a
	$(AR) rc libobjtriton.a $(OBJC_O)
	$(RANLIB) libobjtriton.a

copy-includes:
	$(CP) $(OBJC_H) $(OBJCINCDIR)/objtriton/

install: copy-includes
	$(CP) libobjtriton.a $(OBJCLIBDIR)/

clean:
	$(RM) *.o libobjtriton.a
