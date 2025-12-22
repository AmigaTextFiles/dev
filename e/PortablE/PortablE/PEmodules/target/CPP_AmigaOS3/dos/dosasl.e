/* $VER: dosasl.h 36.16 (2.5.1991) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/dos/dos_shared'
MODULE 'target/exec/types', 'target/dos/dos'
{#include <dos/dosasl.h>}
NATIVE {DOS_DOSASL_H} CONST

/***********************************************************************
************************ PATTERN MATCHING ******************************
************************************************************************

* structure expected by MatchFirst, MatchNext.
* Allocate this structure and initialize it as follows:
*
* Set ap_BreakBits to the signal bits (CDEF) that you want to take a
* break on, or NULL, if you don't want to convenience the user.
*
* If you want to have the FULL PATH NAME of the files you found,
* allocate a buffer at the END of this structure, and put the size of
* it into ap_Strlen.  If you don't want the full path name, make sure
* you set ap_Strlen to zero.  In this case, the name of the file, and stats
* are available in the ap_Info, as per usual.
*
* Then call MatchFirst() and then afterwards, MatchNext() with this structure.
* You should check the return value each time (see below) and take the
* appropriate action, ultimately calling MatchEnd() when there are
* no more files and you are done.  You can tell when you are done by
* checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.
*
*/

NATIVE {ap_First} DEF
NATIVE {ap_Current} DEF
NATIVE {ap_Length} DEF

NATIVE {AnchorPath} OBJECT anchorpath
	{ap_Base}		base		:PTR TO achain	/* pointer to first anchor */
	{ap_Last}		last		:PTR TO achain	/* pointer to last anchor */
	{ap_BreakBits}	breakbits	:VALUE	/* Bits we want to break on */
	{ap_FoundBreak}	foundbreak	:VALUE	/* Bits we broke on. Also returns ERROR_BREAK */
	{ap_Flags}		flags		:BYTE	/* New use for extra word. */
	{ap_Reserved}	reserved	:BYTE
	{ap_Strlen}		strlen		:INT	/* This is what ap_Length used to be */
	{ap_Info}		info		:fileinfoblock
	{ap_Buf}		buf			:ARRAY OF UBYTE	/* Buffer for path name, allocated by user */
	/* FIX! */
ENDOBJECT


NATIVE {APB_DOWILD}	CONST APB_DOWILD	= 0	/* User option ALL */
NATIVE {APF_DOWILD}	CONST APF_DOWILD	= 1

NATIVE {APB_ITSWILD}	CONST APB_ITSWILD	= 1	/* Set by MatchFirst, used by MatchNext	 */
NATIVE {APF_ITSWILD}	CONST APF_ITSWILD	= 2	/* Application can test APB_ITSWILD, too */
				/* (means that there's a wildcard	 */
				/* in the pattern after calling		 */
				/* MatchFirst).				 */

NATIVE {APB_DODIR}	CONST APB_DODIR	= 2	/* Bit is SET if a DIR node should be */
NATIVE {APF_DODIR}	CONST APF_DODIR	= 4	/* entered. Application can RESET this */
				/* bit after MatchFirst/MatchNext to AVOID */
				/* entering a dir. */

NATIVE {APB_DIDDIR}	CONST APB_DIDDIR	= 3	/* Bit is SET for an "expired" dir node. */
NATIVE {APF_DIDDIR}	CONST APF_DIDDIR	= 8

NATIVE {APB_NOMEMERR}	CONST APB_NOMEMERR	= 4	/* Set on memory error */
NATIVE {APF_NOMEMERR}	CONST APF_NOMEMERR	= 16

NATIVE {APB_DODOT}	CONST APB_DODOT	= 5	/* If set, allow conversion of '.' to */
NATIVE {APF_DODOT}	CONST APF_DODOT	= 32	/* CurrentDir */

NATIVE {APB_DirChanged}	CONST APB_DIRCHANGED	= 6	/* ap_Current->an_Lock changed */
NATIVE {APF_DirChanged}	CONST APF_DIRCHANGED	= 64	/* since last MatchNext call */

