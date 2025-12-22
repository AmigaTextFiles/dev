/*
 * $Id: pools.h,v 1.3 2007/02/19 21:40:51 laire Exp $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _POOLS_H
#define _POOLS_H 1

/****************************************************************************/

struct PoolHeader
{
	struct MinNode				ph_MinNode;				/* for tracking pools */
	APTR						ph_PoolHeader;			/* regular memory pool header */
	ULONG						ph_Attributes;			/* memory allocation attributes */
	ULONG						ph_PuddleSize;
	ULONG						ph_ThreshSize;
	struct timeval				ph_Time;					/* when this pool was created */
	ULONG						ph_PC[TRACKEDCALLERSTACKSIZE];					/* return address(s) of the creator */
	struct MinList				ph_Puddles;				/* list of all puddles in this pool */
	struct Task *				ph_Owner;				/* address of the creator */
	LONG						ph_OwnerType;			/* type of the creator (task,process, CLI program) */
	LONG						ph_NameTagLen;			/* length of the name tag header */
	struct SignalSemaphore		ph_SignalSemaphore;	/* to track whether there are different tasks accessing the pool without locking */
	UWORD						ph_Pad;
	struct Task *				ph_PoolOwner;			/* whoever is holding the semaphore at the moment */
	ULONG						ph_PoolOwnerPC[TRACKEDCALLERSTACKSIZE];		/* caller return address of the pool owner */
	BOOL						ph_Consistent;			/* TRUE if puddle list is consistent */
};

/****************************************************************************/

#endif /* _POOLS_H */
