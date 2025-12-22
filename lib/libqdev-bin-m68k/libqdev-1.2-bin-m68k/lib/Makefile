#
# 'qdev'
# by Burnt Chip Dominators
#
# Trigger defines (can be used either when building a library or when doing
# compile using library):
#
# -D___QDEV_NOQUADCOMPILER - Will define 'QUAD' as 'long' datatype and also
#                            if  possible will trickly use a workaround for
#                            code that needs 'long long'.
#
# -D___QDEV_FORCEQUAD      - Enforces  64bit computations(use this if 32bit 
#                            hacks allowing 64bit math dont work properly).
#
# -D___QDEV_NOREGARGS      - Will get rid of  'register' before datatype(if
#                            possible).
#
# -D___QDEV_FORCEPOOLS     - Will  redirect  'AllocMem()' / 'FreeMem()' and
#                            'AllocVec()' / 'FreeVec()'  pairs  to fullauto
#                            pool memory allocator if possible.
#
# -D___QDEV_DONTOUTMASK    - Dont mask previous object without touching new
#                            object area('a-mem_xxxconlogo.c').  Specifying
#                            this will disable anti-flicker while animating
#                            at high speed with movements.
#
# -D___QDEV_DOUBLEPREC     - Force  double  precision fraction arithmetics. 
#                            By setting this  macro  your program will most
#                            probably need 'mathieeedoub<XXX>.library'  and
#                            this  might  be a problem if the code is ought
#                            to work under plain ROM.
#
# -D___QDEV_NOIEEEMATH     - If no ___QDEV_DOUBLEPREC is specified then the
#                            non-IEEE  single  precision  'mathffp.library'
#                            will  be used. Generally  you want  to  define
#                            this as 'mathieeesingbas.library' in ROM 48068 
#                            has broken 'IEEESPDiv()' function!
#
# -D___QDEV_UTILITYCHAREQ  - Use 'utility.library' functions: 'ToLower()' /
#                            'ToUpper()' for  character equalisation. These
#                            functions may/will  be patched by the 'IPrefs'
#                            who  will  apply 'locale.library' equivalents.
#                            This is very handy for dealing with other than
#                            english   languages   in   functions  such as:
#                            'txt_stricmp()', 'txt_stristr()', and so on...
#
# -D___QDEV_NOECOREMAP     - Dont use low memory  'mem_remapbitmap2()', but
#                            prefer  the  assembly  supported version. This
#                            applies to 'mem_loadpicture()'.
#
# -D___QDEV_DEBUGINFO      - Allow  functions  to generate the debug infos.
#                            By default func. 'txt_vdebugprintf()'  will be
#                            used  which  behaves like 'kprintf()'. You can
#                            specify your own: -D___QDEV_DEBUGINFO=myfunc ,
#                            but a much better idea is to fiddle with debug
#                            support object('i-mem_dbsupport.c') only.
#
# -D___QDEV_DEBUGHILITE    - Define this is you want entry/exit messages to
#                            be highighted. This may really help in reading
#                            the  output.  This  switch  matters  only when
#                            building 'i-mem_dbsupport.c'!
#
# -D___QDEV_DEBUGCLEAN     - Allow  flag  cleanup, so parts of  code marked 
#                            'QDEVDBF_IRRELEVANT'  or  'QDEVDBF_OUTPUTONCE'
#                            will be free from these settings.
#
# -D___QDEV_DEBUGNOINTS    - When  specified   during   'txt_debugprintf()'
#                            compilation  then  the resulting function will
#                            stop interrupts when outputing. Use with care!
#
# -D___QDEV_NOEXTDECLS     - Do  not load and/or set external declarations.
#
# -D___QDEV_NOINTDECLS     - Skip  all native  function prototypes. This is
#                            useful when creating stubs.
#
# -D___QDEV_NOLOCALBASES   - Disable Local Base Support completly. This may
#                            be  needed  also  when doing strap compiles in
#                            case no library is available yet.
#
-include ../tools/Makefile.i
-include ../supp/sup_localbase/Makefile.i
-include ../supp/Makefile.i
-include Makefile.i

CPU = 
CFLAGS = $(OPTLEV) $(CPU) -Wall -I$(INCPATH)

CFLAGS += # -D___QDEV_NOQUADCOMPILER
CFLAGS += # -D___QDEV_FORCEQUAD
CFLAGS += # -D___QDEV_NOREGARGS
CFLAGS += # -D___QDEV_FORCEPOOLS
CFLAGS += # -D___QDEV_DONTOUTMASK
CFLAGS += # -D___QDEV_DOUBLEPREC
CFLAGS += -D___QDEV_NOIEEEMATH
CFLAGS += # -D___QDEV_UTILITYCHAREQ
CFLAGS += # -D___QDEV_NOECOREMAP
CFLAGS += # -D___QDEV_DEBUGNOINTS
CFLAGS += # -D___QDEV_NOEXTDECLS
CFLAGS += # -g

