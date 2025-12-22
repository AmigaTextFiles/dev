#
# $Id: Makefile 1.3 1995/12/06 21:16:20 JöG Exp JöG $
#

#################################
#								#
# SAS C 6.55 makefile			#
# for the Nucifraga project		#
#								#
# Jörgen Grahn					#
#								#
#################################

#
# $Log: Makefile $
# Revision 1.3  1995/12/06  21:16:20  JöG
# added a global version source
#
# Revision 1.2  1995/10/23  20:24:10  JöG
# *** empty log message ***
#
# Revision 1.1  1995/10/18  14:47:40  JöG
# Initial revision
#

MAIN	= 
SRC		= list.c memory.c pool.c r250.c sprintf.c statusclass.c version.c
HDRS	= list.h memory.h pool.h r250.h support.h statusclass.h
OBJS	= list.o memory.o pool.o r250.o sprintf.o statusclass.o version.o
OTHER	= SCOPTIONS Nucifraga.guide
RCS		= $(SRC) $(HDRS) $(OTHER)
NO_RCS	= Makefile RCS_link

#################################

all: nucifraga.lib

#################################

nucifraga.lib: $(OBJS)
	oml -n $@ r $(OBJS)

#################################

list.o: list.c list.h

pool.o: pool.c pool.h

memory.o: memory.c memory.h

r250.o: r250.c r250.h

sprintf.o: sprintf.c support.h

statusclass.o: statusclass.c statusclass.h

versiom.o: version.c

#################################

archive:
# store the current state of the project
	ci -l $(RCS)

#################################

rev:
# bump AmigaDOS revision,
# and assign this revision to
# the current revision of all
# sources
	SetEnv BUMPTMP `Bump version.c`
	@GetEnv BUMPTMP
	ci -l $(RCS)
	rcs -n\$BUMPTMP: $(RCS)

#################################

install:
# to make a version accessible;
# put it on the path along with
# icons/support files
	Copy CLONE nucifraga.lib TO LIB:
	Copy CLONE $(HDRS) TO Include:nucifraga/

#################################

checkout:
# start working on the project
	co -l -M $(RCS)

#################################

checkin:
# end working on the project for now
	ci -r $(RCS)

#################################

clean:
	Delete \#?.o nucifraga.lib
