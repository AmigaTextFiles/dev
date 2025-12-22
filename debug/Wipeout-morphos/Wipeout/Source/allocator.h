/*
 * $Id: allocator.h,v 1.4 2006/01/31 19:04:26 laire Exp $
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
	ALLOCATIONTYPE_AllocPooled,
	ALLOCATIONTYPE_AllocVecPooled
};

/****************************************************************************/

struct TrackHeader
{
	struct MinNode			th_MinNode;								/* 0x00 for linking to a pool list */
	struct PoolHeader *		th_PoolHeader;							/* 0x08 the memory pool the allocation belongs to */
	ULONG					th_Magic;								/* 0x0c 0xBA5EBA11 */
	struct TrackHeader *	th_PointBack;							/* 0x10 points to beginning of header */
	struct Task *			th_Owner;								/* 0x14 address of allocating task */
	WORD					th_OwnerType;							/* 0x18 type of allocating task (task/process/CLI program) */
	UBYTE					th_ShowPC;								/* 0x1a When dumping this entry, make sure that the PC is shown, too. */
	UBYTE					th_Marked;								/* 0x1b TRUE if this allocation was marked for later lookup */
	LONG					th_NameTagLen;							/* 0x1c if non-zero, name tag precedes header */
	ULONG					th_PC[TRACKEDCALLERSTACKSIZE];			/* 0x20 allocator return address(s) */
	struct timeval			th_Time;								/* 0x60 when the allocation was made */
	ULONG					th_Sequence;							/* 0x68 unique number */
	ULONG					th_Size;								/* 0x6c number of bytes in allocation */
	ULONG					th_Checksum;							/* 0x70 protects the entire header */
	UBYTE					th_Type;								/* 0x74 type of the allocation (AllocMem/AllocVec/AllocPooled) */
	UBYTE					th_FillChar;							/* 0x75 wall fill char */
	UWORD					th_PostSize;							/* 0x76 size of post-allocation wall */
	ULONG					th_PreSize;								/* 0x78 */
	ULONG					th_SyncSize;							/* 0x7c size of sync before the pre-allocation wall */
};																	/* 0x80 Length */

/****************************************************************************/

#endif /* _ALLOCATOR_H */
