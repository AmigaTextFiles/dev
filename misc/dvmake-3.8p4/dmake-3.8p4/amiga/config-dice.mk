# This is an OS specific configuration file
#	It assumes that OBJDIR, TARGET and DEBUG are previously defined.
#	It defines	CFLAGS, LDARGS, CPPFLAGS, STARTUPFILE, LDOBJS
#			PRINTER, PRINTFLAGS
#	It augments	SRC, OBJDIR, TARGET, CFLAGS, LDLIBS
#
#PRINTER		= hw
#PRINTFLAGS	= -P$(PRINTER)

# Redefining original CFLAGS
# assuming it was before -I.
#CFLAGS = WITH $(OS)/SCOPTIONS
CFLAGS+= -s

STARTUPFILE	= s:startup.mk
CPPFLAGS	= $(CFLAGS)
LDOBJS		= $(CSTARTUP) $(OBJDIR)/{$(<:f)}
LDARGS		= $(LDFLAGS) -s -o $@ $(LDOBJS) $(LDLIBS)
LD		= $(CC)

# Debug flags
DB_CFLAGS	= dbg sf
DB_LDFLAGS	=
DB_LDLIBS	=

# NO Debug flags
NDB_CFLAGS	=
NDB_LDFLAGS	=
NDB_LDLIBS	=

# Local configuration modifications for CFLAGS.
CFLAGS	       += -I$(OS)

# Sources that should be non-os-dependent, but which had to
# be changed to make them ANSI-cleaner
NOSSRC := dmake.c function.c getinp.c infer.c make.c sysintf.c
.SETDIR=$(OS) : $(NOSSRC)

# Sources that must be defined for each different version
OSSRC := \
	arlib.c dirbrk.c environ.c getpid.c rmprq.c ruletab.c runargv.c\
	sasc.c tempnam.c utime.c putenv.c
SRC  += $(OSSRC)
.SETDIR=$(OS) : $(OSSRC)

# Set source dirs so that we can find files named in this
# config file.
.SOURCE.h : $(OS)
#.SOURCE.c : $(OS)

# Define new metarule for making objects
%$O : %.c
	%$(CC) -c $(CFLAGS) $< -o $@

# See if we modify anything in the lower levels.
.IF $(OSRELEASE) != $(NULL)
   .INCLUDE .IGNORE : $(OS)$(DIRSEPSTR)$(OSRELEASE)$(DIRSEPSTR)config.mk
.END
