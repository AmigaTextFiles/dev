# If you use another compiler change the following line:
CC 	  = ppc-morphos-gcc
CDEFS   = -DUSE_INLINE_STDARG
CWARN   = -Wall -Wno-parentheses -Wno-missing-braces
CFLAGS  = $(CDEFS) $(CWARN) -noixemul -O2 -fomit-frame-pointer
LDFLAGS = -noixemul

OBJS		= Library.o 68kgate.o

all	: example_m68k.library

example_m68k.library: $(OBJS)
		  $(CC) $(LDFLAGS) -nostartfiles -o example_m68k.library.db $(OBJS)
		  ppc-morphos-strip --strip-unneeded --remove-section=.comment example_m68k.library.db -o $@

gen_includes:
		cvinclude.pl --fd=Developer/fd/library_68kgate.fd --clib=Developer/clib/library_68kgate_protos.h --inline=Developer/ppcinline/library_68kgate.h -root=LIBRARY_GATE

vbcc_includes:
		fd2pragma Developer/fd/library_68kgate.fd SPECIAL 122 CLIB Developer/clib/library_68kgate_protos.h TO Developer/inline

install:
		@copy example_68kgate.library libs:
		@copy Developer/#? usr:include ALL

Library.o	: Library.c Library.h
68kgate.o	: 68kgate.c 68kgate.h
