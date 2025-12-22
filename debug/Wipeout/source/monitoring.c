/*
 * $Id: monitoring.c 1.5 1999/10/07 11:01:17 olsen Exp olsen $
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

STATIC VOID
WaitForBreak(VOID)
{
	STRPTR taskTypeName;

	taskTypeName = GetTaskTypeName(GetTaskType(NULL));

	/* tell the user that a task is needing attention */
	if(CANNOT GetTaskName(NULL,GlobalNameBuffer,sizeof(GlobalNameBuffer)))
	{
		DPrintf("WAITING; to continue, send ^C to %s \"%s\" (task 0x%08lx).\n",taskTypeName,GlobalNameBuffer,FindTask(NULL));
	}
	else
	{
		DPrintf("WAITING; to continue, send ^C to this %s (task 0x%08lx).\n",taskTypeName,FindTask(NULL));
	}

	/* wait for the wakeup signal */
	SetSignal(0,SIGBREAKF_CTRL_C);
	Wait(SIGBREAKF_CTRL_C);

	DPrintf("\n");
}

/******************************************************************************/

STATIC BOOL
CalledFromSupervisorMode(VOID)
{
	BOOL supervisorMode;

	supervisorMode = (BOOL)((GetCC() & 0x2000) != 0);

	/* If this routine returns TRUE, then the CPU is currently
	 * processing an interrupt request or an exception condition
	 * was triggered (more or less the same).
	 */
	return(supervisorMode);
}

/******************************************************************************/

BOOL
CheckStomping(ULONG * stackFrame,struct TrackHeader * th)
{
	BOOL wasStomped = FALSE;
	UBYTE * mem;
	LONG memSize;
	UBYTE * stompMem;
	LONG stompSize;
	UBYTE * body;

	body = ((UBYTE *)(th + 1)) + PreWallSize;

	mem = (UBYTE *)(th + 1);
	memSize = PreWallSize;

	/* check if the pre-allocation wall was trashed */
	if(WasStompedUpon(mem,memSize,th->th_FillChar,&stompMem,&stompSize))
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,th,"Front wall was stomped upon\n");

			DPrintf("%ld byte(s) stomped (0x%08lx..0x%08lx), allocation-%ld byte(s)\n",
				stompSize,stompMem,stompMem+stompSize-1,
				(LONG)body - (LONG)(stompMem+stompSize-1));

			DumpWall(stompMem,stompSize,th->th_FillChar);
		}

		wasStomped = TRUE;
	}

	mem += PreWallSize + th->th_Size;
	memSize = th->th_PostSize;

	/* check if the post-allocation wall was trashed */
	if(WasStompedUpon(mem,memSize,th->th_FillChar,&stompMem,&stompSize))
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,th,"Back wall was stomped upon\n");

			DPrintf("%ld byte(s) stomped (0x%08lx..0x%08lx), allocation+%ld byte(s)\n",
				stompSize,stompMem,stompMem+stompSize-1,
				(LONG)stompMem - (LONG)(body + th->th_Size - 1));

			DumpWall(stompMem,stompSize,th->th_FillChar);
		}

		wasStomped = TRUE;
	}

	return(wasStomped);
}

/******************************************************************************/

APTR ASM
NewAllocMem(
	REG(d0)	ULONG	byteSize,
	REG(d1) ULONG	attributes,
	REG(a2) ULONG *	stackFrame)
{
	APTR result = NULL;
	BOOL hit = FALSE;

	/* no memory allocation routine may be called from supervisor mode */
	if(NOT CalledFromSupervisorMode())
	{
		/* check if this allocation should be tracked */
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(stackFrame,NULL,"AllocMem(%ld,0x%08lx) called\n",byteSize,attributes);
				hit = TRUE;
			}
			else
			{
				/* stackFrame[16] contains the return address of the caller */
				if(CANNOT PerformAllocation(stackFrame[16],NULL,byteSize,attributes,ALLOCATIONTYPE_AllocMem,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,NULL,"AllocMem(%ld,0x%08lx) failed\n",byteSize,attributes);
						hit = TRUE;
					}
				}
			}
		}
		else
		{
			result = (*OldAllocMem)(byteSize,attributes,SysBase);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"AllocMem(%ld,0x%08lx) called from interrupt/exception\n",byteSize,attributes);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID ASM