NATIVE {APB_FollowHLinks} CONST APB_FOLLOWHLINKS = 7	/* follow hardlinks on DODIR - defaults   */
NATIVE {APF_FollowHLinks} CONST APF_FOLLOWHLINKS = 128	/* to not following hardlinks on a DODIR. */


NATIVE {AChain} OBJECT achain
	{an_Child}	child	:PTR TO achain
	{an_Parent}	parent	:PTR TO achain
	{an_Lock}	lock	:BPTR
	{an_Info}	info	:fileinfoblock
	{an_Flags}	flags	:BYTE
	{an_String}	string	:ARRAY OF UBYTE	/* FIX!! */
ENDOBJECT

NATIVE {DDB_PatternBit}	CONST DDB_PATTERNBIT	= 0
NATIVE {DDF_PatternBit}	CONST DDF_PATTERNBIT	= 1
NATIVE {DDB_ExaminedBit}	CONST DDB_EXAMINEDBIT	= 1
NATIVE {DDF_ExaminedBit}	CONST DDF_EXAMINEDBIT	= 2
NATIVE {DDB_Completed}	CONST DDB_COMPLETED	= 2
NATIVE {DDF_Completed}	CONST DDF_COMPLETED	= 4
NATIVE {DDB_AllBit}	CONST DDB_ALLBIT	= 3
NATIVE {DDF_AllBit}	CONST DDF_ALLBIT	= 8
NATIVE {DDB_Single}	CONST DDB_SINGLE	= 4
NATIVE {DDF_Single}	CONST DDF_SINGLE	= 16

/*
 * Constants used by wildcard routines, these are the pre-parsed tokens
 * referred to by pattern match.  It is not necessary for you to do
 * anything about these, MatchFirst() MatchNext() handle all these for you.
 */

NATIVE {P_ANY}		CONST P_ANY		= $80	/* Token for '*' or '#?  */
NATIVE {P_SINGLE}	CONST P_SINGLE	= $81	/* Token for '?' */
NATIVE {P_ORSTART}	CONST P_ORSTART	= $82	/* Token for '(' */
NATIVE {P_ORNEXT}	CONST P_ORNEXT	= $83	/* Token for '|' */
NATIVE {P_OREND}	CONST P_OREND	= $84	/* Token for ')' */
NATIVE {P_NOT}		CONST P_NOT		= $85	/* Token for '~' */
NATIVE {P_NOTEND}	CONST P_NOTEND	= $86	/* Token for */
NATIVE {P_NOTCLASS}	CONST P_NOTCLASS	= $87	/* Token for '^' */
NATIVE {P_CLASS}	CONST P_CLASS	= $88	/* Token for '[]' */
NATIVE {P_REPBEG}	CONST P_REPBEG	= $89	/* Token for '[' */
NATIVE {P_REPEND}	CONST P_REPEND	= $8A	/* Token for ']' */
NATIVE {P_STOP}		CONST P_STOP		= $8B	/* token to force end of evaluation */

/* Values for an_Status, NOTE: These are the actual bit numbers */

NATIVE {COMPLEX_BIT}	CONST COMPLEX_BIT	= 1	/* Parsing complex pattern */
NATIVE {EXAMINE_BIT}	CONST EXAMINE_BIT	= 2	/* Searching directory */

/*
 * Returns from MatchFirst(), MatchNext()
 * You can also get dos error returns, such as ERROR_NO_MORE_ENTRIES,
 * these are in the dos.h file.
 */

NATIVE {ERROR_BUFFER_OVERFLOW}	CONST ERROR_BUFFER_OVERFLOW	= 303	/* User or internal buffer overflow */
NATIVE {ERROR_BREAK}			CONST ERROR_BREAK			= 304	/* A break character was received */
NATIVE {ERROR_NOT_EXECUTABLE}	CONST ERROR_NOT_EXECUTABLE	= 305	/* A file has E bit cleared */
