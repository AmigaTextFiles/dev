/* $Id: exall.h,v 1.13 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
{#include <dos/exall.h>}
NATIVE {DOS_EXALL_H} CONST

/* NOTE: V37 dos.library, when doing ExAll() emulation, and V37 filesystems
   will return an error if passed ED_OWNER.  If you get ERROR_BAD_NUMBER,
   retry with ED_COMMENT to get everything but owner info.  All filesystems
   supporting ExAll() must support through ED_COMMENT, and must check Type
   and return ERROR_BAD_NUMBER if they don't support the type. */

/* values that can be passed for what data you want from ExAll()
   each higher value includes those below it (numerically)
   you MUST chose one of these values */
NATIVE {ED_NAME}        CONST ED_NAME        = 1
NATIVE {ED_TYPE}        CONST ED_TYPE        = 2
NATIVE {ED_SIZE}        CONST ED_SIZE        = 3
NATIVE {ED_PROTECTION}  CONST ED_PROTECTION  = 4
NATIVE {ED_DATE}        CONST ED_DATE        = 5
NATIVE {ED_COMMENT}     CONST ED_COMMENT     = 6
NATIVE {ED_OWNER}       CONST ED_OWNER       = 7

/*
 *   Structure in which exall results are returned in. Note that only the
 *   fields asked for will exist!
 */

NATIVE {ExAllData} OBJECT exalldata
    {ed_Next}	next	:PTR TO exalldata
    {ed_Name}	name	:ARRAY OF CHAR /*STRPTR*/
    {ed_Type}	type	:VALUE
    {ed_Size}	size	:ULONG
    {ed_Prot}	prot	:ULONG
    {ed_Days}	days	:ULONG
    {ed_Mins}	mins	:ULONG
    {ed_Ticks}	ticks	:ULONG
    {ed_Comment}	comment	:ARRAY OF CHAR /*STRPTR*/  /* strings will be after last used field */
    {ed_OwnerUID}	owneruid	:UINT /* new for V39 */
    {ed_OwnerGID}	ownergid	:UINT
ENDOBJECT

/*
 *   Control structure passed to ExAll.  Unused fields MUST be initialized to
 *   0, expecially eac_LastKey.
 *
 *   eac_MatchFunc is a hook (see utility.library documentation for usage)
 *   It should return true if the entry is to returned, false if it is to be
 *   ignored.
 *
 *   This structure MUST be allocated by AllocDosObject()!
 */

NATIVE {ExAllControl} OBJECT exallcontrol
    {eac_Entries}	entries	:ULONG     /* number of entries returned in buffer */
    {eac_LastKey}	lastkey	:ULONG     /* Don't touch inbetween
                                     linked ExAll calls! */
    {eac_MatchString}	matchstring	:ARRAY OF CHAR /*STRPTR*/ /* wildcard string for pattern match
                                     or NULL */
    {eac_MatchFunc}	matchfunc	:PTR TO hook   /* optional private wildcard function */
ENDOBJECT

/****************************************************************************/
/* Handy macros for checking what kind of object a ExAllData's 
   ed_Type describes;  ExAll() */

NATIVE {EAD_IS_FILE} CONST	->EAD_IS_FILE(ead)    ((ead)->ed_Type <  0)

NATIVE {EAD_IS_DRAWER} CONST	->EAD_IS_DRAWER(ead)  ((ead)->ed_Type >= 0 && (ead)->ed_Type != ST_SOFTLINK)

NATIVE {EAD_IS_LINK} CONST	->EAD_IS_LINK(ead)    ((ead)->ed_Type == ST_SOFTLINK || (ead)->ed_Type == ST_LINKDIR || (ead)->ed_Type == ST_LINKFILE)

NATIVE {EAD_IS_SOFTLINK} CONST	->EAD_IS_SOFTLINK(ead) ((ead)->ed_Type == ST_SOFTLINK)

NATIVE {EAD_IS_LINKDIR} CONST	->EAD_IS_LINKDIR(ead)  ((ead)->ed_Type == ST_LINKDIR)
