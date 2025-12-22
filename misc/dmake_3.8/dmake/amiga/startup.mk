# Generic DMAKE startup file.  Customize to suit your needs.
# See the documentation for a description of internally defined macros.
#
# Disable warnings for macros redefined here that were given
# on the command line.
__.SILENT := $(.SILENT)
.SILENT   := yes

# Configuration parameters for DMAKE startup.mk file
# Set these to NON-NULL if you wish to turn the parameter on.
_HAVE_RCS	:=  	# yes => RCS  is installed.
_HAVE_CWEB	:=	# yes => CWEB is installed.

# Applicable suffix definitions
A := .lib	# Libraries
E :=		# Executables
O := .o		# Objects
S := .a		# Assembler sources
V := 		# RCS suffix

# Recipe execution configurations
SHELL		:= 			# C:sksh
SHELLFLAGS	:= 			# -n -S -c
GROUPSHELL	:= 			# $(SHELL)
GROUPFLAGS	:= 			# -n -S
SHELLMETAS	:= 			# |();&<>?*][$$\\#`'"
GROUPSUFFIX	:=

# Standard C-language command names and flags
   CPP	   := sc:c/sc pponly nover	# C-preprocessor
   CC      := sc:c/sc nover		# C-compiler and flags
   CFLAGS   = 

   AS      := $(CC)			# Assembler and flags
   ASFLAGS  = 

   LD       = $(CC) link batch		# Loader and flags
   LDFLAGS  = 
   LDLIBS   =
   LINK     = $(LD) $(LDFLAGS) to $@ with $(mktmp $< $(LDLIBS))

# Definition of $(MAKE) macro for recursive makes.
   MAKE = $(MAKECMD) $(MFLAGS)

# Definition of Print command for this system.
#   PRINT = lp

# Language and Parser generation Tools and their flags
   YACC	  := bison		# standard yacc
   YFLAGS  =
   YTAB	  := y.tab		# yacc output files name stem.

   LEX	  := flex		# standard lex
   LFLAGS  =
   LEXYY  := lex.yy		# lex output file

# Other Compilers, Tools and their flags

   CO	   := co		# check out for RCS
   COFLAGS := -q

   AR     := sc:c/oml		# archiver
   ARFLAGS = -b

   RM	   := C:Delete		# remove a file command
   RMFLAGS  = QUIET

.PRECIOUS :

# Implicit generation rules for making inferences.
# We don't provide .yr or .ye rules here.  They're obsolete.
# Rules for making *$O
   %$O : %.c ; $(CC) $(CFLAGS) objname $@ $<
   %$O : %$S ; $(AS) $(ASFLAGS) objname $@ $<

# CWEB
.IF $(_HAVE_CWEB)
   CWEAVE := cweave		# CWEB -> TeX
   CWEAVEFLAGS := -b

   CTANGLE := ctangle   	# CWEB -> C
   CTANGLEFLAGS := -b

   TEX := virtex '&plain'	# TeX

   %.c : %.w ; $(CTANGLE) $(CTANGLEFLAGS) $< - $@
   %.tex : %.w ; $(CWEAVE) $(CWEAVEFLAGS) $< - $@
   %.dvi : %.tex ; $(TEX) $<
.ENDIF

# lex and yacc rules
   %.c : %.y %.Y ; $(YACC)  $(YFLAGS) $<; mv $(YTAB).c $@
   %.c : %.l %.L ; $(LEX)   $(LFLAGS) $<; mv $(LEXYY).c $@


# RCS support
.IF $(_HAVE_RCS)
   %.c : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   %$S : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   %.h : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   %.w : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   Makefile : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   %.mk : $$(@:d)RCS/$$(@:f)$V;- $(CO) $(COFLAGS) $@
   .NOINFER : $$(@:d)RCS/$$(@:f)$V
.END

# Recipe to make archive files.
%$A :
	$(AR) $(ARFLAGS) $@ r $?
	$(RM) $(RMFLAGS) $?

# DMAKE uses this recipe to remove intermediate targets
.REMOVE :; $(RM) $<

# AUGMAKE extensions for SYSV compatibility
@B = $(@:b)
@D = $(@:d)
@F = $(@:f)
"*B" = $(*:b)
"*D" = $(*:d)
"*F" = $(*:f)
<B = $(<:b)
<D = $(<:d)
<F = $(<:f)
?B = $(?:b)
?F = $(?:f)
?D = $(?:d)

# Turn warnings back to previous setting.
.SILENT := $(__.SILENT)

# Local startup file if any
.INCLUDE .IGNORE: "_startup.mk"
