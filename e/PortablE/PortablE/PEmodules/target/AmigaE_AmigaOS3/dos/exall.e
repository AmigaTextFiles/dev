/* $VER: exall.h 36.6 (5.4.1992) */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
{MODULE 'dos/exall'}

NATIVE {ED_NAME}		CONST ED_NAME		= 1
NATIVE {ED_TYPE}		CONST ED_TYPE		= 2
NATIVE {ED_SIZE}		CONST ED_SIZE		= 3
NATIVE {ED_PROTECTION}	CONST ED_PROTECTION	= 4
NATIVE {ED_DATE}		CONST ED_DATE		= 5
NATIVE {ED_COMMENT}	CONST ED_COMMENT	= 6
NATIVE {ED_OWNER}	CONST ED_OWNER	= 7

NATIVE {exalldata} OBJECT exalldata
	{next}	next	:PTR TO exalldata
	{name}	name	:ARRAY OF UBYTE
	{type}	type	:VALUE
	{size}	size	:ULONG
	{prot}	prot	:ULONG
	{days}	days	:ULONG
	{mins}	mins	:ULONG
	{ticks}	ticks	:ULONG
	{comment}	comment	:ARRAY OF UBYTE	/* strings will be after last used field */
	{owneruid}	owneruid	:UINT	/* new for V39 */
	{ownergid}	ownergid	:UINT
ENDOBJECT

NATIVE {exallcontrol} OBJECT exallcontrol
	{entries}	entries	:ULONG	 /* number of entries returned in buffer      */
	{lastkey}	lastkey	:ULONG	 /* Don't touch inbetween linked ExAll calls! */
	{matchstring}	matchstring	:ARRAY OF UBYTE /* wildcard string for pattern match or NULL */
	{matchfunc}	matchfunc	:PTR TO hook /* optional private wildcard function     */
ENDOBJECT
