/* $VER: dosasl.h 36.16 (2.5.1991) */
OPT NATIVE
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/dos/dos_shared'
MODULE 'target/exec/types', 'target/dos/dos'
{MODULE 'dos/dosasl'}

NATIVE {anchorpath} OBJECT anchorpath
	{base}		base		:PTR TO achain	/* pointer to first anchor */
	{last}		last		:PTR TO achain	/* pointer to last anchor */
	{breakbits}	breakbits	:VALUE	/* Bits we want to break on */
	{foundbreak}	foundbreak	:VALUE	/* Bits we broke on. Also returns ERROR_BREAK */
	{flags}		flags		:BYTE	/* New use for extra word. */
	{reserved}	reserved	:BYTE
	{strlen}		strlen		:INT	/* This is what ap_Length used to be */
	{info}		info		:fileinfoblock
->	{buf}		buf			:ARRAY OF UBYTE	/* Buffer for path name, allocated by user */
	/* FIX! */
ENDOBJECT


NATIVE {APB_DOWILD}	CONST APB_DOWILD	= 0	/* User option ALL */
NATIVE {APF_DOWILD}	CONST APF_DOWILD	= 1

NATIVE {APB_ITSWILD}	CONST APB_ITSWILD	= 1	/* Set by MatchFirst, used by MatchNext	 */
NATIVE {APF_ITSWILD}	CONST APF_ITSWILD	= 2	/* Application can test APB_ITSWILD, too */

NATIVE {APB_DODIR}	CONST APB_DODIR	= 2	/* Bit is SET if a DIR node should be */
NATIVE {APF_DODIR}	CONST APF_DODIR	= 4	/* entered. Application can RESET this */

NATIVE {APB_DIDDIR}	CONST APB_DIDDIR	= 3	/* Bit is SET for an "expired" dir node. */
NATIVE {APF_DIDDIR}	CONST APF_DIDDIR	= 8

NATIVE {APB_NOMEMERR}	CONST APB_NOMEMERR	= 4	/* Set on memory error */
NATIVE {APF_NOMEMERR}	CONST APF_NOMEMERR	= 16

NATIVE {APB_DODOT}	CONST APB_DODOT	= 5	/* If set, allow conversion of '.' to */
NATIVE {APF_DODOT}	CONST APF_DODOT	= 32	/* CurrentDir */

NATIVE {APB_DIRCHANGED}	CONST APB_DIRCHANGED	= 6	/* ap_Current->an_Lock changed */
NATIVE {APF_DIRCHANGED}	CONST APF_DIRCHANGED	= 64	/* since last MatchNext call */

NATIVE {APB_FOLLOWHLINKS} CONST APB_FOLLOWHLINKS = 7	/* follow hardlinks on DODIR - defaults   */
NATIVE {APF_FOLLOWHLINKS} CONST APF_FOLLOWHLINKS = 128	/* to not following hardlinks on a DODIR. */


NATIVE {achain} OBJECT achain
	{child}	child	:PTR TO achain
	{parent}	parent	:PTR TO achain
	{lock}	lock	:BPTR
	{info}	info	:fileinfoblock
	{flags}	flags	:BYTE
->	{string}	string	:ARRAY OF UBYTE	/* FIX!! */
ENDOBJECT

NATIVE {DDB_PATTERNBIT}	CONST DDB_PATTERNBIT	= 0
NATIVE {DDF_PATTERNBIT}	CONST DDF_PATTERNBIT	= 1
NATIVE {DDB_EXAMINEDBIT}	CONST DDB_EXAMINEDBIT	= 1
NATIVE {DDF_EXAMINEDBIT}	CONST DDF_EXAMINEDBIT	= 2
NATIVE {DDB_COMPLETED}	CONST DDB_COMPLETED	= 2
NATIVE {DDF_COMPLETED}	CONST DDF_COMPLETED	= 4
NATIVE {DDB_ALLBIT}	CONST DDB_ALLBIT	= 3
NATIVE {DDF_ALLBIT}	CONST DDF_ALLBIT	= 8
NATIVE {DDB_SINGLE}	CONST DDB_SINGLE	= 4
NATIVE {DDF_SINGLE}	CONST DDF_SINGLE	= 16

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

NATIVE {ERROR_BUFFER_OVERFLOW}	CONST ERROR_BUFFER_OVERFLOW	= 303	/* User or internal buffer overflow */
NATIVE {ERROR_BREAK}			CONST ERROR_BREAK			= 304	/* A break character was received */
NATIVE {ERROR_NOT_EXECUTABLE}	CONST ERROR_NOT_EXECUTABLE	= 305	/* A file has E bit cleared */
