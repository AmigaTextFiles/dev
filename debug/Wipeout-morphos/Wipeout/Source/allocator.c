/*
 * $Id: allocator.c,v 1.13 2009/06/14 22:03:57 itix Exp $
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

#define	TESTMODE FALSE
#define	TESTSIZE(x) (((x)==0x18) || ((x)==0x18798))	//((x)==20)	//1572
#define TESTTYPE(x) TRUE //(x==ALLOCATIONTYPE_AllocMem)
/******************************************************************************/

#include "installpatches.h"

/******************************************************************************/

STATIC struct MinList AllocationList = { (APTR)&AllocationList.mlh_Tail, NULL, (APTR)&AllocationList };

/******************************************************************************/

__inline__ STATIC VOID
AddAllocation(struct TrackHeader * th)
{
	/* Register the new regular memory allocation. */
	ADDTAIL((struct List *)&AllocationList,(struct Node *)th);
}

__inline__ STATIC VOID
RemoveAllocation(struct TrackHeader * th)
{
	/* Unregister the regular memory allocation. */
	REMOVE((struct Node *)th);
	th->th_Magic = 0;
}

/******************************************************************************/
#if 1
/*
 * no need for this slow chksum
 */
ULONG
CalculateChecksum(const ULONG * mem,ULONG memSize)
{
	ULONG sum;
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
		sum += *mem++;
	}

	return(sum);
}
#else
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
#endif
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

	allocationSize = th->th_NameTagLen + sizeof(*th) + th->th_SyncSize + th->th_PreSize + th->th_Size + th->th_PostSize;

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

			REG_A1 = (ULONG)th;
			REG_D0 = allocationSize;
			REG_A6 = (ULONG)SysBase;
			MyEmulHandle->EmulCallDirect68k(OldFreeMem);
			break;

		case ALLOCATIONTYPE_AllocPooled:
		case ALLOCATIONTYPE_AllocVecPooled:

			RemovePuddle(th);

			/* remember this, as it may be gone in a minute */
			poolHeader = th->th_PoolHeader->ph_PoolHeader;

			/* skip the name tag header, if there is one */
			if(th->th_NameTagLen > 0)
				th = (struct TrackHeader *)(((ULONG)th) - th->th_NameTagLen);

			/* munge the entire allocation, not just the allocation body. */
			if(mungMem)
				MungMem((ULONG *)th,allocationSize,DEADBEEF);

			REG_A0 = (ULONG)poolHeader;
			REG_A1 = (ULONG)th;
			REG_D0 = allocationSize;
			REG_A6 = (ULONG)SysBase;
			MyEmulHandle->EmulCallDirect68k(OldFreePooled);
			break;
	}
}

/******************************************************************************/

