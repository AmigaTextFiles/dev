/* $Id: dosasl.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/dos/dos'
MODULE 'target/exec/types'
{#include <dos/dosasl.h>}
NATIVE {DOS_DOSASL_H} CONST

/* PRIVATE structure, which describes an anchor for matching functions. */
NATIVE {AChain} OBJECT achain
    {an_Child}	child	:PTR TO achain  /* The next anchor */
    {an_Parent}	parent	:PTR TO achain /* The last anchor */

    {an_Lock}	lock	:BPTR     /* Lock of this anchor */
    {an_Info}	info	:fileinfoblock     /* The fib, describing this anchor */
    {an_Flags}	flags	:BYTE    /* see below */
    {an_String}	string	:ARRAY OF UBYTE
ENDOBJECT

/* an_Flags */
NATIVE {DDB_PatternBit}  CONST DDB_PATTERNBIT  = 0
NATIVE {DDB_ExaminedBit} CONST DDB_EXAMINEDBIT = 1
NATIVE {DDB_Completed}   CONST DDB_COMPLETED   = 2
NATIVE {DDB_AllBit}      CONST DDB_ALLBIT      = 3
NATIVE {DDB_Single}      CONST DDB_SINGLE      = 4
NATIVE {DDF_PatternBit}  CONST DDF_PATTERNBIT  = $1
NATIVE {DDF_ExaminedBit} CONST DDF_EXAMINEDBIT = $2
NATIVE {DDF_Completed}   CONST DDF_COMPLETED   = $4
NATIVE {DDF_AllBit}      CONST DDF_ALLBIT      = $8
NATIVE {DDF_Single}      CONST DDF_SINGLE      = $10


/* Structure as used with MatchFirst() and MatchNext(). */
NATIVE {AnchorPath} OBJECT anchorpath
    {ap_Base}	base	:PTR TO achain /* First anchor. */
    {ap_Last}	last	:PTR TO achain /* Last anchor. */

    {ap_BreakBits}	breakbits	:VALUE
    {ap_FoundBreak}	foundbreak	:VALUE
    {ap_Flags}	flags	:BYTE    /* see below */
    {ap_Reserved}	reserved	:BYTE /* PRIVATE */
    {ap_Strlen}	strlen	:INT
    {ap_Info}	info	:fileinfoblock
    {ap_Buf}	buf	:ARRAY OF UBYTE
ENDOBJECT
NATIVE {ap_First}   DEF
NATIVE {ap_Current} DEF
NATIVE {ap_Length}  DEF

/* ap_Flags. Some of the flags are set by the matching-functions and some
   are read-only. */
NATIVE {APB_DOWILD}       CONST APB_DOWILD       = 0 /* Please check for wildcards in supplied string. */
NATIVE {APB_ITSWILD}      CONST APB_ITSWILD      = 1 /* There is actually a wildcard in the supplied
                              string. READ-ONLY */
NATIVE {APB_DODIR}        CONST APB_DODIR        = 2 /* Set, if a directory is to be entered.
                              Applications may clear this bit to prohibit the
                              matching-functions from entering a directory. */
NATIVE {APB_DIDDIR}       CONST APB_DIDDIR       = 3 /* Set, if directory was already searched.
                              READ-ONLY */
NATIVE {APB_NOMEMERR}     CONST APB_NOMEMERR     = 4 /* Set, if function was out of memory. READ-ONLY */
NATIVE {APB_DODOT}        CONST APB_DODOT        = 5 /* '.' may refer to the current directory
                              (unix-style). */
NATIVE {APB_DirChanged}   CONST APB_DIRCHANGED   = 6 /* Directory changed since last call. */
NATIVE {APB_FollowHLinks} CONST APB_FOLLOWHLINKS = 7 /* Follow hardlinks, too. */

NATIVE {APF_DOWILD}       CONST APF_DOWILD       = $1
NATIVE {APF_ITSWILD}      CONST APF_ITSWILD      = $2
NATIVE {APF_DODIR}        CONST APF_DODIR        = $4
NATIVE {APF_DIDDIR}       CONST APF_DIDDIR       = $8
NATIVE {APF_NOMEMERR}     CONST APF_NOMEMERR     = $10
NATIVE {APF_DODOT}        CONST APF_DODOT        = $20
NATIVE {APF_DirChanged}   CONST APF_DIRCHANGED   = $40
NATIVE {APF_FollowHLinks} CONST APF_FOLLOWHLINKS = $80

/* Predefined tokens for wildcards. The characters are replaced by these
   tokens in the tokenized string returned by the ParsePattern() function
   family. */
NATIVE {P_ANY}      CONST P_ANY      = $80 /* Matches everything ("#?" and "*") */
NATIVE {P_SINGLE}   CONST P_SINGLE   = $81 /* Any character ("?") */
NATIVE {P_ORSTART}  CONST P_ORSTART  = $82 /* Opening parenthesis for OR'ing ("(") */
NATIVE {P_ORNEXT}   CONST P_ORNEXT   = $83 /* Field delimiter for OR'ing ("|") */
NATIVE {P_OREND}    CONST P_OREND    = $84 /* Closing parenthesis for OR'ing (")") */
NATIVE {P_NOT}      CONST P_NOT      = $85 /* Inversion ("~") */
NATIVE {P_NOTEND}   CONST P_NOTEND   = $86 /* Inversion end */
NATIVE {P_NOTCLASS} CONST P_NOTCLASS = $87 /* Inversion class ("^") */
NATIVE {P_CLASS}    CONST P_CLASS    = $88 /* Class ("[" and "]") */
NATIVE {P_REPBEG}   CONST P_REPBEG   = $89 /* Beginning of repetition ("[") */
NATIVE {P_REPEND}   CONST P_REPEND   = $8a /* End of repetition ("]") */
NATIVE {P_STOP}     CONST P_STOP     = $8b

NATIVE {COMPLEX_BIT} CONST COMPLEX_BIT = 1
NATIVE {EXAMINE_BIT} CONST EXAMINE_BIT = 2

/* Additional error-numbers. Main chunk of error-numbers is defined in
   <dos/dos.h>. */
NATIVE {ERROR_BUFFER_OVERFLOW} CONST ERROR_BUFFER_OVERFLOW = 303 /* Supplied or internal buffer too small. */
NATIVE {ERROR_BREAK}           CONST ERROR_BREAK           = 304 /* One of the break signals was received. */
NATIVE {ERROR_NOT_EXECUTABLE}  CONST ERROR_NOT_EXECUTABLE  = 305 /* A file is not an executable. */
