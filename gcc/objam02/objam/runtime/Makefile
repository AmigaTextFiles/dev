# ObjectiveAmiga: Makefile for objc-*.library
# See GNU:lib/libobjam/ReadMe for details


GCC		= gcc
GCC_CFLAGS	= -V2.5.8 -O2 -I$(OBJCINCDIR) -DAMIGAOS_39

RM		= rm -f
CP		= cp
PERL		= /sys/shell-tools/perl
CONV_P		= /gnu/geninline/conv.p
FLUSH		= /c/flushlibs

OBJS		= libinitr.o objclib.o zone.o misc.o atom.o objects.o encoding.o sarray.o

# The library name has currently got compatibility codes in it. These enable me
# to do changes which affect backward compatibility. In that case the codes
# change. If ObjectiveAmiga will ever get finished, at least the Runtime code
# should disappear (or remain constant). The ObjC and Protocol versions are the
# ones of the gcc 2.5.8 Objective C compiler, the only one which is supported
# at the moment. In the future there could be other versions of the library for
# different gcc releases or maybe even one version which can deal with code
# from all compiler versions.
#
LIBNAME		= objc-5-2-3.library
#		       | | |		Compatibility codes
#	     ObjC -----+ | |		~~~~~~~~~~~~~~~~~~~
#	 Protocol -------+ |		Change in:
#	  Runtime ---------+		- include/libraries/objc.h


.c.o:
		$(GCC) $(GCC_CFLAGS) -o $@ $< -c

all:		install-headers $(LIBNAME)

$(LIBNAME): $(OBJS)
		$(GCC) -nostdlib -resident $(GCC_CFLAGS) -o $@ $(OBJS) -L/gnu/lib/libnix -lnix # -lamiga -lgcc
		-$(CP) $(LIBNAME) /libs/
		$(FLUSH)

install-headers: include/inline/objc.h
		-$(CP) include/libraries/objc.h $(OBJCINCDIR)/libraries/
		-$(CP) include/inline/objc.h $(OBJCINCDIR)/inline/
		-$(CP) include/proto/objc.h $(OBJCINCDIR)/proto/
		-$(CP) include/clib/objc_protos.h $(OBJCINCDIR)/clib/

include/inline/objc.h: objc_lib.fd include/clib/objc_protos.h
		$(PERL) $(CONV_P) include/clib/objc_protos.h objc_lib.fd > include/inline/objc.h

clean:
		-$(RM) *.o objc*.library
