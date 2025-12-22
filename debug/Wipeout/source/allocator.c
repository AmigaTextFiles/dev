/*
 * $Id: allocator.c 1.14 1998/04/16 11:03:41 olsen Exp olsen $
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

STATIC struct MinList AllocationList;

/******************************************************************************/

STATIC VOID
AddAllocation(struct TrackHeader * th)
{
	/* Register the new regular memory allocation. */
	AddTail((struct List *)&AllocationList,(struct Node *)th);
}

STATIC VOID
RemoveAllocation(struct TrackHeader * th)
{
	/* Unregister the regular memory allocation. */
	Remove((struct Node *)th);
	th->th_Magic = 0;
}

/******************************************************************************/

ULONG
CalculateChecksum(const ULONG * mem,ULONG memSize)
{
	ULONG tmp,sum;
	int i;

	/* memSize must be a multiple of 4. */
	ASSERT((memSize % 4) == 0);

	/* Calculate the "additive carry wraparound" checksum
	 * for the given memory area. The Kickstart and the boot block
	 * checksums are calculated using the same technique.
	 */
	sum = 0;
	for(i = 0 ; i < memSize / 4 ; i++)
	{
		tmp = sum + mem[i];
		if(tmp < sum)
			tmp++;

		sum = tmp;
	}

	return(sum);
}

/******************************************************************************/

VOID
FixTrackHeaderChecksum(struct TrackHeader * th)
{
	ASSERT(th != NULL);

	/* Protect everything but the MinNode at the beginning
	 * with a checksum.
	 */
	th->th_Checksum = 0;
	th->th_Checksum = ~CalculateChecksum((ULONG *)&th->th_PoolHeader,
	                                     sizeof(*th) - offsetof(struct TrackHeader,th_PoolHeader));
}

/******************************************************************************/

VOID
PerformDeallocation(struct TrackHeader * th)
{
	BOOL mungMem = FALSE;
	LONG allocationSize;
	APTR poolHeader;

	allocationSize = th->th_NameTagLen + sizeof(*th) + PreWallSize + th->th_Size + th->th_PostSize;

	/* It is quasi-legal to release and reuse memory whilst under
	 * Forbid(). If this is the case, we will not stomp on the allocation
	 * body and leave the contents of the buffer unmodified. Note that
	 * while in Disable() state, multitasking will be halted, just as whilst
	 * in Forbid() state. But as there is no safe way to track whether the
	 * system actually has the interrupts disabled and because the memory
	 * allocator is documented to operate under Forbid() conditions only,
	 * we just consider the Forbid() state.
	 */
	if(NoReuse || SysBase->TDNestCnt == 0) /* not -1 because we always run under Forbid() */
		mungMem = TRUE;

	switch(th->th_Type)
	{
		case ALLOCATIONTYPE_AllocMem:
		case ALLOCATIONTYPE_AllocVec:

			RemoveAllocation(th);

			/* skip the name tag header, if there is one */
			if(th->th_NameTagLen > 0)
				th = (struct TrackHeader *)(((ULONG)th) - th->th_NameTagLen);

			/* munge the entire allocation, not just the allocation body. */
			if(mungMem)
				MungMem((ULONG *)th,allocationSize,DEADBEEF);

			(*OldFreeMem)(th,allocationSize,SysBase);
			break;

		case ALLOCATIONTYPE_AllocPooled:

			RemovePuddle(th);

			/* remember this, as it may be gone in a minute */
			poolHeader = th->th_PoolHeader->ph_PoolHeader;

			/* skip the name tag header, if there is one */
			if(th->th_NameTagLen > 0)
				th = (struct TrackHeader *)(((ULONG)th) - th->th_NameTagLen);

			/* munge the entire allocation, not just the allocation body. */
			if(mungMem)
				MungMem((ULONG *)th,allocationSize,DEADBEEF);

			(*OldFreePooled)(poolHeader,th,allocationSize,SysBase);
			break;
	}
}