BOOL
PerformAllocation(
	ULONG					pc[TRACKEDCALLERSTACKSIZE],
	struct PoolHeader *		poolHeader,
	ULONG					memSize,
	ULONG					attributes,
	UBYTE					type,
	APTR *					resultPtr)
{
	/* This will later contain the length long word. */
	CONST ULONG vecSize	= (type == ALLOCATIONTYPE_AllocVec || type == ALLOCATIONTYPE_AllocVecPooled) ? sizeof(ULONG) : 0;

	struct TrackHeader * th;
	ULONG preSize;
	ULONG allocationRemainder;
	ULONG postSize;
	ULONG trackSize;
	ULONG syncSize;
	LONG nameTagLen;
	APTR result = NULL;
	BOOL success = FALSE;

	nameTagLen = 0;

	#if TESTMODE
	if (TESTSIZE(memSize) && TESTTYPE(type))
	{
		DPrintf("%s: poolHeader 0x%lx memsize 0x%lx attributes 0x%lx\n",__func__,poolHeader,memSize,attributes);
		DPrintf("%s: resultptr 0x%lx\n",__func__,resultPtr);
		if (poolHeader)
		{
			DPrintf("%s: ph_PoolHeader 0x%lx ph_Attributes 0x%lx\n",__func__,poolHeader->ph_PoolHeader,poolHeader->ph_Attributes);
			DPrintf("%s: ph_Owner 0x%lx ph_OwnerType 0x%lx\n",__func__,poolHeader->ph_Owner,poolHeader->ph_OwnerType);
			DPrintf("%s: ph_PoolOwner 0x%lx\n",__func__,poolHeader->ph_PoolOwner);
		}
	}
	#endif

	/* Get the name of the current task, if this is necessary. */
	if(NameTag)
		nameTagLen = GetNameTagLen(pc);

	/* If the allocation is not a multiple of the memory granularity
	 * block size, increase the post memory wall by the remaining
	 * few bytes of padding.
	 */
	allocationRemainder = ((memSize+vecSize) % MEM_BLOCKSIZE);
	if(allocationRemainder > 0)
	{
		allocationRemainder = MEM_BLOCKSIZE - allocationRemainder;
	}

	preSize = PreWallSize;
	postSize = allocationRemainder + PostWallSize;
	trackSize = nameTagLen + sizeof(*th) + preSize;
	/*
	 * calc sync gap between TrackHeader and PreWall
	 */
	syncSize = trackSize % MEM_BLOCKSIZE;

	trackSize += syncSize;

	trackSize += postSize;
	/*
	 * Add vecSize element
	 */
    trackSize += vecSize;

	#if TESTMODE
	if (TESTSIZE(memSize) && TESTTYPE(type))
	{
		DPrintf("%s: type %ld memSize %ld syncSize %ld preSize %ld postSize %ld trackSize %ld vecSize %ld nameTagLen %ld allocationRemainder %ld\n",__func__,type,memSize,syncSize,preSize,postSize,trackSize,vecSize,nameTagLen,allocationRemainder);
		DPrintf("%s: blocksize %ld\n",__func__,trackSize+memSize);
	}
	#endif
	switch(type)
	{
		case ALLOCATIONTYPE_AllocVec:
		case ALLOCATIONTYPE_AllocMem:
			REG_D0	= trackSize + memSize;
			REG_D1	= attributes & (~MEMF_CLEAR);
			REG_A6	= (ULONG)SysBase;
			th	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocMem);
			if(th != NULL)
			{
				/* Store the name tag data in front of the header, then
				 * adjust the header address.
				 */
				if(nameTagLen > 0)
				{
					#if TESTMODE
					if (TESTSIZE(memSize) && TESTTYPE(type))
					{
						DPrintf("%s: nametag 0x%lx\n",__func__,th);
					}
					#endif
					FillNameTag(th,nameTagLen);
					th = (struct TrackHeader *)(((ULONG)th) + nameTagLen);
				}

				AddAllocation(th);
			}
			break;

		case ALLOCATIONTYPE_AllocVecPooled:
		case ALLOCATIONTYPE_AllocPooled:
			REG_A0	=(ULONG) poolHeader->ph_PoolHeader;
			REG_D0	= trackSize + memSize;
			REG_A6	= (ULONG)SysBase;
			th	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocPooled);
			if(th != NULL)
			{
				/* Store the name tag data in front of the header, then
				 * adjust the header address.
				 */
				if(nameTagLen > 0)
				{
					#if TESTMODE
					if (TESTSIZE(memSize) && TESTTYPE(type))
					{
						DPrintf("%s: nametag 0x%lx\n",__func__,th);
					}
					#endif
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

	#if TESTMODE
	if (TESTSIZE(memSize) && TESTTYPE(type))
	{
		DPrintf("%s: th 0x%lx\n",__func__,th);
	}
	#endif

	if(th != NULL)
	{
		STATIC ULONG Sequence;

		UBYTE * mem;

		/* AllocVec/AllocVecPooled fixed memSize */
		memSize	+= vecSize;

		/* Fill in the regular header data. */
		th->th_Magic		= BASEBALL;
		th->th_PointBack	= th;
		memcpy(th->th_PC,pc,sizeof(th->th_PC));
		//th->th_PC			= pc;
		th->th_Owner		= FindTask(NULL);
		th->th_OwnerType	= GetTaskType(NULL);
		th->th_NameTagLen	= nameTagLen;

		GetSysTime(&th->th_Time);
		th->th_Sequence		= Sequence++;

		th->th_Size			= memSize;
		th->th_PoolHeader	= poolHeader;
		th->th_Type			= type;
		th->th_FillChar		= NewFillChar();
		th->th_PostSize		= postSize;
		th->th_PreSize		= preSize;
		th->th_SyncSize		= syncSize;
		th->th_Marked		= FALSE;

		/* Calculate the checksum. */
		FixTrackHeaderChecksum(th);

		/* Fill in the preceding memory wall. */
		mem = (UBYTE *)(th + 1);

		if (syncSize > 0)
		{
			#if TESTMODE
			if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
			{
				DPrintf("%s: syncWall 0x%lx syncSize %ld\n",__func__,mem,syncSize);
			}
			#endif
			MungMem((ULONG *)mem,syncSize,SYNCWORD);
			mem += syncSize;
		}

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: preWall 0x%lx preSize %ld\n",__func__,mem,preSize);
		}
		#endif

		memset(mem,th->th_FillChar,preSize);
		mem += preSize;

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: body 0x%lx, memSize %ld\n",__func__,mem,memSize);
		}
		#endif

		/* Fill the memory allocation body either with
		 * junk or with zeroes.
		 */
		if(FLAG_IS_CLEAR(attributes,MEMF_CLEAR))
			MungMem((ULONG *)mem,memSize,DEADFOOD);
		else
			memset(mem,0,memSize);

		/* AllocVec()'ed allocations are special in that
		 * the size of the allocation precedes the header.
		 */
		if (vecSize > 0)
		{
			/* Size of the allocation must include the
			 * size long word.
			 */
			(*(ULONG *)mem) = memSize;

			result = (APTR)(mem + sizeof(ULONG));
			#if TESTMODE
			if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
			{
				DPrintf("%s: vec result 0x%lx\n",__func__,result);
			}
			#endif
		}
		else
		{
			result = (APTR)mem;
		}

		mem += memSize;

		/* Fill in the following memory wall. */
		memset(mem,th->th_FillChar,postSize);

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: postWall 0x%lx postSize %ld\n",__func__,mem,postSize);
		}
		#endif

		success = TRUE;
	}

