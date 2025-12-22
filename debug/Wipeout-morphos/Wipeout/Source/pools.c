/*
 * $Id: pools.c,v 1.10 2009/06/14 08:49:55 itix Exp $
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

#define	DEBUG_CREATEPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_DELETEPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_FLUSHPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_FUDDLEISINPOOL(...)	//DPrintf(__VA_ARGS__)
#define	DEBUG_FINDPOOL(...)			//DPrintf(__VA_ARGS__)

/******************************************************************************/

#include "installpatches.h"

/******************************************************************************/

STATIC struct MinList PoolList = { (APTR)&PoolList.mlh_Tail, NULL, (APTR)&PoolList };

STATIC struct SignalSemaphore DummySemaphore;

/******************************************************************************/

VOID
SetupPoolList(VOID)
{
	/* initialize the dummy semaphore */
	InitSemaphore(&DummySemaphore);
}

/******************************************************************************/

VOID
HoldPoolSemaphore(struct PoolHeader * ph,ULONG pc[TRACKEDCALLERSTACKSIZE])
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
		if (NOT (ph->ph_Attributes & MEMF_SEM_PROTECTED))
		{
			ULONG segment;
			ULONG offset;

			VoiceComplaint(NULL,pc,NULL,"Two tasks are accessing the same pool at the same time\n");

			DPrintf("   Already being used by task 0x%08lx",ph->ph_PoolOwner);

			if(GetTaskName(ph->ph_PoolOwner,GlobalNameBuffer,sizeof(GlobalNameBuffer)))
			{
				DPrintf(", %s \"%s\"",GetTaskTypeName(GetTaskType(ph->ph_PoolOwner)),GlobalNameBuffer);
			}

			DPrintf("\n");

			{
				int i;
				for (i=0;i<TRACKEDCALLERSTACKSIZE;i++)
				{
					if(FindAddress(ph->ph_PoolOwnerPC[i],sizeof(GlobalNameBuffer),GlobalNameBuffer,&segment,&offset))
					{
						DPrintf("CallerStack[] 0x%lx at \"%s\" Hunk %04lx Offset %08lx\n",-i,ph->ph_PC[i],GlobalNameBuffer,segment,offset);
					}
				}
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
		}

		/* wait for the other guy to release the pool */
		ObtainSemaphore(&ph->ph_SignalSemaphore);
	}

	/* register the new owner */
	ph->ph_PoolOwner	= FindTask(NULL);
	memcpy(ph->ph_PC,pc,sizeof(ph->ph_PC));
	//ph->ph_PoolOwnerPC	= pc;
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

	DEBUG_FUDDLEISINPOOL("%s: ph 0x%lx mem 0x%lx\n",__func__,ph,mem);
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
	
			DEBUG_FUDDLEISINPOOL("%s: th 0x%lx\n",__func__,th);
			DEBUG_FUDDLEISINPOOL("%s: PreSize %ld SyncSize %ld\n",__func__,th->th_PreSize,th->th_SyncSize);

			thatMem = (UBYTE *)(th + 1);
			DEBUG_FUDDLEISINPOOL("%s: SyncWall 0x%lx\n",__func__,thatMem);
			thatMem += th->th_SyncSize;
			DEBUG_FUDDLEISINPOOL("%s: PreWall 0x%lx\n",__func__,thatMem);
			thatMem += th->th_PreSize;
			DEBUG_FUDDLEISINPOOL("%s: mem 0x%lx\n",__func__,thatMem);

			if(thatMem == mem)
			{
				DEBUG_FUDDLEISINPOOL("%s: match\n",__func__);
				found = TRUE;
				break;
			}
		}
	}
	else
	{
		DEBUG_FUDDLEISINPOOL("%s: not consistent\n",__func__);
	}

	return(found);
}

/******************************************************************************/

VOID
RemovePuddle(struct TrackHeader * th)
{
	/* unregister a puddle from a pool */
	REMOVE((struct Node *)th);
	th->th_Magic = 0;
}

VOID
AddPuddle(struct PoolHeader * ph,struct TrackHeader * th)
{
	/* register a puddle in a pool */
	ADDTAIL((struct List *)&ph->ph_Puddles,(struct Node *)th);
}

/******************************************************************************/

