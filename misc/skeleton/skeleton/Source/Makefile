#
# Revision control info:
# $Id$
#
# $Log$

#################################
#								#
# SAS C 6.55 makefile			#
# for the Skeleton project		#
#								#
#								#
# Jörgen Grahn					#
#								#
#################################

MAIN	= 
SRC		= <all .c files>
HDRS	= <all .h files>
OBJS	= <all .o files>
OTHER	= SCOPTIONS <all other files that should be RCS'd>
RCS		= $(SRC) $(HDRS) $(OTHER)
NO_RCS	= Makefile <files that should be left alone by RCS>

#################################

all: skeleton1 skeleton2 <list of executables>

#################################

skeleton1: skeleton1.o <all other .o files for this>
	$(CC) LINK TO $@ FROM <same as the row above>

#################################

skeleton2: skeleton2.o <all other .o files for this>
	$(CC) LINK TO $@ FROM <same as the row above>

#################################

<rules for creating object files: let a program like SAS mkmk
 take care of that and copy the results in here. Default rules
 will do.> 



#################################

archive:
# store the current state of the project
# don't forget reloading any files
# currently in your editor!
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

checkout:
# start working on the project
# the -M flag is a bit questionable;
# see the docs
#	co -l -M $(RCS)
	co -l $(RCS)

#################################

checkin:
# end working on the project for now
	ci -r $(RCS)

#################################

install:
# to make a version accessible;
# put it on the path along with
# icons/support files, possibly
# docs as well
	Copy CLONE Skeleton1 Skeleton2 TO <somewhere>

#################################

distribution:
# to create a distribution archive, complete with
# sources, binaries, docs and support files, but
# without temporary files

#################################

clean:
# remove all generated files
	Delete \#?.(o|lnk) skeleton1 skeleton2
