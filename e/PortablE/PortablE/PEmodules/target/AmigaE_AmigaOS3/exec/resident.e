/* $VER: resident.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/types'
{MODULE 'exec/resident'}

NATIVE {rt} OBJECT rt
    {matchword}	matchword	:UINT	/* word to match on (ILLEGAL)	*/
    {matchtag}	matchtag	:PTR TO rt /* pointer to the above	*/
    {endskip}	endskip	:APTR		/* address to continue scan	*/
    {flags}	flags	:UBYTE		/* various tag flags		*/
    {version}	version	:UBYTE		/* release version number	*/
    {type}	type	:UBYTE		/* type of module (NT_XXXXXX)	*/
    {pri}	pri	:BYTE		/* initialization priority */
    {name}	name	:ARRAY OF CHAR		/* pointer to node name	*/
    {idstring}	idstring	:ARRAY OF CHAR	/* pointer to identification string */
    {init}	init	:APTR		/* pointer to init code	*/
ENDOBJECT

NATIVE {RTC_MATCHWORD}	CONST RTC_MATCHWORD	= $4AFC	/* The 68000 "ILLEGAL" instruction */

NATIVE {RTF_AUTOINIT}	CONST RTF_AUTOINIT	= $80	/* rt_Init points to data structure */
NATIVE {RTF_AFTERDOS}	CONST RTF_AFTERDOS	= $4
NATIVE {RTF_SINGLETASK}	CONST RTF_SINGLETASK	= $2
NATIVE {RTF_COLDSTART}	CONST RTF_COLDSTART	= $1

/* Compatibility: (obsolete) */
/* NATIVE {RTM_WHEN} CONST RTM_WHEN = 3 */
NATIVE {RTW_NEVER}	CONST RTW_NEVER	= 0
NATIVE {RTW_COLDSTART}	CONST RTW_COLDSTART	= 1