struct PoolHeader *
FindPoolHeader(APTR poolHeader)
{
	struct PoolHeader * result = NULL;
	struct PoolHeader * node;

	//DEBUG_FINDPOOL("%s: poolHeader 0x%lx\n",__func__,poolHeader);

	Forbid();

	/* determine the pool header being tracked, if there
	 * is one
	 */
	for(node = (struct PoolHeader *)PoolList.mlh_Head ;
	    node->ph_MinNode.mln_Succ != NULL ;
	    node = (struct PoolHeader *)node->ph_MinNode.mln_Succ)
	{
		#if 0
		if (!TypeOfMem(node) || !TypeOfMem(node->ph_MinNode.mln_Succ) || !TypeOfMem(node->ph_MinNode.mln_Pred))
		{
			DEBUG_FINDPOOL("%s: bogus node 0x%lx\n",__func__,node);
			DEBUG_FINDPOOL("%s: find poolHeader 0x%lx\n",__func__,poolHeader);
			DEBUG_FINDPOOL("%s: succ 0x%lx pred 0x%lx\n",__func__,node->ph_MinNode.mln_Succ,node->ph_MinNode.mln_Pred);
			DEBUG_FINDPOOL("%s: node's ph_PoolHeader 0x%lx\n",__func__,node->ph_PoolHeader);
		}
		#endif
		if(node->ph_PoolHeader == poolHeader)
		{
			result = node;
			break;
		}
	}

	Permit();

	return(result);
}

/******************************************************************************/

BOOL
DeletePoolHeader(ULONG * stackFrame,struct PoolHeader * ph,ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	struct TrackHeader * th;
	BOOL deleteIt = TRUE;

	DEBUG_DELETEPOOL("%s: ph 0x%lx\n",__func__,ph);

	/* In any event, remove the pool from the public list.
	 * It is going to be deleted or let go in a minute.
	 */
	REMOVE((struct Node *)ph);

	/* gain exclusive access to the pool */
	HoldPoolSemaphore(ph,pc);
	ReleasePoolSemaphore(ph);

	if(IsPuddleListConsistent(ph))
	{

		th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head;
		while (th->th_MinNode.mln_Succ)
		{
			if (TypeOfMem(th))
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
					if(CheckStomping(stackFrame,pc,th))
					{
						deleteIt = FALSE;
					}

					/* Will be dead food in a minute. */
					th->th_Magic = 0;
				}
			}
			else
			{
				VoiceComplaint(stackFrame,pc,th,"Internal Header seems to be corrupt.\n");
				DPrintf("PoolHeader 0x%lx has a bogus TrackHeader 0x%lx\n",ph,th);
				deleteIt = FALSE;
				break;
			}
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ;
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

				DEBUG_DELETEPOOL("%s: mung node 0x%lx size 0x%lx\n",__func__,node,allocationSize);
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

		DEBUG_DELETEPOOL("%s: deleteIt\n",__func__);

		mem = (ULONG *)(((ULONG)ph) - ph->ph_NameTagLen);
		allocationSize = ph->ph_NameTagLen + sizeof(*ph);

		poolHeader = ph->ph_PoolHeader;

		DEBUG_DELETEPOOL("%s: mung mem 0x%lx size 0x%lx\n",__func__,mem,allocationSize);

		MungMem(mem,allocationSize,DEADBEEF);

		/*
		 * free ph
		 */
		REG_A1	=(ULONG) mem;
		//REG_D0	= allocationSize;
		REG_A6	= (ULONG)SysBase;
		ph	= (APTR)MyEmulHandle->EmulCallDirect68k(OldFreeVec);


		DEBUG_DELETEPOOL("%s: free poolHeader 0x%lx\n",__func__,poolHeader);
		REG_A0	= (ULONG)poolHeader;
		REG_A6	= (ULONG)SysBase;
		MyEmulHandle->EmulCallDirect68k(OldDeletePool);
	}
	else
	{
		DumpPoolOwner(ph);
	}

	DEBUG_DELETEPOOL("%s: deleteIt %ld\n",__func__,deleteIt);
	return(deleteIt);
}


/******************************************************************************/

BOOL
FlushPoolHeader(ULONG * stackFrame,struct PoolHeader * ph,ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	struct TrackHeader * th;
	BOOL flushIt = TRUE;

	DEBUG_FLUSHPOOL("%s: ph 0x%lx\n",__func__,ph);

	/* gain exclusive access to the pool */
	HoldPoolSemaphore(ph,pc);
	ReleasePoolSemaphore(ph);

	if(IsPuddleListConsistent(ph))
	{
		th = (struct TrackHeader *)ph->ph_Puddles.mlh_Head;
		while (th->th_MinNode.mln_Succ)
		{
			/* Check whether this pool has dead allocations.
			 * If so, do not deallocate it.
			 */
			if (TypeOfMem(th))
			{
				if(th->th_Magic == 0)
				{
					flushIt = FALSE;
				}
				else
				{
					/* Check whether this puddle has been
					 * stomped upon. If so, do not free the
					 * pool.
					 */
					if(CheckStomping(stackFrame,pc,th))
					{
						flushIt = FALSE;
					}

					/* Will be dead food in a minute. */
					th->th_Magic = 0;
				}
			}
			else
			{
				VoiceComplaint(stackFrame,pc,th,"Internal Header seems to be corrupt.\n");
				DPrintf("PoolHeader 0x%lx has a bogus TrackHeader 0x%lx\n",ph,th);
				flushIt = FALSE;
				break;
			}
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ;
		}

		/* if we can proceed to flush the
		 * pool, trash all its allocations
		 */
		if(flushIt)
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

				DEBUG_FLUSHPOOL("%s: mung node 0x%lx size 0x%lx\n",__func__,node,allocationSize);
				MungMem((ULONG *)node,allocationSize,DEADBEEF);
			}

			/*
			 * clear the puddle list database
			 */
			NEWLIST((struct List *)&ph->ph_Puddles);
		}
	}

	if(NOT ph->ph_Consistent)
	{
		flushIt = FALSE;
	}

	if(flushIt)
	{
		APTR poolHeader;

		DEBUG_FLUSHPOOL("%s: flushIt\n",__func__);

		/*
		 * clear the puddle list database
		 */
		NEWLIST((struct List *)&ph->ph_Puddles);

		poolHeader = ph->ph_PoolHeader;

		DEBUG_FLUSHPOOL("%s: flush poolHeader 0x%lx\n",__func__,poolHeader);
		REG_A0	= (ULONG)poolHeader;
		REG_A6	= (ULONG)SysBase;
		MyEmulHandle->EmulCallDirect68k(OldFlushPool);
	}
	else
	{
		DumpPoolOwner(ph);
	}

	DEBUG_FLUSHPOOL("%s: flushIt %ld\n",__func__,flushIt);
	return(flushIt);
}

