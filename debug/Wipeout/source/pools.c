/*
 * $Id: pools.c 1.20 1998/06/04 17:58:10 olsen Exp olsen $
 *
 * :ts=4
 *
 * Wipeout -- Traces and munges memory and detects memory trashing
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

#include "installpatches.h"

/******************************************************************************/

STATIC struct MinList PoolList;

STATIC struct SignalSemaphore DummySemaphore;

/******************************************************************************/

VOID
SetupPoolList(VOID)
{
	/* set up the memory pool registry */
	NewList((struct List *)&PoolList);

	/* initialize the dummy semaphore */
	InitSemaphore(&DummySemaphore);
}

/******************************************************************************/

VOID
HoldPoolSemaphore(struct PoolHeader * ph,ULONG pc)
{
	/* hold the pool semaphore for an instant, breaking
	 * the Forbid() state
	 */
	ObtainSemaphore(&DummySemaphore);
	ReleaseSemaphore(&DummySemaphore);

	/* try to gain control over the pool; if this fails,
	 * somebody else must be mucking with pool at the
	 * moment, which is not such a good idea
	 */
	if(CANNOT AttemptSemaphore(&ph->ph_SignalSemaphore))
	{
		ULONG segment;
		ULONG offset;

		VoiceComplaint(NULL,NULL,"Two tasks are accessing the same pool at the same time\n");

		DPrintf("   Already being used by task 0x%08lx",ph->ph_PoolOwner);

		if(GetTaskName(ph->ph_PoolOwner,GlobalNameBuffer,sizeof(GlobalNameBuffer)))
		{
			DPrintf(", %s \"%s\"",GetTaskTypeName(GetTaskType(ph->ph_PoolOwner)),GlobalNameBuffer);
		}

		DPrintf("\n");

		if(FindAddress(ph->ph_PoolOwnerPC,sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
		{
			DPrintf("                         from \"%s\" Hunk %04lx Offset %08lx\n",GlobalNameBuffer,segment,offset);
		}

		DPrintf("Attempting to be used by task 0x%08lx",FindTask(NULL));

		if(GetTaskName(NULL,GlobalNameBuffer,sizeof(GlobalNameBuffer)))
		{
			DPrintf(", %s \"%s\"",GetTaskTypeName(GetTaskType(NULL)),GlobalNameBuffer);
		}

		DPrintf("\n");

		if(FindAddress(NULL,sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
		{
			DPrintf("                      from \"%s\" Hunk %04lx Offset %08lx\n",GlobalNameBuffer,segment,offset);
		}

		/* wait for the other guy to release the pool */
		ObtainSemaphore(&ph->ph_SignalSemaphore);
	}

	/* register the new owner */
	ph->ph_PoolOwner	= FindTask(NULL);
	ph->ph_PoolOwnerPC	= pc;
}

VOID
ReleasePoolSemaphore(struct PoolHeader * ph)
{
	ReleaseSemaphore(&ph->ph_SignalSemaphore);
}

/******************************************************************************/

BOOL
PuddleIsInPool(struct PoolHeader * ph,APTR mem)
{
	BOOL found = FALSE;

	if(IsPuddleListConsistent(ph))
	{
		struct TrackHeader * th;

		/* check whether the given allocation went into the
		 * given pool
		 */
		for(th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			UBYTE * thatMem;
	
			thatMem = (UBYTE *)(th + 1);
			thatMem += PreWallSize;
	
			if(thatMem == mem)
			{
				found = TRUE;
				break;
			}
		}
	}

	return(found);
}

/******************************************************************************/

VOID
RemovePuddle(struct TrackHeader * th)
{
	/* unregister a puddle from a pool */
	Remove((struct Node *)th);
	th->th_Magic = 0;
}

VOID
AddPuddle(struct PoolHeader * ph,struct TrackHeader * th)
{
	/* register a puddle in a pool */
	AddTail((struct List *)&ph->ph_Puddles,(struct Node *)th);
}

/******************************************************************************/

struct PoolHeader *
FindPoolHeader(APTR poolHeader)
{
	struct PoolHeader * result = NULL;
	struct PoolHeader * node;

	/* determine the pool header being tracked, if there
	 * is one
	 */
	for(node = (struct PoolHeader *)PoolList.mlh_Head ;
	    node->ph_MinNode.mln_Succ != NULL ;
	    node = (struct PoolHeader *)node->ph_MinNode.mln_Succ)
	{
		if(node->ph_PoolHeader == poolHeader)
		{
			result = node;
			break;
		}
	}

	return(result);
}

/******************************************************************************/

BOOL
DeletePoolHeader(ULONG * stackFrame,struct PoolHeader * ph)
{
	struct TrackHeader * th;
	BOOL deleteIt = TRUE;

	/* In any event, remove the pool from the public list.
	 * It is going to be deleted or let go in a minute.
	 */
	Remove((struct Node *)ph);

	/* gain exclusive access to the pool */
	HoldPoolSemaphore(ph,stackFrame[16]);
	ReleasePoolSemaphore(ph);

	if(IsPuddleListConsistent(ph))
	{
		for(th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			/* Check whether this pool has dead allocations.
			 * If so, do not deallocate it.
			 */
			if(th->th_Magic == 0)
			{
				deleteIt = FALSE;
			}
			else
			{
				/* Check whether this puddle has been
				 * stomped upon. If so, do not free the
				 * pool.
				 */
				if(CheckStomping(stackFrame,th))
				{
					deleteIt = FALSE;
				}

				/* Will be dead food in a minute. */
				th->th_Magic = 0;
			}
		}

		/* if we can proceed to deallocate the
		 * pool, trash all its allocations
		 */
		if(deleteIt)
		{
			struct TrackHeader * node;
			struct TrackHeader * next;
			LONG allocationSize;

			for(node = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
			   (next = (struct TrackHeader *)node->th_MinNode.mln_Succ) != NULL ;
			    node = next)
			{
				allocationSize = node->th_NameTagLen + sizeof(*node) + PreWallSize + node->th_Size + node->th_PostSize;
				if(node->th_NameTagLen > 0)
				{
					node = (struct TrackHeader *)(((ULONG)node) - node->th_NameTagLen);
				}

				MungMem((ULONG *)node,allocationSize,DEADBEEF);
			}
		}
	}

	if(NOT ph->ph_Consistent)
	{
		deleteIt = FALSE;
	}

	if(deleteIt)
	{
		APTR poolHeader;
		ULONG * mem;
		LONG allocationSize;

		mem = (ULONG *)(((ULONG)ph) - ph->ph_NameTagLen);
		allocationSize = ph->ph_NameTagLen + sizeof(*ph);

		poolHeader = ph->ph_PoolHeader;

		MungMem(mem,allocationSize,DEADBEEF);

		(*OldDeletePool)(poolHeader,SysBase);
	}
	else
	{
		DumpPoolOwner(ph);
	}

	return(deleteIt);
}

struct PoolHeader *
CreatePoolHeader(ULONG attributes,ULONG puddleSize,ULONG threshSize,ULONG pc)
{
	struct PoolHeader * result = NULL;
	APTR header;

	/* create the pool with the MEMF_CLEAR bit cleared; if there is
	 * any clearing to be done, we want to do it on our own
	 */
	header = (*OldCreatePool)(attributes & (~MEMF_CLEAR),puddleSize,threshSize,SysBase);
	if(header != NULL)
	{
		struct PoolHeader * ph;
		LONG nameTagLen;

		nameTagLen = 0;

		/* get the name of the current task, if this is necessary */
		if(NameTag)
		{
			nameTagLen = GetNameTagLen(pc);
		}
	
		ph = (*OldAllocPooled)(header,nameTagLen + sizeof(*ph),SysBase);
		if(ph != NULL)
		{
			/* the allocation above may have broken a Forbid(), so we
			 * retry reading the creator information
			 */
			if(NameTag)
			{
				LONG newNameTagLen;

				newNameTagLen = GetNameTagLen(pc);

				/* the data should not be different, but if it is
				 * (unlikely), don't bother to tag this header
				 */
				if(newNameTagLen != nameTagLen)
				{
					nameTagLen = 0;
				}
			}

			/* the name tag header precedes the pool header */
			if(nameTagLen > 0)
			{
				FillNameTag(ph,nameTagLen);

				/* skip the name tag header */
				ph = (struct PoolHeader *)(((ULONG)ph) + nameTagLen);
			}

			/* fill in the usual header data */
			ph->ph_PoolHeader	= header;
			ph->ph_PC			= pc;
			ph->ph_Owner		= FindTask(NULL);
			ph->ph_OwnerType	= GetTaskType(NULL);
			ph->ph_NameTagLen	= nameTagLen;
			ph->ph_Consistent	= TRUE;

			GetSysTime(&ph->ph_Time);
	
			ph->ph_Attributes = attributes;
			NewList((struct List *)&ph->ph_Puddles);
	
			memset(&ph->ph_SignalSemaphore,0,sizeof(ph->ph_SignalSemaphore));
			InitSemaphore(&ph->ph_SignalSemaphore);
			ph->ph_PoolOwner = NULL;

			AddTail((struct List *)&PoolList,(struct Node *)ph);

			result = ph;
		}
		else
		{
			(*OldDeletePool)(header,SysBase);
		}
	}

	return(result);
}

/******************************************************************************/

VOID
CheckPools(VOID)
{
	struct PoolHeader * ph;
	struct TrackHeader * th;
	ULONG totalBytes;
	ULONG totalAllocations;
	ULONG totalPools;
	BOOL poolOwnerDumped;

	totalBytes = 0;
	totalAllocations = 0;
	totalPools = 0;

	Forbid();

	/* check all registered pools */
	for(ph = (struct PoolHeader *)PoolList.mlh_Head ;
	    ph->ph_MinNode.mln_Succ != NULL ;
	    ph = (struct PoolHeader *)ph->ph_MinNode.mln_Succ)
	{
		poolOwnerDumped = FALSE;

		if(IsPuddleListConsistent(ph))
		{
			/* check all allocations in this pool */
			for(th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
			    th->th_MinNode.mln_Succ != NULL ;
			    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
			{
				/* Check whether the header data is consistent. */
				if(IsValidTrackHeader(th) && IsTrackHeaderChecksumCorrect(th))
				{
					/* Don't count dead allocations. */
					if(th->th_Magic != 0)
					{
						/* check if the allocation was trashed */
						if(CheckStomping(NULL,th))
						{
							/* if the allocation was trashed,
							 * show the pool it belongs to
							 */
							if(NOT poolOwnerDumped)
							{
								DumpPoolOwner(ph);
		
								poolOwnerDumped = TRUE;
							}
						}
		
						totalBytes += th->th_Size;
						totalAllocations++;
					}
				}
			}
		}

		/* check whether the creator of this pool
		 * is still with us
		 */
		if(NOT IsTaskStillAround(ph->ph_Owner))
		{
			VoiceComplaint(NULL,NULL,"Orphaned pool?\n");
			DumpPoolOwner(ph);
		}

		totalPools++;
	}

	Permit();

	DPrintf("%ld byte(s) in %ld allocation(s) in %ld pool(s).\n",totalBytes,totalAllocations,totalPools);
}

/******************************************************************************/

VOID
ShowUnmarkedPools(VOID)
{
	struct PoolHeader * ph;
	struct TrackHeader * th;
	ULONG totalBytes;
	ULONG totalAllocations;
	ULONG totalPools;

	/* Show and count all pooled memory allocations. */

	totalBytes = 0;
	totalAllocations = 0;
	totalPools = 0;

	Forbid();

	/* check all registered pools */
	for(ph = (struct PoolHeader *)PoolList.mlh_Head ;
	    ph->ph_MinNode.mln_Succ != NULL ;
	    ph = (struct PoolHeader *)ph->ph_MinNode.mln_Succ)
	{
		if(IsPuddleListConsistent(ph))
		{
			/* check all allocations in this pool */
			for(th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
			    th->th_MinNode.mln_Succ != NULL ;
			    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
			{
				/* Don't count dead allocations. */
				if(th->th_Magic != 0)
				{
					if(NOT th->th_Marked)
					{
						VoiceComplaint(NULL,th,NULL);
					}
	
					totalBytes += th->th_Size;
					totalAllocations++;
				}
			}
		}

		totalPools++;
	}

	Permit();

	DPrintf("%ld byte(s) in %ld allocation(s) in %ld pool(s).\n",totalBytes,totalAllocations,totalPools);
}

/******************************************************************************/

VOID
ChangePuddleMarks(BOOL markSet)
{
	struct PoolHeader * ph;
	struct TrackHeader * th;

	/* Mark or unmark all memory puddles. */

	Forbid();

	for(ph = (struct PoolHeader *)PoolList.mlh_Head ;
	    ph->ph_MinNode.mln_Succ != NULL ;
	    ph = (struct PoolHeader *)ph->ph_MinNode.mln_Succ)
	{
		if(IsPuddleListConsistent(ph))
		{
			for(th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head ;
			    th->th_MinNode.mln_Succ != NULL ;
			    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
			{
				/* Ignore dead allocations. */
				if(th->th_Magic != 0)
				{
					th->th_Marked = markSet;
	
					/* Repair the checksum value. */
					FixTrackHeaderChecksum(th);
				}
			}
		}
	}

	Permit();
}

/******************************************************************************/

BOOL
IsPuddleListConsistent(struct PoolHeader * ph)
{
	BOOL isConsistent = TRUE;

	Forbid();

	if(NOT IsMemoryListConsistent(&ph->ph_Puddles))
	{
		ph->ph_Consistent = FALSE;

		isConsistent = FALSE;

		NewList((struct List *)&ph->ph_Puddles);
	}

	Permit();

	return(isConsistent);
}