/******************************************************************************/

BOOL
PerformAllocation(
	ULONG					pc,
	struct PoolHeader *		poolHeader,
	ULONG					memSize,
	ULONG					attributes,
	UBYTE					type,
	APTR *					resultPtr)
{
	struct TrackHeader * th;
	ULONG preSize;
	ULONG allocationRemainder;
	ULONG postSize;
	LONG nameTagLen;
	APTR result = NULL;
	BOOL success = FALSE;

	nameTagLen = 0;

	/* Get the name of the current task, if this is necessary. */
	if(NameTag)
		nameTagLen = GetNameTagLen(pc);

	/* If the allocation is not a multiple of the memory granularity
	 * block size, increase the post memory wall by the remaining
	 * few bytes of padding.
	 */
	allocationRemainder = (memSize % MEM_BLOCKSIZE);
	if(allocationRemainder > 0)
		allocationRemainder = MEM_BLOCKSIZE - allocationRemainder;

	preSize = PreWallSize;
	postSize = allocationRemainder + PostWallSize;

	switch(type)
	{
		case ALLOCATIONTYPE_AllocMem:

			th = (*OldAllocMem)(nameTagLen + sizeof(*th) + preSize + memSize + postSize,attributes & (~MEMF_CLEAR),SysBase);
			if(th != NULL)
			{
				/* Store the name tag data in front of the header, then
				 * adjust the header address.
				 */
				if(nameTagLen > 0)
				{
					FillNameTag(th,nameTagLen);
					th = (struct TrackHeader *)(((ULONG)th) + nameTagLen);
				}

				AddAllocation(th);
			}

			break;

		case ALLOCATIONTYPE_AllocVec:

			/* This will later contain the length long word. */
			memSize += sizeof(ULONG);

			th = (*OldAllocMem)(nameTagLen + sizeof(*th) + preSize + memSize + postSize,attributes & (~MEMF_CLEAR),SysBase);
			if(th != NULL)
			{
				/* Store the name tag data in front of the header, then
				 * adjust the header address.
				 */
				if(nameTagLen > 0)
				{
					FillNameTag(th,nameTagLen);
					th = (struct TrackHeader *)(((ULONG)th) + nameTagLen);
				}

				AddAllocation(th);
			}

			break;

		case ALLOCATIONTYPE_AllocPooled:

			th = (*OldAllocPooled)(poolHeader->ph_PoolHeader,nameTagLen + sizeof(*th) + preSize + memSize + postSize,SysBase);
			if(th != NULL)
			{
				/* Store the name tag data in front of the header, then
				 * adjust the header address.
				 */
				if(nameTagLen > 0)
				{
					FillNameTag(th,nameTagLen);
					th = (struct TrackHeader *)(((ULONG)th) + nameTagLen);
				}

				AddPuddle(poolHeader,th);
			}

			break;

		default:

			th = NULL;
			break;
	}

	if(th != NULL)
	{
		STATIC ULONG Sequence;

		UBYTE * mem;

		/* Fill in the regular header data. */
		th->th_Magic		= BASEBALL;
		th->th_PointBack	= th;
		th->th_PC			= pc;
		th->th_Owner		= FindTask(NULL);
		th->th_OwnerType	= GetTaskType(NULL);
		th->th_NameTagLen	= nameTagLen;

		GetSysTime(&th->th_Time);
		th->th_Sequence = Sequence++;

		th->th_Size			= memSize;
		th->th_PoolHeader	= poolHeader;
		th->th_Type			= type;
		th->th_FillChar		= NewFillChar();
		th->th_PostSize		= postSize;
		th->th_Marked		= FALSE;

		/* Calculate the checksum. */
		FixTrackHeaderChecksum(th);

		/* Fill in the preceding memory wall. */
		mem = (UBYTE *)(th + 1);

		memset(mem,th->th_FillChar,preSize);
		mem += preSize;

		/* Fill the memory allocation body either with
		 * junk or with zeroes.
		 */
		if(FLAG_IS_CLEAR(attributes,MEMF_CLEAR))
			MungMem((ULONG *)mem,memSize,DEADFOOD);
		else
			memset(mem,0,memSize);

		mem += memSize;

		/* Fill in the following memory wall. */
		memset(mem,th->th_FillChar,postSize);

		mem = (UBYTE *)(th + 1);
		mem += preSize;

		/* AllocVec()'ed allocations are special in that
		 * the size of the allocation precedes the header.
		 */
		if(type == ALLOCATIONTYPE_AllocVec)
		{
			/* Size of the allocation must include the
			 * size long word.
			 */
			(*(ULONG *)mem) = memSize + sizeof(ULONG);

			result = (APTR)(mem + sizeof(ULONG));
		}
		else
		{
			result = (APTR)mem;
		}

		success = TRUE;
	}

	(*resultPtr) = result;

	return(success);
}

