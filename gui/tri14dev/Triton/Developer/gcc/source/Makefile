#
#  Triton - The object oriented GUI creation system for the Amiga
#  Written by Stefan Zeiger in 1993-1994
#  (c) 1993-1994 by Stefan Zeiger, All rights reserved
#
#  Makefile - Makefile for making the gcc support code
#             (c) 1994 by Gunther Nikl and Stefan Zeiger
#
#  [stz] I created the Triton support files on my system with gcc 2.6.0
#  (from the AmiNet CDROM #4), the gcc 2.3.3 compilers and the 'perl' binary
#  from the gcc 2.5.8 distribution on AmiNet. The version from FreshFish
#  7/94 does not work correctly with conv.p. trConv.p is a modified version
#  of conv.p, which recognizes TritonBase as (struct Library *).
#


CC	= gcc
RM	= /c/delete quiet
COPY	= /c/copy
PERL	= /sys/shell-tools/perl

CVERS	= -V2.3.3
CFLAGS	= -O6 -Ios-include -fno-function-cse $(CPUID) $(COPTS)

.SUFFIXES: $(O)

# common rule

.c$(O):
	@$(CC) $(CVERS) $(CFLAGS) -o $@ -c $<

# all object files

objs	= tr_openproject$(O) tr_closeproject$(O) tr_firstoccurance$(O) tr_numoccurances$(O) \
	  tr_geterrorstring$(O) tr_createapp$(O) tr_deleteapp$(O) tr_getmsg$(O) tr_replymsg$(O) \
	  tr_wait$(O) tr_closewindowsafely$(O) tr_getlasterror$(O) tr_lockscreen$(O) tr_unlockscreen$(O) \
	  tr_createapptags$(O) tr_openprojecttags$(O) tr_autorequesttags$(O) tr_easyrequesttags$(O) \
	  tr_openclose$(O) tr_getattribute$(O) tr_setattribute$(O) \
	  tr_lockproject$(O) tr_unlockproject$(O) \
	  tr_trlogo$(O)

# default target

all: os-include/inline/triton.h os-lib/libtriton.a os-lib/blibtriton.a os-lib/libtriton020.a os-lib/blibtriton020.a copylib

# several library versions

os-lib/libtriton.a:
		@$(MAKE) lib NAME=$@ O=.o 

os-lib/blibtriton.a:
		@$(MAKE) lib NAME=$@ O=.bo COPTS=-fbaserel

os-lib/libtriton020.a:
		@$(MAKE) lib NAME=$@ O=.o20 CPUID=-m68020

os-lib/blibtriton020.a:
		@$(MAKE) lib NAME=$@ O=.bo20 CPUID=-m68020 COPTS=-fbaserel

# cleanup 

clean:
	@echo "Cleaning up..."
	-@$(RM) \#?.o \#?.bo \#?.o20 \#?.bo20 os-include/inline/triton.h os-lib/\#?

# common target to build a special library

lib: os-include/inline/triton.h msg $(objs)
		@-$(RM) $(NAME)
		@ar -q $(NAME) $(objs)
		@ranlib $(NAME)
		@echo "done."

msg:
		@echo "creating -->" $(NAME) "<-- ..."

# install libraries

copylib:
	$(COPY) os-lib/\#?.a GNU:os-lib/

# inline header file

os-include/inline/triton.h: ../triton_lib.fd triton_protos.h trConv.p
	@echo "Creating inline header..."
	$(PERL) trConv.p triton_protos.h ../triton_lib.fd  >  os-include/inline/triton.h
	$(COPY) os-include/inline/triton.h GNU:os-include/inline/