NewFreeMem(
	REG(a1)	APTR	memoryBlock,
	REG(d0) ULONG	byteSize,
	REG(a2) ULONG *	stackFrame)
{
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(memoryBlock == NULL || byteSize == NULL)
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,NULL,"FreeMem(0x%08lx,%ld) called\n",memoryBlock,byteSize);
				hit = TRUE;
			}
		}
		else
		{
			struct TrackHeader * th;
			BOOL freeIt = TRUE;

			/* check whether the memory list is consistent */
			if(CheckConsistency && NOT IsAllocationListConsistent())
			{
				freeIt = FALSE;
			}

			/* memory may be deallocated only from an even address */
			if(IsOddAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeMem(0x%08lx,%ld) on odd address\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* check if the address points into RAM */
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeMem(0x%08lx,%ld) on illegal address\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* check if the memory to free is really allocated */
			if(NOT IsAllocatedMemory((ULONG)memoryBlock,byteSize))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeMem(0x%08lx,%ld) not in allocated memory\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* now test whether the allocation was tracked by us */
			if(IsTrackedAllocation((ULONG)memoryBlock,&th))
			{
				/* check whether the allocation walls were trashed */
				if(CheckStomping(stackFrame,th))
				{
					freeIt = FALSE;

					if(IsActive)
					{
						hit = TRUE;
					}
				}
	
				if(byteSize != th->th_Size)
				{
					if(IsActive)
					{
						VoiceComplaint(stackFrame,th,"Free size %ld does not match allocation size %ld\n",byteSize,th->th_Size);
						hit = TRUE;
					}
	
					freeIt = FALSE;
				}
	
				if(th->th_Type != ALLOCATIONTYPE_AllocMem)
				{
					if(IsActive)
					{
						VoiceComplaint(stackFrame,th,"In FreeMem(0x%08lx,%ld): Memory was not allocated with AllocMem()\n",memoryBlock,byteSize);
						hit = TRUE;
					}
	
					freeIt = FALSE;
				}
	
				if(freeIt)
				{
					PerformDeallocation(th);
				}
				else
				{
					/* Let it go, but don't deallocate it. */
					th->th_Magic = 0;
					FixTrackHeaderChecksum(th);
				}
			}
			else
			{
				if(freeIt)
				{
					(*OldFreeMem)(memoryBlock,byteSize,SysBase);
				}
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"FreeMem(0x%08lx,%ld) called from interrupt/exception\n",memoryBlock,byteSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR ASM
NewAllocVec(
	REG(d0)	ULONG	byteSize,
	REG(d1) ULONG	attributes,
	REG(a2) ULONG *	stackFrame)
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(stackFrame,NULL,"AllocVec(%ld,0x%08lx) called\n",byteSize,attributes);
				hit = TRUE;
			}
			else
			{
				if(CANNOT PerformAllocation(stackFrame[16],NULL,byteSize,attributes,ALLOCATIONTYPE_AllocVec,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,NULL,"AllocVec(%ld,0x%08lx) failed\n",byteSize,attributes);
						hit = TRUE;
					}
				}
			}
		}
		else
		{
			result = (*OldAllocVec)(byteSize,attributes,SysBase);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"AllocVec(%ld,0x%08lx) called from interrupt/exception\n",byteSize,attributes);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID ASM