/******************************************************************************/

BOOL
IsValidTrackHeader(struct TrackHeader * th)
{
	BOOL valid = FALSE;

	/* Check whether the calculated address looks good enough. */
	if(NOT IsInvalidAddress((ULONG)th) && NOT IsOddAddress((ULONG)th))
	{
		/* Check for the unique identifiers. */
		if(th->th_Magic == BASEBALL && th->th_PointBack == th)
			valid = TRUE;
	}

	return(valid);
}

/******************************************************************************/

BOOL
IsTrackHeaderChecksumCorrect(struct TrackHeader * th)
{
	BOOL isCorrect = FALSE;

	/* For extra safety, also take a look at the checksum. */
	if(CalculateChecksum((ULONG *)&th->th_PoolHeader,
	                     sizeof(*th) - offsetof(struct TrackHeader,th_PoolHeader)) == (ULONG)-1)
	{
		isCorrect = TRUE;
	}

	return(isCorrect);
}

/******************************************************************************/

BOOL
IsTrackedAllocation(
	ULONG					address,
	struct TrackHeader **	resultPtr)
{
	struct TrackHeader * result = NULL;
	struct TrackHeader * th;
	BOOL valid = FALSE;

	/* Move back to the memory tracking header. */
	th = (struct TrackHeader *)(address - PreWallSize - sizeof(*th));

	/* Check if the track header is valid. */
	if(IsValidTrackHeader(th) && IsTrackHeaderChecksumCorrect(th))
	{
		result = th;
		valid = TRUE;
	}

	(*resultPtr) = result;

	return(valid);
}

/******************************************************************************/

VOID
SetupAllocationList(VOID)
{
	/* Initialize the list of regular memory allocations.
	 * Pooled allocations will be stored elsewhere.
	 */
	NewList((struct List *)&AllocationList);
}

/******************************************************************************/

VOID
CheckAllocatedMemory(VOID)
{
	ULONG totalBytes;
	ULONG totalAllocations;

	/* Check and count all regular memory allocations. We look for
	 * trashed memory walls and orphaned memory.
	 */

	totalBytes = 0;
	totalAllocations = 0;

	Forbid();

	if(IsAllocationListConsistent())
	{
		struct TrackHeader * th;

		for(th = (struct TrackHeader *)AllocationList.mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			/* A magic value of 0 indicates a "dead" allocation
			 * that we left to its own devices. We don't want it
			 * to show up in our list.
			 */
			if(th->th_Magic != 0)
			{
				/* Check for trashed memory walls. */
				CheckStomping(NULL,th);

				/* Check if its creator is still with us. */
				if(NOT IsTaskStillAround(th->th_Owner))
					VoiceComplaint(NULL,th,"Orphaned allocation?\n");

				totalBytes += th->th_Size;
				totalAllocations++;
			}
		}
	}

	Permit();

	DPrintf("%ld byte(s) in %ld single allocation(s).\n",totalBytes,totalAllocations);
}

