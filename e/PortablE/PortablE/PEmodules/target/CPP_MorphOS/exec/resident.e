/* $VER: resident.h 39.0 (15.10.1991) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <exec/resident.h>}
NATIVE {EXEC_RESIDENT_H} CONST

NATIVE {Resident} OBJECT rt
    {rt_MatchWord}	matchword	:UINT	/* word to match on (ILLEGAL)	*/
    {rt_MatchTag}	matchtag	:PTR TO rt /* pointer to the above	*/
    {rt_EndSkip}	endskip	:APTR		/* address to continue scan	*/
    {rt_Flags}	flags	:UBYTE		/* various tag flags		*/
    {rt_Version}	version	:UBYTE		/* release version number	*/
    {rt_Type}	type	:UBYTE		/* type of module (NT_XXXXXX)	*/
    {rt_Pri}	pri	:BYTE		/* initialization priority */
    {rt_Name}	name	:ARRAY OF CHAR		/* pointer to node name	*/
    {rt_IdString}	idstring	:ARRAY OF CHAR	/* pointer to identification string */
    {rt_Init}	init	:APTR		/* pointer to init code	*/
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
