# $Id: Makefile,v 1.10 1997/11/09 23:52:45 lars Exp $
#--------------------------------------------------------------------------
# Makefile for MkDepend
#
# Written for use with DICE 3 and Dennis Vadura's DMake 3.8p4.
# It assumes a proper startup.mk .
#--------------------------------------------------------------------------
# Available targets:
#  MkDepend: creates the program.
#  clean   : deletes all objects, test.#? and a.out.
#  clobber : same as clean, also deletes the executable.
#  depend  : updates the Makefile by the source dependencies.
#  archive : creates an archive MkDepend-<version>.lha
#  deposit : deposits all existing files back into the RCS archive, using
#	     RCSTATE as release state when defined. The state of the files
#	     in the RCS deposit is not changed.
#--------------------------------------------------------------------------
# $Log: Makefile,v $
# Revision 1.10  1997/11/09  23:52:45  lars
# RELEASE 1.4
#
# Revision 1.9	1997/11/08  19:00:08  lars
# Updated to archive GNUMakefile as well.
#
# Revision 1.8	1996/03/02  21:29:28  lars
# *** empty log message ***
#
# Revision 1.7	1996/03/02  21:23:03  lars
# More RCS tweaks to 'archive'.
#
# Revision 1.6	1996/03/02  21:18:36  lars
# RCS tweaks to target 'archive'.
#
# Revision 1.5	1996/03/02  20:58:11  lars
# Added new target 'deposit'.
#
# Revision 1.4	1996/03/02  20:46:56  lars
# New Release.
#
# Revision 1.3	1996/02/25  20:55:56  lars
# Put under RCS.
#
#--------------------------------------------------------------------------

# Release version, should match the version number in main.c and DMakefile.
VERSION= 1.4

#--------------------------------------------------------------------------
# Source files
SOURCES= args.c main.c reader.c nodes.c

# Other files to archive
OTHER= {$(SOURCES:b)}.h Makefile DMakefile GNUMakefile \
       HISTORY MkDepend.doc MkDepend.readme

# Object files to generate
OBJECTS= obj/{$(SOURCES:b)}.o

# Check prototypes on compilation
CFLAGS+= -proto

# Default rule to compile objects into a subdirectory obj/
%$O : $$(@:b).c ; $(CC) $(CFLAGS) -c $< -o $@

# Set _RCSTATE to the check-in state.
.IF $RCSTATE
_RCSTATE= -s$(RCSTATE)
.END

#--------------------------------------------------------------------------

MkDepend : obj

MkDepend : $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS)

clean :
	rcsclean
	-delete #?.o test.#? a.out
	-delete obj/#?.o

clobber : clean
	-delete MkDepend MkDepend-#?.readme MkDepend-#?.lha
	-delete obj all

depend : $(SOURCES)
	MkDepend $(SOURCES) -p.c:obj/%n.o -fMakefile


archive : $(SOURCES) $(OTHER) depend MkDepend
	delete Makefile.bak force
	makedir MkDepend-$(VERSION)
	copy MkDepend $(SOURCES) $(OTHER) MkDepend-$(VERSION) clone
	copy MkDepend.readme MkDepend-$(VERSION).readme
	+protect MkDepend-$(VERSION) +wd all
	+protect MkDepend-$(VERSION).readme +wd
	-delete MkDepend-$(VERSION).lha
	lha -axmr a MkDepend-$(VERSION).lha MkDepend-$(VERSION)
	delete MkDepend-$(VERSION) all quiet
	@+echo "Archive created."

deposit :
	ci $(_RCSTATE) $(SOURCES) $(OTHER)

obj :
	makedir obj

# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS FOLLOW ---
obj/args.o : args.h main.h

obj/main.o : args.h main.h nodes.h reader.h

obj/nodes.o : nodes.h

obj/reader.o : reader.h

# --- DO NOT MODIFY THIS LINE -- AUTO-DEPENDS PRECEDE ---
