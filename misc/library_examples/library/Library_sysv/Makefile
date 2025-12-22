# If you use another compiler change the following line:
CC 	  = ppc-morphos-gcc
CDEFS   = -DUSE_INLINE_STDARG
CWARN   = -Wall -Wno-parentheses -Wno-missing-braces
CFLAGS  = $(CDEFS) $(CWARN) -noixemul -O2 -fomit-frame-pointer
LDFLAGS = -noixemul

OBJS    = Library.o sysv.o

all	: example_sysv.library

example_sysv.library: $(OBJS)
		  $(CC) $(LDFLAGS) -nostartfiles -o example_sysv.library.db $(OBJS)
		  ppc-morphos-strip --strip-unneeded --remove-section=.comment example_sysv.library.db -o $@

gen_includes:
		cvinclude.pl --fd=Developer/fd/library_sysv.fd --clib=Developer/clib/library_sysv_protos.h --inline=Developer/ppcinline/library_sysv.h -root=LIBRARY_SYSV

vbcc_includes:
		fd2pragma Developer/fd/library_sysv.fd SPECIAL 122 CLIB Developer/clib/library_sysv_protos.h TO Developer/inline

install:
		@copy example_sysv.library libs:
		@copy Developer/#? usr:include ALL

Library.o	: Library.c Library.h
sysv.o		: sysv.c sysv.h
