#
# lisa Makefile
#

# BINDIR is the place you want to put the binaries,
#        should be in your search path.
BINDIR=/usr/bin

lisa:
	cd src; make -f Makefile

install:
	strip src/lisa
	cp src/lisa $(BINDIR)
