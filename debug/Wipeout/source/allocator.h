/*
 * $Id: allocator.h 1.8 1998/04/16 09:31:31 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _ALLOCATOR_H
#define _ALLOCATOR_H 1

/****************************************************************************/

/* memory allocation types */
enum
{
	ALLOCATIONTYPE_AllocMem,
	ALLOCATIONTYPE_AllocVec,
	ALLOCATIONTYPE_AllocPooled
};

/****************************************************************************/

struct TrackHeader
{
	struct MinNode			th_MinNode;		/* for linking to a pool list */
	struct PoolHeader *		th_PoolHeader;	/* the memory pool the allocation belongs to */

	ULONG					th_Magic;		/* 0xBA5EBA11 */
	struct TrackHeader *	th_PointBack;	/* points to beginning of header */
	struct Task *			th_Owner;		/* address of allocating task */
	WORD					th_OwnerType;	/* type of allocating task (task/process/CLI program) */
	BOOL					th_ShowPC;		/* When dumping this entry, make sure that the PC is shown, too. */
	LONG					th_NameTagLen;	/* if non-zero, name tag precedes header */
	ULONG					th_PC;			/* allocator return address */
	struct timeval			th_Time;		/* when the allocation was made */
	ULONG					th_Sequence;	/* unique number */
	ULONG					th_Size;		/* number of bytes in allocation */
	ULONG					th_Checksum;	/* protects the entire header */
	UBYTE					th_Type;		/* type of the allocation (AllocMem/AllocVec/AllocPooled) */
	UBYTE					th_FillChar;	/* wall fill char */
	UWORD					th_PostSize;	/* size of post-allocation wall */
	LONG					th_Marked;		/* TRUE if this allocation was marked for later lookup */
};

/****************************************************************************/

#endif /* _ALLOCATOR_H */
