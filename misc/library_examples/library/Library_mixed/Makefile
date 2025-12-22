# If you use another compiler change the following line:
CC 	  = ppc-morphos-gcc
CDEFS   = -DUSE_INLINE_STDARG
CWARN   = -Wall -Wno-parentheses -Wno-missing-braces
CFLAGS  = $(CDEFS) $(CWARN) -noixemul -O2 -fomit-frame-pointer
LDFLAGS = -noixemul

OBJS    = Library.o sysv.o m68k.o

all	: example_mixed.library

example_mixed.library: $(OBJS)
		  $(CC) $(LDFLAGS) -nostartfiles -o example_mixed.library.db $(OBJS)
		  ppc-morphos-strip --strip-unneeded --remove-section=.comment example_mixed.library.db -o $@

gen_includes:
		cvinclude.pl --fd=Developer/fd/library_mixed.fd --clib=Developer/clib/library_mixed_protos.h --inline=Developer/ppcinline/library_mixed.h -root=LIBRARY_MIXED

vbcc_includes:
		fd2pragma Developer/fd/library_mixed.fd SPECIAL 122 CLIB Developer/clib/library_mixed_protos.h TO Developer/inline

install:
		@copy example_mixed.library libs:
		@copy Developer/#? usr:include ALL

Library.o	: Library.c Library.h
sysv.o		: sysv.c sysv.h
m68k.o		: m68k.c m68k.h