#if TESTMODE
	if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
	{
		DPrintf("%s: resultptr 0x%lx\n",__func__,resultPtr);
		DPrintf("%s: ret 0x%lx\n",__func__,result);
	}
#endif
	(*resultPtr) = result;

#if TESTMODE
	if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
	{
		DPrintf("%s: *resultptr 0x%lx\n",__func__,*resultPtr);
	}
#endif

	return(success);
}

/******************************************************************************/

#warning "probably broken..untested"
BOOL
PerformAllocationAligned(
	ULONG					pc[TRACKEDCALLERSTACKSIZE],
	struct PoolHeader *		poolHeader,
	ULONG					memSize,
	ULONG					attributes,
	ULONG					align,
	ULONG					offset,
	UBYTE					type,
	APTR *					resultPtr)
{
	/* This will later contain the length long word. */
	CONST ULONG vecSize	= (type == ALLOCATIONTYPE_AllocVec || type == ALLOCATIONTYPE_AllocVecPooled) ? sizeof(ULONG) : 0;

	struct TrackHeader * th;
	ULONG preSize;
	ULONG allocationRemainder;
	ULONG postSize;
	ULONG trackSize;
	ULONG syncSize;
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
	{
		allocationRemainder = MEM_BLOCKSIZE - allocationRemainder;
	}

	preSize = PreWallSize;
	postSize = allocationRemainder + PostWallSize;
	trackSize = nameTagLen + sizeof(*th) + preSize + vecSize;

	offset &= (align - 1); /* clamp silly offset */
	syncSize = offset;
	if (trackSize % align)
	{
		// trackSize misaligns
		syncSize += align - (trackSize % align);
	}
	trackSize += syncSize;

	// enlarge preSize to fix alignment and offset

	trackSize	+= offset;
	//preSize		+= offset;

	trackSize	+= postSize;

#if TESTMODE
	if (TESTSIZE(memSize) && TESTTYPE(type))
	{
		DPrintf("%s: type %ld memSize %ld syncSize %ld preSize %ld postSize %ld trackSize %ld vecSize %ld nameTagLen %ld allocationRemainder %ld\n",__func__,type,memSize,syncSize,preSize,postSize,trackSize,vecSize,nameTagLen,allocationRemainder);
		DPrintf("%s: realsize %ld\n",__func__,trackSize+memSize);
	}
#endif
	switch(type)
	{
		case ALLOCATIONTYPE_AllocVec:
		case ALLOCATIONTYPE_AllocMem:
			th	= (*OldAllocMemAligned)(SysBase, trackSize + memSize, attributes & (~MEMF_CLEAR), align, 0);
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

		case ALLOCATIONTYPE_AllocVecPooled:
		case ALLOCATIONTYPE_AllocPooled:
			th	= OldAllocPooledAligned(SysBase, poolHeader->ph_PoolHeader, trackSize + memSize, align, 0);
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

#if TESTMODE
	if (TESTSIZE(memSize) && TESTTYPE(type))
	{
		DPrintf("%s: th 0x%lx\n",__func__,th);
	}
#endif

	if(th != NULL)
	{
		STATIC ULONG Sequence;

		UBYTE * mem;

		/* AllocVec/AllocVecPooled fixed memSize */
		memSize	+= vecSize;

		/* Fill in the regular header data. */
		th->th_Magic		= BASEBALL;
		th->th_PointBack	= th;
		memcpy(th->th_PC,pc,sizeof(th->th_PC));
		//th->th_PC			= pc;
		th->th_Owner		= FindTask(NULL);
		th->th_OwnerType	= GetTaskType(NULL);
		th->th_NameTagLen	= nameTagLen;

		GetSysTime(&th->th_Time);
		th->th_Sequence		= Sequence++;

		th->th_Size			= memSize;
		th->th_PoolHeader	= poolHeader;
		th->th_Type			= type;
		th->th_FillChar		= NewFillChar();
		th->th_PostSize		= postSize;
		th->th_PreSize		= preSize;
		th->th_SyncSize		= syncSize;
		th->th_Marked		= FALSE;

		/* Calculate the checksum. */
		FixTrackHeaderChecksum(th);

		/* Fill in the preceding memory wall. */
		mem = (UBYTE *)(th + 1);

		if (syncSize > 0)
		{
			#if TESTMODE
			if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
			{
				DPrintf("%s: syncWall 0x%lx syncSize %ld\n",__func__,mem,syncSize);
			}
			#endif
			MungMem((ULONG *)mem,syncSize,SYNCWORD);
			mem += syncSize;
		}

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: preWall 0x%lx preSize %ld\n",__func__,mem,preSize);
		}
		#endif
		memset(mem,th->th_FillChar,preSize);
		mem += preSize;

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: body 0x%lx, memSize %ld\n",__func__,mem,memSize);
		}
		#endif

		/* Fill the memory allocation body either with
		 * junk or with zeroes.
		 */
		if(FLAG_IS_CLEAR(attributes,MEMF_CLEAR))
			MungMem((ULONG *)mem,memSize,DEADFOOD);
		else
			memset(mem,0,memSize);

		/* AllocVec()'ed allocations are special in that
		 * the size of the allocation precedes the header.
		 */
		if(type == ALLOCATIONTYPE_AllocVec || type == ALLOCATIONTYPE_AllocVecPooled)
		{
			/* Size of the allocation must include the
			 * size long word.
			 */
			(*(ULONG *)mem) = memSize;

			result = (APTR)(mem + sizeof(ULONG));
			#if TESTMODE
			if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
			{
				DPrintf("%s: vec result 0x%lx\n",__func__,result);
			}
			#endif
		}
		else
		{
			result = (APTR)mem;
		}

		mem += memSize;

		/* Fill in the following memory wall. */
		memset(mem,th->th_FillChar,postSize);

		#if TESTMODE
		if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
		{
			DPrintf("%s: postWall 0x%lx postSize %ld\n",__func__,mem,postSize);
		}
		#endif

		success = TRUE;
	}

	#if TESTMODE
	if (TESTSIZE(memSize-vecSize) && TESTTYPE(type))
	{
		DPrintf("%s: ret 0x%lx\n",__func__,result);
	}
	#endif
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

