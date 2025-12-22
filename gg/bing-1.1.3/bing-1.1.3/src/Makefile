#
# $Id: Makefile, unofficial v1.1.3
#


##########
#
# Customise the following variables to match your configuration standards
#
##########

BINDIR=/usr/bin
MANDIR=/usr/man


##########
#
# Uncomment the lines below as appropriate for your platform.
#
##########

# Uncomment if you need the 4.4 BSD compatibility includes.
#  -> required on Linux (and Win32)
COMPAT_INCS = -Iinclude

# Maybe specify some specific compatibility options
#  -> on AIX activate the BSD mode
#COMPAT_DEFS= -D_BSD

# On some systems you may need to link with specific libraries
#  -> on SunOS 5 (Solaris) link with
#COMPAT_LIBS=-lnsl -lsocket -L/usr/ucblib -lucb

# Define if you lack srandom()/random()
#  -> required on Solaris (and Win32)
#NO_RANDOM = -DNO_RANDOM=1

# Define to use srandom/random rather than srand/rand
#  -> required on SunOS 4.1.3, SunOS 5, AIX 2 (BOSX 2 really), OSF1 V2.0
NO_SNPRINTF = -DNO_SNPRINTF=1

# Define if you lack strerror()
#NO_STRERROR = -DNO_STRERROR=1

# You may optionally provide some optimisation flags. Optimising bing for 
# speed should slightly improve the results.
#  -> if you want to debug bing define
#COPTIM = -g
#  -> on Linux, SunOS 4 and OSF1 V2.0 you may specify
COPTIM = -O2
#  -> on Solaris you may use
#COPTIM = -O
# on some hosts like AIX, HP-UX the optimisation options are already set

##########
#
# Define where tools are stored
#
##########

INSTALL=install -c
GROFF=groff
NROFF=nroff
RM=/bin/rm


##########
#
# Compilation rules
#
##########

BINCS = \
	-I. \
	$(COMPAT_INCS)

BDEFS = \
	$(COMPAT_DEFS) \
	$(NO_RANDOM) \
	$(NO_SNPRINTF) \
	$(NO_STRERROR) \
	$(CDEBUG)

BLIBS = \
	$(COMPAT_LIBS)

OBJS=	bing.o icmp_ux.o

all:	bing bing.0 bing.ps

dist:	clean bing.0 bing.ps

bing.o:		bing.c mod_icmp.h
	$(CC) $(CFLAGS) $(BINCS) $(BDEFS) -o $@ -c bing.c

icmp_ux.o:	unix/icmp_ux.c mod_icmp.h
	$(CC) $(CFLAGS) $(BINCS) $(BDEFS) -o $@ -c unix/icmp_ux.c

bing:	$(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(BLIBS) 

bing.ps: unix/bing.8
	$(GROFF) -man unix/bing.8 > bing.ps

bing.0: unix/bing.8
	$(NROFF) -man unix/bing.8 > bing.0

clean:
	$(RM) -f bing bing.ps bing.0 $(OBJS)

install: bing unix/bing.8
	$(INSTALL) -m 644 -o man -g man unix/bing.8 $(MANDIR)/man8
	$(INSTALL) -m 4555 -o root -g staff bing $(BINDIR)
