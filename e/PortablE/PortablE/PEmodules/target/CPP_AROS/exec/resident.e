/* $Id: resident.h 23527 2005-08-15 10:49:04Z stegerg $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <exec/resident.h>}
NATIVE {EXEC_RESIDENT_H} CONST

NATIVE {Resident} OBJECT rt
    {rt_MatchWord}	matchword	:UINT /* equal to RTC_MATCHWORD (see below) */
    {rt_MatchTag}	matchtag	:NATIVE {const struct Resident*} PTR TO rt  /* Pointer to this struct */
    {rt_EndSkip}	endskip	:APTR
    {rt_Flags}	flags	:UBYTE     /* see below */
    {rt_Version}	version	:UBYTE
    {rt_Type}	type	:UBYTE
    {rt_Pri}	pri	:BYTE
    {rt_Name}	name	:CONST_STRPTR
    {rt_IdString}	idstring	:CONST_STRPTR
    {rt_Init}	init	:APTR

    /* Extension taken over from MorphOS. Only valid
       if RTF_EXTENDED is set */
       
    {rt_Revision}	revision	:UINT
    {rt_Tags}	tags	:ARRAY OF tagitem
ENDOBJECT

NATIVE {RTC_MATCHWORD}  CONST RTC_MATCHWORD  = ($4AFC)

NATIVE {RTF_COLDSTART}  CONST RTF_COLDSTART  = $1
NATIVE {RTF_SINGLETASK} CONST RTF_SINGLETASK = $2
NATIVE {RTF_AFTERDOS}   CONST RTF_AFTERDOS   = $4
NATIVE {RTF_AUTOINIT}   CONST RTF_AUTOINIT   = $80

NATIVE {RTF_EXTENDED}   CONST RTF_EXTENDED   = $40 /* MorphOS extension: extended
                                 structure fields are valid */

NATIVE {RTW_NEVER}      CONST RTW_NEVER      = (0)
NATIVE {RTW_COLDSTART}  CONST RTW_COLDSTART  = (1)