#
# Object identification inline.
#
ifneq ($(MKMP),)
CC += "`$(MKMP)$(MKMB) $(MKMP) $@`"
endif

#
# Per object, compiler command line arguments insertion.
#
ifneq ($(EXAP),)
CC += `$(EXAP)$(EXAB) $*.cli`
endif

#
# Global debugging. Use  this  only  when  you  must  examine  program flow
# bit  by  bit  as  it  will cause literally information flood! If you want
# 'APurify'  support  then be prepared for lots of hits! This is because it
# treats system structure accesses as illegal accesses, which is kinda true
# but not the case.
#
#G_CC = $(APF) $(GCC) -g
#G_DEBUG = $(DEBUGIO)

#
# Local debugging. See below.
#
#L_CC = $(APF) $(GCC) -g
L_DEBUG = $(DEBUGIO)


platform: $(QCRT0) $(LIBRARY) $(LIBRARYB) $(LIBRARYB32)

ifneq ($(G_DEBUG),)
G_DEBUGQO = $(OBJECTS_X)
else
G_DEBUGQO = -s
endif
ifneq ($(L_DEBUG),)
L_DEBUGQO = $(OBJECTS_X)
endif

$(LIBRARY): $(OBJECTS)
	make -C ../supp
	-rm -f $(LIBRARY)
	ar cr $(LIBRARY) $(SUPPOBJECTS) $(OBJECTS)
	ranlib $(LIBRARY)

$(LIBRARYB): $(OBJECTSB)
	make -C ../supp
	-rm -f $(LIBRARYB)
	ar cr $(LIBRARYB) $(SUPPOBJECTSB) $(OBJECTSB)
	ranlib $(LIBRARYB)

$(LIBRARYB32): $(OBJECTSB32)
	make -C ../supp
	-rm -f $(LIBRARYB32)
	ar cr $(LIBRARYB32) $(SUPPOBJECTSB32) $(OBJECTSB32)
	ranlib $(LIBRARYB32)

$(LIBRARYDB): $(OBJECTSDB)
	make -C ../supp
	-rm -f $(LIBRARYDB)
	ar cr $(LIBRARYDB) $(SUPPOBJECTS) $(OBJECTSDB)
	ranlib $(LIBRARYDB)

.c.o:
	$(G_CC) $(STDCPU) $(CFLAGS) $(G_DEBUG) -c $< -o $@

.c.qo:
	$(G_CC) $(STDCPU) $(CFLAGS) $(G_DEBUG) $(NOSTARTFILES) \
$< $(G_DEBUGQO) -o $@.in
	$(QOMKHEADERF) $@.in $(subst .c,,$<).h
	mv $@.in $@

.c.ob:
	$(G_CC) $(RESCPU) $(CFLAGS) $(G_DEBUG) $(RESIDENT) -c $< -o $@

.c.ob32:
	$(G_CC) $(RES32CPU) $(CFLAGS) $(G_DEBUG) $(RESIDENT32) -c $< -o $@

#
# Selective debugging. If you need to debug code within one or more objects
# then go 'Makefile.i' and add '_db' suffix to that object name.
#
.c.o_db:
	$(L_CC) $(STDCPU) $(CFLAGS) $(L_DEBUG) -c $< -o $@

.c.qo_db:
	$(G_CC) $(STDCPU) $(CFLAGS) $(L_DEBUG) $(NOSTARTFILES) \
$< $(L_DEBUGQO) -o $@.in
	$(QOMKHEADERF) $@.in $(subst .c,,$<).h
	mv $@.in $@

.c.o_dbb:
	$(L_CC) $(RESCPU) $(CFLAGS) $(L_DEBUG) $(RESIDENT) -c $< -o $@

.c.o_dbb32:
	$(L_CC) $(RES32CPU) $(CFLAGS) $(L_DEBUG) $(RESIDENT32) -c $< -o $@

.SUFFIXES: .o .qo .ob .ob32 .o_db .qo_db .o_dbb .o_dbb32

clean:
	make -C ../supp clean
	-rm -f *.o* *.qo* *.h *.in

cleandb:
	-rm -f *.o_db*

cleanall:
	make -C ../supp cleanall
	-rm -f *.o* *.qo* *.h *.in $(LIBRARY) $(LIBRARYB) $(LIBRARYB32)
