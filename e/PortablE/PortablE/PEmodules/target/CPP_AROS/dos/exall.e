/* $Id: exall.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
{#include <dos/exall.h>}
NATIVE {DOS_EXALL_H} CONST

NATIVE {ExAllData} OBJECT exalldata
    {ed_Next}	next	:PTR TO exalldata

    {ed_Name}	name	:ARRAY OF UBYTE     /* Name of the file. */
    {ed_Type}	type	:VALUE     /* Type of file. See <dos/dosextens.h>. */
    {ed_Size}	size	:ULONG     /* Size of file. */
    {ed_Prot}	prot	:ULONG     /* Protection bits. */

    /* The following three fields are de facto an embedded datestamp
       structure (see <dos/dos.h>), which describes the last modification
       date. */
    {ed_Days}	days	:ULONG
    {ed_Mins}	mins	:ULONG
    {ed_Ticks}	ticks	:ULONG

    {ed_Comment}	comment	:ARRAY OF UBYTE  /* The file comment. */

    {ed_OwnerUID}	owneruid	:UINT /* The owner ID. */
    {ed_OwnerGID}	ownergid	:UINT /* The group-owner ID. */
ENDOBJECT

NATIVE {ED_NAME}       CONST ED_NAME       = 1 /* Filename. */
NATIVE {ED_TYPE}       CONST ED_TYPE       = 2 /* Type of file. See <dos/dosextens.h>. */
NATIVE {ED_SIZE}       CONST ED_SIZE       = 3 /* Size of file. */
NATIVE {ED_PROTECTION} CONST ED_PROTECTION = 4 /* Protection bits. */
NATIVE {ED_DATE}       CONST ED_DATE       = 5 /* Last modification date. */
NATIVE {ED_COMMENT}    CONST ED_COMMENT    = 6 /* Addtional file comment. */
NATIVE {ED_OWNER}      CONST ED_OWNER      = 7 /* Owner information. */


NATIVE {ExAllControl} OBJECT exallcontrol
      /* The number of entries that were returned in the buffer. */
    {eac_Entries}	entries	:ULONG
    {eac_LastKey}	lastkey	:ULONG     /* PRIVATE */
      /* Parsed pattern string, as created by ParsePattern(). This may be NULL.
      */
    {eac_MatchString}	matchstring	:ARRAY OF UBYTE
      /* You may supply a hook, which is called for each entry. This hook
         should return TRUE, if the current entry is to be included in
         the file list and FALSE, if it should be ignored. */
    {eac_MatchFunc}	matchfunc	:PTR TO hook
ENDOBJECT
