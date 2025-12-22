#
# template
#
# Small user friendly template  allows to create handy tools
# in minutes.
#
# Beware! By default all  binaries will be 'resident', which
# is unsuitable when going  do debug! Please switch to reloc
# mode(standard) if  this is  the case or when your programs
# are bigger than 64 kilos.
#

#
# Binary modes possible: S(std), R(resident), R32(32bit res)
#
BINARYMODE = R

-include ../../tools/Makefile.i
-include ../../tools/Makefile.stubs
-include ../../lib/Makefile.i

PROGGY = template


MAINLIB = $(MAINLIBP)/$(BMLIBRARY)
CFLAGS = $(OPTLEV) $(BMCPU) $(BMCFLAGS) -I../$(INCPATH) -Wall
LDFLAGS = -s $(BMLDFLAGS)
LIBS = $(MAINLIB) $(BMLPATH) $(LIBNIX)


platform: $(PROGGY)

$(MAINLIB): $(COBJECTS)
	make -C ../../lib

$(PROGGY): $(PROGGY).c $(MAINLIB)
	$(CC) $(CFLAGS) $(LDFLAGS) $(PROGGY).c -o $@ $(LIBS)

clean:

cleanall:
	-rm -f $(PROGGY)
