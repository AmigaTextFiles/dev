#
# 'qdev'
# by Burnt Chip Dominators
#
# Local Base Support.
#
INCPRFX = ../
LIBPRFX = ../
-include ../../tools/Makefile.i
-include ../../lib/Makefile.i
-include Makefile.i
-include ../Makefile.i


CFLAGS = $(OPTLEV) $(CPU) -Wall -I../$(INCPATH)


all: platform

platform: $(SUP_LBSCOBJS) $(SUP_LBSCOBJSB) $(SUP_LBSCOBJSB32)

.c.o:
	$(CC) $(STDCPU) $(CFLAGS) -c $< -o $@

.c.ob:
	$(CC) $(RESCPU) $(CFLAGS) $(RESIDENT) -c $< -o $@

.c.ob32:
	$(CC) $(RES32CPU) $(CFLAGS) $(RESIDENT32) -c $< -o $@

.SUFFIXES: .o .ob .ob32

clean:

cleanall:
	-rm -f *.o*