/******************************************************************************/

struct PoolHeader *
CreatePoolHeader(ULONG attributes,ULONG puddleSize,ULONG threshSize,ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	struct PoolHeader * result = NULL;
	APTR header;

	/* create the pool with the MEMF_CLEAR bit cleared; if there is
	 * any clearing to be done, we want to do it on our own
	 */
	DEBUG_CREATEPOOL("%s: attributes 0x%lx puddleSize 0x%lx threshSize 0x%lx\n",__func__,attributes,puddleSize,threshSize);

	REG_D0	= attributes & (~MEMF_CLEAR);
	REG_D1	= puddleSize;
	REG_D2	= threshSize;
	REG_A6	= (ULONG)SysBase;
	header	= (APTR)MyEmulHandle->EmulCallDirect68k(OldCreatePool);
	DEBUG_CREATEPOOL("%s: header 0x%lx\n",__func__,header);
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

#if 1
		REG_D0	= nameTagLen + sizeof(*ph);
		REG_D1	= MEMF_CLEAR | MEMF_ANY;
		REG_A6	= (ULONG)SysBase;
		ph	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocVec);
#else
		ph	= OldAllocPooledAligned(SysBase, header, nameTagLen + sizeof(*ph), 4, 0);
#endif

		if(ph != NULL)
		{
			DEBUG_CREATEPOOL("%s: ph 0x%lx size 0x%lx\n",__func__,ph,sizeof(*ph));
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
			memcpy(ph->ph_PC,pc,sizeof(ph->ph_PC));
			//ph->ph_PC			= pc;
			ph->ph_Owner		= FindTask(NULL);
			ph->ph_OwnerType	= GetTaskType(NULL);
			ph->ph_NameTagLen	= nameTagLen;
			ph->ph_Consistent	= TRUE;

			GetSysTime(&ph->ph_Time);

			ph->ph_PuddleSize = puddleSize;
			ph->ph_ThreshSize = threshSize;
			ph->ph_Attributes = attributes;
			NEWLIST((struct List *)&ph->ph_Puddles);
	
			memset(&ph->ph_SignalSemaphore,0,sizeof(ph->ph_SignalSemaphore));
			InitSemaphore(&ph->ph_SignalSemaphore);
			ph->ph_PoolOwner = NULL;

			Forbid();
			ADDTAIL((struct List *)&PoolList,(struct Node *)ph);
			Permit();

			result = ph;
		}
		else
		{
			DEBUG_CREATEPOOL("%s: no ph, call old routine\n",__func__);
			REG_A0	= (ULONG)header;
			REG_A6	= (ULONG)SysBase;
			MyEmulHandle->EmulCallDirect68k(OldDeletePool);
		}
	}

	DEBUG_CREATEPOOL("%s: result 0x%lx\n",__func__,result);
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
						if(CheckStomping(NULL,NULL,th))
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

		if (CheckOrphaned)
		{
			if (!(ph->ph_Attributes & MEMF_SEM_PROTECTED))
			{
				/* check whether the creator of this pool
				 * is still with us...
				 * Only do this if the pool is local (RS)
				 */
				if(NOT IsTaskStillAround(ph->ph_Owner))
				{
					VoiceComplaint(NULL,ph->ph_PC,NULL,"Orphaned pool?\n");
					DumpPoolOwner(ph);
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
						VoiceComplaint(NULL,NULL,th,NULL);
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

		NEWLIST((struct List *)&ph->ph_Puddles);
	}

	Permit();

	return(isConsistent);
}