NewFreeVec(
	REG(a1)	APTR	memoryBlock,
	REG(a2) ULONG *	stackFrame)
{
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(memoryBlock != NULL)
		{
			struct TrackHeader * th;
			BOOL freeIt = TRUE;

			/* check whether the memory list is consistent */
			if(CheckConsistency && NOT IsAllocationListConsistent())
			{
				freeIt = FALSE;
			}

			if(IsOddAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeVec(0x%08lx) on odd address\n",memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeVec(0x%08lx) on illegal address\n",memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* note that in order to check the size and the place of the
			 * allocation, the address must be valid
			 */
			if(freeIt && NOT IsAllocatedMemory(((ULONG)memoryBlock)-4,(*(ULONG *)(((ULONG)memoryBlock)-4))))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreeVec(0x%08lx) not in allocated memory\n",memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			if(IsTrackedAllocation(((ULONG)memoryBlock) - sizeof(ULONG),&th))
			{
				if(CheckStomping(stackFrame,th))
				{
					freeIt = FALSE;

					if(IsActive)
					{
						hit = TRUE;
					}
				}
	
				if(th->th_Type != ALLOCATIONTYPE_AllocVec)
				{
					if(IsActive)
					{
						VoiceComplaint(stackFrame,th,"In FreeVec(0x%08lx): Memory was not allocated with AllocVec()\n",memoryBlock);
						hit = TRUE;
					}
	
					freeIt = FALSE;
				}
	
				if(freeIt)
				{
					PerformDeallocation(th);
				}
				else
				{
					/* Let it go, but don't deallocate it. */
					th->th_Magic = 0;
					FixTrackHeaderChecksum(th);
				}
			}
			else
			{
				if(freeIt)
				{
					(*OldFreeVec)(memoryBlock,SysBase);
				}
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"FreeVec(0x%08lx) called from interrupt/exception\n",memoryBlock);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR ASM
NewCreatePool(
	REG(d0)	ULONG	memFlags,
	REG(d1) ULONG	puddleSize,
	REG(d2) ULONG	threshSize,
	REG(a2) ULONG *	stackFrame)
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			/* the puddle threshold size must not be larger
			 * than the puddle size
			 */
			if(threshSize <= puddleSize)
			{
				struct PoolHeader * ph;
		
				ph = CreatePoolHeader(memFlags,puddleSize,threshSize,stackFrame[16]);
				if(ph != NULL)
				{
					result = ph->ph_PoolHeader;
				}
				else
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,NULL,"CreatePool(0x%08lx,%ld,%ld) failed\n",memFlags,puddleSize,threshSize);
						hit = TRUE;
					}
				}
			}
			else
			{
				VoiceComplaint(stackFrame,NULL,"Threshold size %ld must be <= puddle size %ld\n",threshSize,puddleSize);
				hit = TRUE;
			}
		}
		else
		{
			result = (*OldCreatePool)(memFlags,puddleSize,threshSize,SysBase);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"CreatePool(0x%08lx,%ld,%ld) called from interrupt/exception\n",memFlags,puddleSize,threshSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID ASM
NewDeletePool(
	REG(a0) APTR	poolHeader,
	REG(a2) ULONG *	stackFrame)
{
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(poolHeader != NULL)
		{
			struct PoolHeader * ph;
	
			ph = FindPoolHeader(poolHeader);
			if(ph != NULL)
			{
				BOOL freeIt = TRUE;

				/* check whether the memory list is consistent */
				if(CheckConsistency && NOT IsPuddleListConsistent(ph))
				{
					freeIt = FALSE;
				}

				/* note that DeletePoolHeader() implies
				 * HoldPoolSemaphore()..ReleasePoolSemaphore()
				 */
				if(freeIt && CANNOT DeletePoolHeader(stackFrame,ph))
				{
					if(IsActive)
					{
						hit = TRUE;
					}
				}
			}
			else
			{
				(*OldDeletePool)(poolHeader,SysBase);
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,NULL,"DeletePool(NULL) called\n");
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"DeletePool(0x%08lx) called from interrupt/exception\n",poolHeader);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR ASM
NewAllocPooled(
	REG(a0) APTR	poolHeader,
	REG(d0) ULONG	memSize,
	REG(a2) ULONG *	stackFrame)
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(memSize <= 0x7FFFFFFF && IsActive && CanAllocate())
		{
			if(poolHeader != NULL && memSize > 0)
			{
				struct PoolHeader * ph;

				/* check whether this memory pool is being tracked */
				ph = FindPoolHeader(poolHeader);
				if(ph != NULL)
				{
					BOOL allocateIt = TRUE;

					if(CheckConsistency && NOT IsPuddleListConsistent(ph))
					{
						allocateIt = FALSE;
					}

					if(allocateIt)
					{
						HoldPoolSemaphore(ph,stackFrame[16]);
	
						if(CANNOT PerformAllocation(stackFrame[16],ph,memSize,ph->ph_Attributes,ALLOCATIONTYPE_AllocPooled,&result))
						{
							if(ShowFail)
							{
								VoiceComplaint(stackFrame,NULL,"AllocPooled(0x%08lx,%ld) failed\n",poolHeader,memSize);
								hit = TRUE;
							}
						}
	
						ReleasePoolSemaphore(ph);
					}
				}
				else
				{
					result = (*OldAllocPooled)(poolHeader,memSize,SysBase);
				}
			}
			else
			{
				VoiceComplaint(stackFrame,NULL,"AllocPooled(0x%08lx,%ld) called\n",poolHeader,memSize);
				hit = TRUE;
			}
		}
		else
		{
			result = (*OldAllocPooled)(poolHeader,memSize,SysBase);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"AllocPooled(0x%08lx,%ld) called from interrupt/exception\n",poolHeader,memSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID ASM
NewFreePooled(
	REG(a0)	APTR	poolHeader,
	REG(a1)	APTR	memoryBlock,
	REG(d0) ULONG	memSize,
	REG(a2) ULONG *	stackFrame)
{
	BOOL hit = FALSE;

	if(NOT CalledFromSupervisorMode())
	{
		if(poolHeader != NULL && memoryBlock != NULL && memSize > 0)
		{
			struct PoolHeader * ph;
			BOOL freeIt = TRUE;
	
			if(IsOddAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) on odd address\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) on illegal address\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(NOT IsAllocatedMemory((ULONG)memoryBlock,memSize))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) not in allocated memory\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			ph = FindPoolHeader(poolHeader);
			if(ph != NULL)
			{
				if(CheckConsistency && NOT IsPuddleListConsistent(ph))
				{
					freeIt = FALSE;
				}

				if(freeIt)
				{
					struct TrackHeader * th;
	
					HoldPoolSemaphore(ph,stackFrame[16]);
	
					if(NOT PuddleIsInPool(ph,memoryBlock))
					{
						if(IsActive)
						{
							VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) not in pool\n",poolHeader,memoryBlock,memSize);
							DumpPoolOwner(ph);
	
							hit = TRUE;
						}
			
						freeIt = FALSE;
					}
	
					if(IsTrackedAllocation((ULONG)memoryBlock,&th))
					{
						if(CheckStomping(stackFrame,th))
						{
							freeIt = FALSE;
	
							if(IsActive)
							{
								hit = TRUE;
							}
						}
			
						if(memSize != th->th_Size)
						{
							if(IsActive)
							{
								VoiceComplaint(stackFrame,th,"Free size %ld does not match allocation size %ld\n",memSize,th->th_Size);
								hit = TRUE;
							}
		
							freeIt = FALSE;
						}
		
						if(th->th_PoolHeader->ph_PoolHeader != poolHeader)
						{
							if(IsActive)
							{
								struct PoolHeader * ph;
	
								VoiceComplaint(stackFrame,th,"FreePooled(0x%08lx,0x%08lx,%ld) called on puddle in wrong pool (right=0x%08lx wrong=0x%08lx)\n",poolHeader,memoryBlock,memSize,th->th_PoolHeader->ph_PoolHeader,poolHeader);
								hit = TRUE;
	
								DumpPoolOwner(th->th_PoolHeader);
	
								ph = FindPoolHeader(poolHeader);
								if(ph != NULL)
									DumpPoolOwner(ph);
							}
		
							freeIt = FALSE;
						}
		
						if(th->th_Type != ALLOCATIONTYPE_AllocPooled)
						{
							if(IsActive)
							{
								VoiceComplaint(stackFrame,th,"In FreePooled(0x%08lx,0x%08lx,%ld): Memory was not allocated with AllocPooled()\n",poolHeader,memoryBlock,memSize);
								hit = TRUE;
							}
		
							freeIt = FALSE;
						}
		
						if(freeIt)
						{
							PerformDeallocation(th);
						}
						else
						{
							/* Let it go, but don't deallocate it. */
							th->th_Magic = 0;
							FixTrackHeaderChecksum(th);
						}
					}
					else
					{
						if(IsActive)
						{
							VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called on puddle that is not in pool\n",poolHeader,memoryBlock,memSize);
							hit = TRUE;
						}
					}
	
					ReleasePoolSemaphore(ph);
				}
			}
			else
			{
				if(freeIt)
				{
					(*OldFreePooled)(poolHeader,memoryBlock,memSize,SysBase);
				}
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called\n",poolHeader,memoryBlock,memSize);
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called from interrupt/exception\n",poolHeader,memoryBlock,memSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}
