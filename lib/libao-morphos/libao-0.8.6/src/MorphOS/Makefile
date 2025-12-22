TARGET = ao.library

CC = ppc-morphos-gcc
LD = ppc-morphos-gcc
AR = ppc-morphos-ar


CDEFS			= -DAROS_ALMOST_COMPATIBLE
CFLAGS		= -noixemul $(CDEFS) -mcpu=750 -mstring -mmultiple -mresident32 -Wall -O2
CFLAGS2		= -noixemul $(CDEFS) -mcpu=750 -mstring -mmultiple -Wall -O3
CFLAGS_IX	= $(CDEFS) -mcpu=750 -mstring -mmultiple -Wall -O3
LIBS			= -lao

OBJS = Library.o Startup.o

ECHO = echo
ECHE = echo -e
BOLD = \033[1m
NRML = \033[22m

COMPILING = @$(ECHE) "compiling $(BOLD)$@$(NRML)..."
LINKING = @$(ECHE) "linking $(BOLD)$@$(NRML)..."
STRIPPING = @$(ECHE) "stripping $(BOLD)$@$(NRML)..."
ARCHIVING = @$(ECHE) "archiving $(BOLD)$@$(NRML)..."

all: $(TARGET) lib/libao.a

headers:
	cvinclude.pl --fd include/fd/ao_lib.fd --clib include/clib/ao_protos.h --inlines include/ppcinline/ao.h --vbccinlines include/inline/ao_protos.h --proto include/proto/ao.h --root=ao

Library.o: Library.c Library.h
	$(COMPILING)
	@$(CC) $(CFLAGS_IX) -c $< -o $@ 

%.o : %.c Library.h
	$(COMPILING)
	@$(CC) $(CFLAGS) -c $*.c -o $*.o

$(TARGET): $(OBJS)
	$(LINKING)
	@$(LD) -noixemul -nostartfiles -mresident32 -Wl,-Map=file.map -L../.libs -o $@.db $(OBJS) $(LIBS)
	$(STRIPPING)
	@ppc-morphos-strip -o $@ --remove-section=.comment $@.db

libao-startup.o: libao-startup.c
	$(COMPILING)
	@$(CC) -noixemul -mcpu=750 -mstring -mmultiple -Wall -O3 $(INCLUDES) -o $@ -c libao-startup.c

libao_glue.a: include/clib/ao_protos.h include/fd/ao_lib.fd include/ppcinline/ao.h include/proto/ao.h
	@cvinclude.pl --fd=include/fd/ao_lib.fd --clib=include/clib/ao_protos.h --gluelib=libao_glue.a

lib/libao.a: libao-startup.o libao_glue.a
	$(ARCHIVING)
	@-rm -f lib/libao.a
	@mv libao_glue.a lib/libao.a
	@$(AR) cru lib/libao.a libao-startup.o
	@ppc-morphos-ranlib lib/libao.a

clean:
	@-rm -f $(TARGET) $(TARGET).db *.map *.o *.a $(TARGET).dump

dump:
	objdump --disassemble-all --reloc $(TARGET).db >$(TARGET).dump