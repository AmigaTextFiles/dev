/* $Id: resident.h,v 1.13 2005/11/10 15:33:07 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <exec/resident.h>}
NATIVE {EXEC_RESIDENT_H} CONST

NATIVE {Resident} OBJECT rt
    {rt_MatchWord}	matchword	:UINT /* word to match on (ILLEGAL) */
    {rt_MatchTag}	matchtag	:PTR TO rt  /* pointer to the above */
    {rt_EndSkip}	endskip	:APTR   /* address to continue scan */
    {rt_Flags}	flags	:UBYTE     /* various tag flags */
    {rt_Version}	version	:UBYTE   /* release version number */
    {rt_Type}	type	:UBYTE      /* type of module (NT_XXXXXX) */
    {rt_Pri}	pri	:BYTE       /* initialization priority */
    {rt_Name}	name	:CONST_STRPTR      /* pointer to node name */
    {rt_IdString}	idstring	:CONST_STRPTR  /* pointer to identification string */
    {rt_Init}	init	:APTR      /* pointer to init code */
ENDOBJECT

NATIVE {RTC_MATCHWORD} CONST RTC_MATCHWORD = $4AFC /* The 68000 "ILLEGAL" instruction */

NATIVE {enResidentFlags} DEF
NATIVE {RTF_AUTOINIT}   CONST RTF_AUTOINIT   = $80 /* rt_Init points to data structure */
NATIVE {RTF_NATIVE}     CONST RTF_NATIVE     = $20 /* rt_Init points to a native function
                              * (otherwise, 68k is assumed) */
NATIVE {RTF_AFTERDOS}   CONST RTF_AFTERDOS   = $4
NATIVE {RTF_SINGLETASK} CONST RTF_SINGLETASK = $2
NATIVE {RTF_COLDSTART}  CONST RTF_COLDSTART  = $1


/* Compatibility: (obsolete) */
/* THF: Note: Removed all of them. They shouldn't be in active use anymore */
/* #define RTM_WHEN      3 */
/* #define RTW_NEVER     0 */
/* #define RTW_COLDSTART 1 */
