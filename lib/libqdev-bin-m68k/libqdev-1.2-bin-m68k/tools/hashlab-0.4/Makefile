#
# hashlab
# by megacz
#
# Important! Please regenerate your old 'netinclude' proto and
# inline files by doing the following in Amiga shell:
#
#    cd gg:netinclude
#    fd2pragma fd/socket_lib.fd clib clib/socket_protos.h to inline special 40
#    fd2pragma fd/socket_lib.fd clib clib/socket_protos.h to proto special 38
#
-include ../Makefile.i
-include ../Makefile.stubs
-include ../../lib/Makefile.i

PROGGY = hashlab
HEADER = hashlab.h

DAEMON = hashlabd

MODULES = mod_dummy.hl     \
          mod_fnv128ai.hl  \
          mod_pjw64i.hl    \
          mod_fnv64ai.hl   \
          mod_sfh32i.hl    \
          mod_quick32i.hl  \
          mod_ugly32.hl    \
          mod_ap32.hl      \
          mod_fnv32.hl     \
          mod_bp32.hl      \
          mod_dek32.hl     \
          mod_djb32.hl     \
          mod_sdbm32.hl    \
          mod_bkdr32.hl    \
          mod_elf32.hl     \
          mod_js32.hl      \
          mod_rs32.hl      \
          mod_pjw32.hl



MAINLIB = $(MAINLIBP)/$(BMLIBRARY)
STDMAINLIB = $(MAINLIBP)/$(LIBRARY)
CFLAGS = $(OPTLEV) $(BMCPU) $(BMCFLAGS) -I../$(INCPATH) \
-I/gg/netinclude -Wall
LDFLAGS = -s $(BMLDFLAGS)
LIBS = $(MAINLIB) $(BMLPATH) $(LIBNIX) $(LIBAMIGA)
MCFLAGS = $(OPTLEV) $(STDCPU) $(STDCFLAGS) -I../$(INCPATH) \
-I/gg/netinclude -Wall
DCFLAGS = $(OPTLEV) -D_PTHREAD_PRIVATE -I../$(INCPATH) -Wall
DLIBS = -I/usr/local/include -L/usr/local/lib -lpthread

CFLAGS += -D___HASHLAB_USEPOOLS
CFLAGS += #-D___HASHLAB_USEALLOC


platform: $(PROGGY) $(MODULES)

$(MAINLIB): $(COBJECTS)
	make -C ../../lib

$(PROGGY): $(PROGGY).c $(HEADER) $(MAINLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) $(PROGGY).c -o $@ $(LIBS)

$(DAEMON): $(DAEMON).c $(HEADER) $(MAINLIB)
	$(CC) $(DCFLAGS) $(DAEMON).c -o $@ $(DLIBS)

.c.hl:
	$(CC) $(MCFLAGS) -s $(NOSTARTFILES) $< -o $@ $(STDMAINLIB)

*.hl: $(HEADER)

.SUFFIXES: .hl

clean:

cleanall:
	-rm -f $(PROGGY) $(DAEMON) $(MODULES)