/******************************************************************************/

VOID
ShowUnmarkedMemory(VOID)
{
	ULONG totalBytes;
	ULONG totalAllocations;

	/* Show and count all unmarked regular memory allocations. */

	totalBytes = 0;
	totalAllocations = 0;

	Forbid();

	if(IsAllocationListConsistent())
	{
		struct TrackHeader * th;

		for(th = (struct TrackHeader *)AllocationList.mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			/* A magic value of 0 indicates a "dead" allocation
			 * that we left to its own devices. We don't want it
			 * to show up in our list.
			 */
			if(th->th_Magic != 0)
			{
				if(NOT th->th_Marked)
					VoiceComplaint(NULL,th,NULL);

				totalBytes += th->th_Size;
				totalAllocations++;
			}
		}
	}

	Permit();

	DPrintf("%ld byte(s) in %ld single allocation(s).\n",totalBytes,totalAllocations);
}

/******************************************************************************/

VOID
ChangeMemoryMarks(BOOL markSet)
{
	/* Mark or unmark all memory puddles. */

	Forbid();

	if(IsAllocationListConsistent())
	{
		struct TrackHeader * th;

		for(th = (struct TrackHeader *)AllocationList.mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			/* A magic value of 0 indicates a "dead" allocation
			 * that we left to its own devices.
			 */
			if(th->th_Magic != 0)
			{
				th->th_Marked = markSet;

				/* Repair the checksum value. */
				FixTrackHeaderChecksum(th);
			}
		}
	}

	Permit();
}

/******************************************************************************/

BOOL
IsAllocationListConsistent(VOID)
{
	BOOL isConsistent = TRUE;

	Forbid();

	if(NOT IsMemoryListConsistent(&AllocationList))
	{
		isConsistent = FALSE;

		DPrintf("\a** TRACKED MEMORY LIST INCONSISTENT!!! **\n");

		NewList((struct List *)&AllocationList);
	}

	Permit();

	return(isConsistent);
}

/******************************************************************************/

BOOL
IsMemoryListConsistent(struct MinList * mlh)
{
	BOOL isConsistent = TRUE;

	if(CheckConsistency)
	{
		struct TrackHeader * th;
		struct timeval lastTime = {0,0};
		ULONG lastSequence = 0;
		BOOL haveData = FALSE;

		for(th = (struct TrackHeader *)mlh->mlh_Head ;
		    th->th_MinNode.mln_Succ != NULL ;
		    th = (struct TrackHeader *)th->th_MinNode.mln_Succ)
		{
			/* check whether the header data is consistent */
			if(NOT IsInvalidAddress((ULONG)th) &&
			   NOT IsOddAddress((ULONG)th) &&
			   IsTrackHeaderChecksumCorrect(th))
			{
				/* do not test dead allocations */
				if(th->th_Magic != 0)
				{
					/* check for the unique identifiers */
					if(th->th_Magic == BASEBALL && th->th_PointBack == th)
					{
						/* the following is to check whether there are
						 * cycles in the allocation list which may have
						 * resulted through strange and unlikely memory
						 * trashing
						 */
						if(haveData)
						{
							LONG result = (-CmpTime(&th->th_Time,&lastTime));

							if(result == 0) /* both allocation times are the same? */
							{
								/* allocation sequence is smaller than previous? */
								if(th->th_Sequence <= lastSequence)
								{
									isConsistent = FALSE;
									break;
								}
							}
							else if (result < 0) /* allocation is older than previous? */
							{
								isConsistent = FALSE;
							}
						}

						lastTime		= th->th_Time;
						lastSequence	= th->th_Sequence;

						haveData = TRUE;
					}
					else
					{
						isConsistent = FALSE;
						break;
					}
				}
			}
			else
			{
				isConsistent = FALSE;
				break;
			}
		}
	}

	return(isConsistent);
}
