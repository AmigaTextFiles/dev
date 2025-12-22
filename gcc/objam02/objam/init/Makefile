# ObjectiveAmiga: Makefile for objc_init.o
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -g -I.. $(PAR_GCC_FLAGS)

RM		= rm -f
CP		= cp


.c.o:
	$(GCC) -c $(GCC_CFLAGS) $<


all: objc_init.o install

objc_init.o:

install:
	$(CP) objc_init.o $(OBJCLIBDIR)/

clean:
	$(RM) *.o