struct TrackHeader *
IsTrackedAllocation(
	ULONG					address)
{
	struct TrackHeader * th;

	//DPrintf("%s: return 0x%lx\n",__func__,__builtin_return_address(0));

	/* Move back to the memory tracking header. */
#if 1
	{
		ULONG *ptr;
		ptr = (ULONG*) (address - PreWallSize);
		while (*--ptr==SYNCWORD);
		ptr++;
		th = (struct TrackHeader *) (((ULONG) ptr) - sizeof(*th));
	}
#else
	th = (struct TrackHeader *)(address - PreWallSize - sizeof(*th));
#endif
	/* Check if the track header is valid. */
	if (!(IsValidTrackHeader(th) && IsTrackHeaderChecksumCorrect(th)))
	{
		th = NULL;
	}

	return(th);
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
				CheckStomping(NULL,0,th);

				if(CheckConsistency)
				{
					if (CheckOrphaned)
					{
						/* Check if its creator is still with us. */
						if(NOT IsTaskStillAround(th->th_Owner))
							VoiceComplaint(NULL,NULL,th,"Orphaned allocation? Owner Task 0x%lx is gone\n",th->th_Owner);
					}
				}

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
					VoiceComplaint(NULL,NULL,th,NULL);

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

		NEWLIST((struct List *)&AllocationList);
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
