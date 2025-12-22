
# Wipeout -- Traces memory, munges and traces memory trashing
#
# Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
# Public Domain
#
# $Id: Makefile,v 1.7 2009/06/14 22:03:57 itix Exp $

STRIP		= strip
CC			= gcc -noixemul
CDEFS 	= -DUSE_INLINE_STDARG
#CFLAGS	= $(CDEFS) -O3 -finline-functions -funroll-loops -mcpu=750 -mmultiple -mstring -Wall
CFLAGS	= $(CDEFS) -O2 -finline-functions -mcpu=750 -mmultiple -mstring -Wall
TARGET	= Wipeout

#############################################################################
#
# Program version and revision; must match the data in the bumprev file
# as it's used to check in and freeze a release.
#
#############################################################################

VERSION	= 1
REVISION	= 33
SYMBOLIC_NAME	= V$(VERSION)_$(REVISION)

OBJS  = startup.o addresstest.o allocator.o data.o dprintf.o dump.o fillchar.o filter.o installpatches.o main.o mungmem.o monitoring.o \
			nametag.o pools.o privateallocvec.o segtracker.o taskinfo.o timer.o tools.o

ECHO = echo
ECHE = echo -e
BOLD = \033[1m
NRML = \033[22m

COMPILING = @$(ECHE) "compiling $(BOLD)$@$(NRML)..."
LINKING = @$(ECHE) "linking $(BOLD)$@$(NRML)..."
STRIPPING = @$(ECHE) "stripping $(BOLD)$@$(NRML)..."
ARCHIVING = @$(ECHE) "archiving $(BOLD)$@$(NRML)..."

%.o: %.c
	$(COMPILING)
	@$(CC) $(CFLAGS) -o $@ -c $*.c

all: $(TARGET) test

addresstest.o		: addresstest.c protos.h
allocator.o		: allocator.c protos.h allocator.h installpatches.h
data.o			: data.c protos.h data.h
dprintf.o		: dprintf.c protos.h
dump.o			: dump.c protos.h
fillchar.o		: fillchar.c protos.h
filter.o		: filter.c protos.h
installpatches.o	: installpatches.c protos.h installpatches.h
main.o			: main.c protos.h Wipeout_rev.h wipeoutsemaphore.h
mungmem.o		: mungmem.c protos.h installpatches.h
monitoring.o		: monitoring.c protos.h installpatches.h
nametag.o		: nametag.c protos.h
pools.o			: pools.c protos.h installpatches.h
privateallocvec.o	: privateallocvec.c protos.h installpatches.h
segtracker.o		: segtracker.c protos.h
startup.o         : startup.c protos.h
taskinfo.o		: taskinfo.c protos.h taskinfo.h
timer.o			: timer.c protos.h
tools.o			: tools.c protos.h

$(TARGET): $(OBJS)
	$(LINKING)
	@$(CC) -nostartfiles $(OBJS) -o $@.db
	$(STRIPPING)
	@$(STRIP) --remove-section=.comment $@.db -o $@
	@chmod u+x $(TARGET)

test: test.c
	$(LINKING)
	@$(CC) $(CFLAGS) -o $@.db $@.c -ldebug
	$(STRIPPING)
	@$(STRIP) --remove-section=.comment $@.db -o $@
	@chmod u+x $@

dump:
	objdump --disassemble-all $(TARGET).db >$(TARGET).s

clean: 
	@rm -f *.o *.s $(TARGET) *.a *.db
