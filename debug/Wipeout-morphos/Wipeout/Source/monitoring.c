/*
 * $Id: monitoring.c,v 1.12 2009/02/23 01:24:09 piru Exp $
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

#define	TESTMODE 0
#define	DEBUG_CREATEPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_DELETEPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_FLUSHPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_ALLOCPOOL(...)		//if (memSize==20) DPrintf(__VA_ARGS__)
#define	DEBUG_ALLOCVECPOOL(...)		//DPrintf(__VA_ARGS__)
#define	DEBUG_ALLOCPOOLALIGN(...)	//DPrintf(__VA_ARGS__)
#define	DEBUG_FREEPOOL(...)			//if (memSize==20) DPrintf(__VA_ARGS__)
#define	DEBUG_FREEVECPOOL(...)		//DPrintf(__VA_ARGS__)

/******************************************************************************/

#include "installpatches.h"

/******************************************************************************/

STATIC VOID
WaitForBreak(VOID)
{
	CONST_STRPTR taskTypeName;

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
CheckStomping(ULONG * stackFrame,ULONG pc[TRACKEDCALLERSTACKSIZE],struct TrackHeader * th)
{
	BOOL wasStomped = FALSE;
	UBYTE * mem;
	LONG memSize;
	UBYTE * stompMem;
	LONG stompSize;
	UBYTE * body;

	body = ((UBYTE *)(th + 1)) + th->th_SyncSize + PreWallSize;

	mem = (UBYTE *)(th + 1);

	mem += th->th_SyncSize;

	memSize = PreWallSize;

	/* check if the pre-allocation wall was trashed */
	if (TypeOfMem(mem))
    {
		if(WasStompedUpon(mem,memSize,th->th_FillChar,&stompMem,&stompSize))
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,th,"Front wall was stomped upon\n");

				DPrintf("%ld byte(s) stomped (0x%08lx..0x%08lx), allocation-%ld byte(s), FillChar 0x%lx\n",
					stompSize,stompMem,stompMem+stompSize-1,
					(LONG)body - (LONG)(stompMem+stompSize-1),
					th->th_FillChar);

				DumpWall(stompMem,stompSize,th->th_FillChar);

				#if 0
				DPrintf("prewall 0x%lx Size 0x%08lx\n",
					mem,memSize);

				DPrintf("th 0x%lx thend 0x%lx body 0x%08lx PreWallSize 0x%08lx th_Size %ld th_PostSize %ld th_SyncSize %ld\n",
					th,th+1,body,PreWallSize,th->th_Size,th->th_PostSize,th->th_SyncSize);
				{
					UBYTE * mem;
					mem = (UBYTE *)(th + 1);

					DPrintf("sync:\n");
					DumpArea(mem, th->th_SyncSize);

					mem += th->th_SyncSize;

					memSize = PreWallSize;
					
					DPrintf("pre:\n");
					DumpArea(mem, memSize);

					mem += PreWallSize;
					memSize = th->th_Size;

					DPrintf("body:\n");
					DumpArea(mem, memSize);

					mem += th->th_Size;
					memSize = th->th_PostSize;

					DPrintf("post:\n");
					DumpArea(mem, memSize);

				}
				#endif
			}

			wasStomped = TRUE;
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,th,"Internal Header seems to be corrupt. Front wall can't be checked anymore. Serious!\n");
			DPrintf("TrackHeader 0x%lx\n",th);
			DPrintf(" SyncSize 0x%lx\n",th->th_SyncSize);
			DPrintf(" Front Wall 0x%lx is bogus\n",mem);

			DumpArea(th,sizeof(*th));

		}
		wasStomped = TRUE;
	}
	mem += PreWallSize + th->th_Size;
	memSize = th->th_PostSize;

	if (TypeOfMem(mem))
    {
		/* check if the post-allocation wall was trashed */
		if(WasStompedUpon(mem,memSize,th->th_FillChar,&stompMem,&stompSize))
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,th,"Back wall was stomped upon\n");

				DPrintf("%ld byte(s) stomped (0x%08lx..0x%08lx), allocation+%ld byte(s), FillChar 0x%lx\n",
					stompSize,stompMem,stompMem+stompSize-1,
					(LONG)stompMem - (LONG)(body + th->th_Size - 1),
					th->th_FillChar);

				DumpWall(stompMem,stompSize,th->th_FillChar);

				#if 0
				DPrintf("postwall 0x%lx Size 0x%08lx\n",
					mem,memSize);

				DPrintf("th 0x%lx thend 0x%lx body 0x%08lx PreWallSize 0x%08lx th_Size %ld th_PostSize %ld th_SyncSize %ld\n",
					th,th+1,body,PreWallSize,th->th_Size,th->th_PostSize,th->th_SyncSize);
				{
					UBYTE * mem;
					mem = (UBYTE *)(th + 1);

					DPrintf("sync:\n");
					DumpArea(mem, th->th_SyncSize);

					mem += th->th_SyncSize;

					memSize = PreWallSize;
					
					DPrintf("pre:\n");
					DumpArea(mem, memSize);

					mem += PreWallSize;
					memSize = th->th_Size;

					DPrintf("body:\n");
					DumpArea(mem, memSize);

					mem += th->th_Size;
					memSize = th->th_PostSize;

					DPrintf("post:\n");
					DumpArea(mem, memSize);

				}
				#endif
			}

			wasStomped = TRUE;
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,th,"Internal Header seems to be corrupt. Post wall can't be checked anymore. Serious!\n");
			DPrintf("TrackHeader 0x%lx\n",th);
			DPrintf(" SyncSize 0x%lx\n",th->th_SyncSize);
			DPrintf(" Post Wall 0x%lx is bogus\n",mem);
			DumpArea(th,sizeof(*th));

		}
		wasStomped = TRUE;
	}

	return(wasStomped);
}

/******************************************************************************/

APTR NewAllocMemAligned(ULONG	byteSize, ULONG attributes, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	/* no memory allocation routine may be called from supervisor mode */
	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		/* check if this allocation should be tracked */
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(NULL,pc,NULL,"AllocMemAligned(%ld,0x%08lx,%ld,%ld) called\n",byteSize,attributes,align,offset);
				hit = TRUE;
			}
			else
			{
				if(CANNOT PerformAllocationAligned(pc,NULL,byteSize,attributes, align, offset, ALLOCATIONTYPE_AllocMem,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(NULL,pc,NULL,"AllocMemAligned(%ld,0x%08lx,%ld,%ld) failed\n",byteSize,attributes,align,offset);
						hit = TRUE;
					}
				}
			}
		}
		else
		{
			result	= OldAllocMemAligned(SysBase, byteSize, attributes, align, offset);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(NULL,pc,NULL,"AllocMemAligned(%ld,0x%08lx,%ld,%ld) called from interrupt/exception\n",byteSize,attributes,align,offset);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

APTR NewAllocMem(ULONG	byteSize, ULONG attributes, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	/* no memory allocation routine may be called from supervisor mode */
	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		/* check if this allocation should be tracked */
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(stackFrame,pc,NULL,"AllocMem(%ld,0x%08lx) called\n",byteSize,attributes);
				hit = TRUE;
			}
			else
			{
				/* stackFrame[16] contains the return address of the caller */
#if TESTMODE
				DPrintf("%s: return 0x%lx\n",__func__,__builtin_return_address(0));
				DPrintf("%s: &result 0x%lx\n",__func__,&result);
				DPrintf("%s: *result 0x%lx\n",__func__,result);
#endif
				if(CANNOT PerformAllocation(pc,NULL,byteSize,attributes, ALLOCATIONTYPE_AllocMem,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,pc,NULL,"AllocMem(%ld,0x%08lx) failed\n",byteSize,attributes);
						hit = TRUE;
					}
				}
#if TESTMODE
				DPrintf("%s: ->&result 0x%lx\n",__func__,&result);
				DPrintf("%s: ->*result 0x%lx\n",__func__,result);
#endif
			}
		}
		else
		{
			result	= OldAllocMemAligned(SysBase, byteSize, attributes, 8, 0);
		}

#if TESTMODE

			if ((byteSize==0x18) || (byteSize==0x18798))
			{
				struct TrackHeader * th;

				DPrintf("%s: allocmem 0x%lx\n",__func__,result);

				{
					ULONG address;
					address = ((ULONG)result);
					DPrintf("%s: address 0x%lx preWallSize %ld sizeof(*th) %ld\n",__func__,address,PreWallSize,sizeof(*th));
					th = (struct TrackHeader *)(address - PreWallSize - sizeof(*th));
					DPrintf("%s: cond 0x%lx\n",__func__,
						(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent())));
					DPrintf("%s: calced th 0x%lx\n",__func__,th);
					DPrintf("%s: validtrackheader 0x%lx\n",__func__,IsValidTrackHeader(th));
					DPrintf("%s: chksumtrackheader 0x%lx\n",__func__,IsTrackHeaderChecksumCorrect(th));
				}
				DPrintf("%s: R1 0x%lx PPCLower 0x%lx PPCUpper 0x%lx\n",__func__,__builtin_frame_address(0),FindTask(NULL)->tc_ETask->PPCSPLower,FindTask(NULL)->tc_ETask->PPCSPUpper);
				if((th=IsTrackedAllocation(((ULONG)result))))
				{
					DPrintf("%s: tracked th 0x%lx\n",__func__,th);
					if(CheckStomping(stackFrame,pc,th))
					{
						if(IsActive)
						{
							VoiceComplaint(stackFrame,NULL,th,"AllocMem(0x%08lx): creation failed\n",result);
						}
					}
				}
				else
				{
					DPrintf("%s: no tracknode\n",__func__);
				}
			}


#endif

	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"AllocMem(%ld,0x%08lx) called from interrupt/exception\n",byteSize,attributes);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

#if TESTMODE
				DPrintf("%s: return 0x%lx\n",__func__,__builtin_return_address(0));
				DPrintf("%s: ->&result 0x%lx\n",__func__,&result);
				DPrintf("%s: ->*result 0x%lx\n",__func__,result);
#endif
	return(result);
}

VOID NewFreeMem(APTR	memoryBlock, ULONG byteSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(memoryBlock == NULL || byteSize == NULL)
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,NULL,"FreeMem(0x%08lx,%ld) called\n",memoryBlock,byteSize);
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
					VoiceComplaint(stackFrame,pc,NULL,"FreeMem(0x%08lx,%ld) on odd address\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* check if the address points into RAM */
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeMem(0x%08lx,%ld) on illegal address\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* check if the memory to free is really allocated */
			if(NOT IsAllocatedMemory((ULONG)memoryBlock,byteSize))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeMem(0x%08lx,%ld) not in allocated memory\n",memoryBlock,byteSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			/* now test whether the allocation was tracked by us */
			if((th=IsTrackedAllocation((ULONG)memoryBlock)))
			{
				/* check whether the allocation walls were trashed */
				if(CheckStomping(stackFrame,pc,th))
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
						VoiceComplaint(stackFrame,pc,th,"Free size %ld does not match allocation size %ld\n",byteSize,th->th_Size);
						hit = TRUE;
					}
	
					freeIt = FALSE;
				}
	
				if(th->th_Type != ALLOCATIONTYPE_AllocMem)
				{
					if(IsActive)
					{
						VoiceComplaint(stackFrame,pc,th,"In FreeMem(0x%08lx,%ld): Memory was not allocated with AllocMem()\n",memoryBlock,byteSize);
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
					REG_A1	= (ULONG)memoryBlock;
					REG_D0	= byteSize;
					REG_A6	= (ULONG)SysBase;
					MyEmulHandle->EmulCallDirect68k(OldFreeMem);
				}
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"FreeMem(0x%08lx,%ld) called from interrupt/exception\n",memoryBlock,byteSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR NewAllocVecAligned(ULONG	byteSize, ULONG attributes, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(NULL,pc,NULL,"AllocVecAligned(%ld,0x%08lx,%ld) called\n",byteSize,attributes,align,offset);
				hit = TRUE;
			}
			else
			{
				if(CANNOT PerformAllocationAligned(pc,NULL,byteSize,attributes,align,offset, ALLOCATIONTYPE_AllocVec,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(NULL,pc,NULL,"AllocVecAligned(%ld,0x%08lx,%ld,%ld) failed\n",byteSize,attributes,align,offset);
						hit = TRUE;
					}
				}
			}
		}
		else
		{
			result	= OldAllocVecAligned(SysBase, byteSize, attributes, align, offset);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(NULL,pc,NULL,"AllocVecAligned(%ld,0x%08lx,%ld,%ld) called from interrupt/exception\n",byteSize,attributes, align, offset);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

APTR NewAllocVec(ULONG	byteSize, ULONG attributes, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			if(byteSize == 0)
			{
				VoiceComplaint(stackFrame,pc,NULL,"AllocVec(%ld,0x%08lx) called\n",byteSize,attributes);
				hit = TRUE;
			}
			else
			{
				if(CANNOT PerformAllocation(pc,NULL,byteSize,attributes, ALLOCATIONTYPE_AllocVec,&result))
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,pc,NULL,"AllocVec(%ld,0x%08lx) failed\n",byteSize,attributes);
						hit = TRUE;
					}
				}
			}
		}
		else
		{
#if 1
			REG_D0	= byteSize;
			REG_D1	= attributes;
			REG_A6	= (ULONG)SysBase;
			result	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocVec);
#else
			result	= OldAllocVecAligned(SysBase, byteSize, attributes, 8, 0);
#endif
		}

#if TESTMODE

			if (byteSize==1572)
			{
				struct TrackHeader * th;

				DPrintf("%s: allocvec 0x%lx\n",__func__,result);

				{
					ULONG address;
					address = ((ULONG)result) - sizeof(ULONG);
					DPrintf("%s: address 0x%lx preWallSize %ld sizeof(*th) %ld\n",__func__,address,PreWallSize,sizeof(*th));
					th = (struct TrackHeader *)(address - PreWallSize - sizeof(*th));
					DPrintf("%s: cond 0x%lx\n",__func__,
						(byteSize <= 0x7FFFFFFF && IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent())));
					DPrintf("%s: calced th 0x%lx\n",__func__,th);
					DPrintf("%s: validtrackheader 0x%lx\n",__func__,IsValidTrackHeader(th));
					DPrintf("%s: chksumtrackheader 0x%lx\n",__func__,IsTrackHeaderChecksumCorrect(th));
				}
				if((th=IsTrackedAllocation(((ULONG)result) - sizeof(ULONG))))
				{
					DPrintf("%s: tracked th 0x%lx\n",__func__,th);
					if(CheckStomping(stackFrame,pc,th))
					{
						if(IsActive)
						{
							VoiceComplaint(stackFrame,NULL,th,"Allocvec(0x%08lx): creation failed\n",result);
						}
					}
				}
				else
				{
					DPrintf("%s: no tracknode\n",__func__);
				}
			}


#endif

	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"AllocVec(%ld,0x%08lx) called from interrupt/exception\n",byteSize,attributes);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID NewFreeVec(APTR memoryBlock, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
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
					VoiceComplaint(stackFrame,pc,NULL,"FreeVec(0x%08lx) on odd address\n",memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeVec(0x%08lx) on illegal address\n",memoryBlock);
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
					VoiceComplaint(stackFrame,pc,NULL,"FreeVec(0x%08lx) not in allocated memory\n",memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

#if TESTMODE
	{
		ULONG *Ptr;
		Ptr = (ULONG*)memoryBlock;
		if (Ptr[-1]==1576)
		{
			DPrintf("%s: freevec 0x%lx\n",__func__,Ptr);
			if((th=IsTrackedAllocation(((ULONG)memoryBlock) - sizeof(ULONG))))
			{
				DPrintf("%s: tracked th 0x%lx\n",__func__,th);
			}
			else
			{
				DPrintf("%s: no tracknode\n",__func__);
			}
		}
	}
#endif
			if((th=IsTrackedAllocation(((ULONG)memoryBlock) - sizeof(ULONG))))
			{
				if(CheckStomping(stackFrame,pc,th))
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
						VoiceComplaint(stackFrame,NULL,th,"In FreeVec(0x%08lx): Memory was not allocated with AllocVec()\n",memoryBlock);
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
					REG_A1	= (ULONG)memoryBlock;
					REG_a6	= (ULONG)SysBase;
					MyEmulHandle->EmulCallDirect68k(OldFreeVec);
				}
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"FreeVec(0x%08lx) called from interrupt/exception\n",memoryBlock);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR NewCreatePool(ULONG memFlags, ULONG puddleSize, ULONG threshSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	DEBUG_CREATEPOOL("%s: memFlags 0x%lx puddleSize 0x%lx threshSize 0x%lx\n",__func__,memFlags,puddleSize,threshSize);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if (IsActive && CanAllocate() && (NOT CheckConsistency || IsAllocationListConsistent()))
		{
			/* the puddle threshold size must not be larger
			 * than the puddle size
			 */
			if(threshSize <= puddleSize)
			{
				struct PoolHeader * ph;
		
				ph = CreatePoolHeader(memFlags,puddleSize,threshSize,pc);
				DEBUG_CREATEPOOL("%s: ph 0x%lx\n",__func__,ph);
				if(ph != NULL)
				{
					result = ph->ph_PoolHeader;
				}
				else
				{
					if(ShowFail)
					{
						VoiceComplaint(stackFrame,pc,NULL,"CreatePool(0x%08lx,%ld,%ld) failed\n",memFlags,puddleSize,threshSize);
						hit = TRUE;
					}
				}
			}
			else
			{
				VoiceComplaint(stackFrame,pc,NULL,"Threshold size %ld must be <= puddle size %ld\n",threshSize,puddleSize);
				hit = TRUE;
			}
		}
		else
		{
			DEBUG_CREATEPOOL("%s: don't handle pool, call old routine\n",__func__);
			REG_D0	= memFlags;
			REG_D1	= puddleSize;
			REG_D2	= threshSize;
			REG_A6	= (ULONG)SysBase;
			result	= (APTR)MyEmulHandle->EmulCallDirect68k(OldCreatePool);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"CreatePool(0x%08lx,%ld,%ld) called from interrupt/exception\n",memFlags,puddleSize,threshSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	DEBUG_CREATEPOOL("%s: poolHeader 0x%lx\n",__func__,result);
	return(result);
}

VOID NewDeletePool(APTR poolHeader, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	DEBUG_DELETEPOOL("%s: poolHeader 0x%lx\n",__func__,poolHeader);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(poolHeader != NULL)
		{
			struct PoolHeader * ph;
	
			ph = FindPoolHeader(poolHeader);
			DEBUG_DELETEPOOL("%s: ph 0x%lx\n",__func__,ph);
			if(ph != NULL)
			{
				BOOL freeIt = TRUE;

				/* check whether the memory list is consistent */
				if(CheckConsistency && NOT IsPuddleListConsistent(ph))
				{
					freeIt = FALSE;
				}

				DEBUG_DELETEPOOL("%s: freeIt %ld\n",__func__,freeIt);
				/* note that DeletePoolHeader() implies
				 * HoldPoolSemaphore()..ReleasePoolSemaphore()
				 */
				if(freeIt && CANNOT DeletePoolHeader(stackFrame,ph,pc))
				{
					DEBUG_DELETEPOOL("%s: couldn't delete ph\n",__func__);
					if(IsActive)
					{
						hit = TRUE;
					}
				}
			}
			else
			{
				DEBUG_DELETEPOOL("%s: don't handle pool, call old routine\n",__func__);
				REG_A0	= (ULONG)poolHeader;
				REG_A6	= (ULONG)SysBase;
				MyEmulHandle->EmulCallDirect68k(OldDeletePool);
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,NULL,"DeletePool(NULL) called\n");
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"DeletePool(0x%08lx) called from interrupt/exception\n",poolHeader);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

VOID NewFlushPool(APTR poolHeader, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	DEBUG_FLUSHPOOL("%s: poolHeader 0x%lx\n",__func__,poolHeader);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(poolHeader != NULL)
		{
			struct PoolHeader * ph;
	
			ph = FindPoolHeader(poolHeader);
			DEBUG_FLUSHPOOL("%s: ph 0x%lx\n",__func__,ph);
			if(ph != NULL)
			{
				BOOL freeIt = TRUE;

				/* check whether the memory list is consistent */
				if(CheckConsistency && NOT IsPuddleListConsistent(ph))
				{
					freeIt = FALSE;
				}

				DEBUG_FLUSHPOOL("%s: freeIt %ld\n",__func__,freeIt);
				/* note that FlushPoolHeader() implies
				 * HoldPoolSemaphore()..ReleasePoolSemaphore()
				 */
				if(freeIt && CANNOT FlushPoolHeader(stackFrame,ph,pc))
				{
					DEBUG_FLUSHPOOL("%s: couldn't flush ph\n",__func__);
					if(IsActive)
					{
						hit = TRUE;
					}
				}
			}
			else
			{
				DEBUG_FLUSHPOOL("%s: don't handle pool, call old routine\n",__func__);
				REG_A0	= (ULONG)poolHeader;
				REG_A6	= (ULONG)SysBase;
				MyEmulHandle->EmulCallDirect68k(OldFlushPool);
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,NULL,"FlushPool(NULL) called\n");
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"FlushPool(0x%08lx) called from interrupt/exception\n",poolHeader);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR NewAllocPooledAligned(APTR poolHeader, ULONG memSize, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	DEBUG_ALLOCPOOLALIGN("%s: poolHeader 0x%lx memSize 0x%lx align 0x%lx offset 0x%lx\n",__func__,poolHeader,memSize,align,offset);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(memSize <= 0x7FFFFFFF && IsActive && CanAllocate())
		{
			if(poolHeader != NULL && memSize > 0)
			{
				struct PoolHeader * ph;

				/* check whether this memory pool is being tracked */
				ph = FindPoolHeader(poolHeader);
				DEBUG_ALLOCPOOLALIGN("%s: ph 0x%lx\n",__func__,ph);
				if(ph != NULL)
				{
					BOOL allocateIt = TRUE;

					if(CheckConsistency && NOT IsPuddleListConsistent(ph))
					{
						allocateIt = FALSE;
					}

					DEBUG_ALLOCPOOLALIGN("%s: allocateIt %ld\n",__func__,allocateIt);

					if(allocateIt)
					{
						HoldPoolSemaphore(ph, pc);
	
						if(CANNOT PerformAllocationAligned(pc,ph,memSize,ph->ph_Attributes, align, offset, ALLOCATIONTYPE_AllocPooled,&result))
						{
							if(ShowFail)
							{
								VoiceComplaint(NULL,pc, NULL,"AllocPooledAligned(0x%08lx,%ld,%ld,%ld) failed\n",poolHeader,memSize, align, offset);
								hit = TRUE;
							}
						}
	
						ReleasePoolSemaphore(ph);
					}
				}
				else
				{
					result	= OldAllocPooledAligned(SysBase, poolHeader, memSize, align, offset);
				}
			}
			else
			{
				VoiceComplaint(NULL,pc, NULL, "AllocPooledAligned(0x%08lx,%ld,%ld,%ld) called\n",poolHeader,memSize, align, offset);
				hit = TRUE;
			}
		}
		else
		{
			result	= OldAllocPooledAligned(SysBase, poolHeader, memSize, align, offset);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(NULL,pc, NULL,"AllocPooledAligned(0x%08lx,%ld,%ld,%ld) called from interrupt/exception\n",poolHeader,memSize, align, offset);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	DEBUG_ALLOCPOOLALIGN("%s: result 0x%lx\n",__func__,result);

	return(result);
}

APTR NewAllocPooled(APTR poolHeader, ULONG memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	DEBUG_ALLOCPOOL("%s: poolHeader 0x%lx memSize 0x%lx\n",__func__,poolHeader,memSize);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(memSize <= 0x7FFFFFFF && IsActive && CanAllocate())
		{
			if(poolHeader != NULL && memSize > 0)
			{
				struct PoolHeader * ph;

				/* check whether this memory pool is being tracked */
				ph = FindPoolHeader(poolHeader);
				DEBUG_ALLOCPOOL("%s: ph 0x%lx\n",__func__,ph);
				if(ph != NULL)
				{
					BOOL allocateIt = TRUE;

					if(CheckConsistency && NOT IsPuddleListConsistent(ph))
					{
						allocateIt = FALSE;
					}

					DEBUG_ALLOCPOOL("%s: allocateIt %ld\n",__func__,allocateIt);

					if(allocateIt)
					{
						HoldPoolSemaphore(ph,pc);
	
						if(CANNOT PerformAllocation(pc,ph,memSize,ph->ph_Attributes, ALLOCATIONTYPE_AllocPooled,&result))
						{
							if(ShowFail)
							{
								VoiceComplaint(stackFrame,pc,NULL,"AllocPooled(0x%08lx,%ld) failed\n",poolHeader,memSize);
								hit = TRUE;
							}
						}
	
						ReleasePoolSemaphore(ph);
					}
				}
				else
				{
#if 1
					REG_A0	=(ULONG) poolHeader;
					REG_D0	= memSize;
					REG_A6	= (ULONG)SysBase;
					result	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocPooled);
#else
					result	= OldAllocPooledAligned(SysBase, poolHeader, memSize, 8, 0);
#endif
				}
			}
			else
			{
				VoiceComplaint(stackFrame,pc,NULL,"AllocPooled(0x%08lx,%ld) called\n",poolHeader,memSize);
				hit = TRUE;
			}
		}
		else
		{
			result	= OldAllocPooledAligned(SysBase, poolHeader, memSize, 8, 0);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"AllocPooled(0x%08lx,%ld) called from interrupt/exception\n",poolHeader,memSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	DEBUG_ALLOCPOOL("%s: result 0x%lx\n",__func__,result);

	return(result);
}

VOID NewFreePooled(APTR	poolHeader, APTR memoryBlock, ULONG	memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	DEBUG_FREEPOOL("%s: poolHeader 0x%lx memoryBlock 0x%lx memSize 0x%lx\n",__func__,poolHeader,memoryBlock,memSize);

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(poolHeader != NULL && memoryBlock != NULL && memSize > 0)
		{
			struct PoolHeader * ph;
			BOOL freeIt = TRUE;
	
			if(IsOddAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) on odd address\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) on illegal address\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(NOT IsAllocatedMemory((ULONG)memoryBlock,memSize))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) not in allocated memory\n",poolHeader,memoryBlock,memSize);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}

			ph = FindPoolHeader(poolHeader);

			DEBUG_FREEPOOL("%s: ph 0x%lx\n",__func__,ph);

			if(ph != NULL)
			{
				if(CheckConsistency && NOT IsPuddleListConsistent(ph))
				{
					freeIt = FALSE;
				}

				DEBUG_FREEPOOL("%s: freeIt %ld\n",__func__,freeIt);

				if(freeIt)
				{
					struct TrackHeader * th;
	
					HoldPoolSemaphore(ph,pc);
	
					if(NOT PuddleIsInPool(ph,memoryBlock))
					{
						DEBUG_FREEPOOL("%s: Puddle is not in pool\n",__func__);

						if(IsActive)
						{
							VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) not in pool\n",poolHeader,memoryBlock,memSize);
							DumpPoolOwner(ph);
	
							hit = TRUE;
						}
			
						freeIt = FALSE;
					}
	
					if((th=IsTrackedAllocation((ULONG)memoryBlock)))
					{
						DEBUG_FREEPOOL("%s: th 0x%lx\n",__func__,th);
						if(CheckStomping(stackFrame,pc,th))
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
								VoiceComplaint(stackFrame,NULL,th,"Free size %ld does not match allocation size %ld\n",memSize,th->th_Size);
								hit = TRUE;
							}
		
							freeIt = FALSE;
						}
		
						if(th->th_PoolHeader->ph_PoolHeader != poolHeader)
						{
							if(IsActive)
							{
								struct PoolHeader * ph;
	
								VoiceComplaint(stackFrame,NULL,th,"FreePooled(0x%08lx,0x%08lx,%ld) called on puddle in wrong pool (right=0x%08lx wrong=0x%08lx)\n",poolHeader,memoryBlock,memSize,th->th_PoolHeader->ph_PoolHeader,poolHeader);
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
								VoiceComplaint(stackFrame,NULL,th,"In FreePooled(0x%08lx,0x%08lx,%ld): Memory was not allocated with AllocPooled()\n",poolHeader,memoryBlock,memSize);
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
						DEBUG_FREEPOOL("%s: no th\n",__func__);
						if(IsActive)
						{
							VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called on puddle that is not in pool\n",poolHeader,memoryBlock,memSize);
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
					REG_A0	= (ULONG)poolHeader;
					REG_A1	= (ULONG)memoryBlock;
					REG_D0	= memSize;
					REG_A6	= (ULONG)SysBase;
					MyEmulHandle->EmulCallDirect68k(OldFreePooled);
				}
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called\n",poolHeader,memoryBlock,memSize);
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"FreePooled(0x%08lx,0x%08lx,%ld) called from interrupt/exception\n",poolHeader,memoryBlock,memSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}

/******************************************************************************/

APTR NewAllocVecPooled(APTR poolHeader, ULONG memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	APTR result = NULL;
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
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
						HoldPoolSemaphore(ph,pc);
	
						if(CANNOT PerformAllocation(pc,ph,memSize,ph->ph_Attributes, ALLOCATIONTYPE_AllocVecPooled,&result))
						{
							if(ShowFail)
							{
								VoiceComplaint(stackFrame,pc,NULL,"AllocVecPooled(0x%08lx,%ld) failed\n",poolHeader,memSize);
								hit = TRUE;
							}
						}
	
						ReleasePoolSemaphore(ph);
					}
				}
				else
				{
					REG_A0	= (ULONG)poolHeader;
					REG_D0	= memSize;
					REG_A6	= (ULONG)SysBase;
					result	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocVecPooled);
				}
			}
			else
			{
				VoiceComplaint(stackFrame,pc,NULL,"AllocVecPooled(0x%08lx,%ld) called\n",poolHeader,memSize);
				hit = TRUE;
			}
		}
		else
		{
			REG_A0	= (ULONG)poolHeader;
			REG_D0	= memSize;
			REG_A6	= (ULONG)SysBase;
			result	= (APTR)MyEmulHandle->EmulCallDirect68k(OldAllocVecPooled);
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"AllocVecPooled(0x%08lx,%ld) called from interrupt/exception\n",poolHeader,memSize);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}

	return(result);
}

VOID NewFreeVecPooled(APTR	poolHeader, APTR memoryBlock, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE])
{
	BOOL hit = FALSE;

	if(NOT CALLEDFROMSUPERVISORMODE())
	{
		if(poolHeader != NULL && memoryBlock != NULL)
		{
			struct PoolHeader * ph;
			BOOL freeIt = TRUE;
	
			if(IsOddAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) on odd address\n",poolHeader,memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(IsInvalidAddress((ULONG)memoryBlock))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) on illegal address\n",poolHeader,memoryBlock);
					hit = TRUE;
				}
	
				freeIt = FALSE;
			}
	
			if(NOT IsAllocatedMemory(((ULONG)memoryBlock)-4,(*(ULONG *)(((ULONG)memoryBlock)-4))))
			{
				if(IsActive)
				{
					VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) not in allocated memory\n",poolHeader,memoryBlock);
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
	
					HoldPoolSemaphore(ph,pc);
	
					if(NOT PuddleIsInPool(ph,(void*) ((ULONG)memoryBlock) - sizeof(ULONG)))
					{
						if(IsActive)
						{
							VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) not in pool\n",poolHeader,memoryBlock);
							DumpPoolOwner(ph);
	
							hit = TRUE;
						}
			
						freeIt = FALSE;
					}
	
					if((th=IsTrackedAllocation((ULONG)memoryBlock - sizeof(ULONG))))
					{
						if(CheckStomping(stackFrame,pc,th))
						{
							freeIt = FALSE;
	
							if(IsActive)
							{
								hit = TRUE;
							}
						}
			
						if(th->th_PoolHeader->ph_PoolHeader != poolHeader)
						{
							if(IsActive)
							{
								struct PoolHeader * ph;
	
								VoiceComplaint(stackFrame,NULL,th,"FreeVecPooled(0x%08lx,0x%08lx) called on puddle in wrong pool (right=0x%08lx wrong=0x%08lx)\n",poolHeader,memoryBlock,th->th_PoolHeader->ph_PoolHeader,poolHeader);
								hit = TRUE;
	
								DumpPoolOwner(th->th_PoolHeader);
	
								ph = FindPoolHeader(poolHeader);
								if(ph != NULL)
									DumpPoolOwner(ph);
							}
		
							freeIt = FALSE;
						}
		
						if(th->th_Type != ALLOCATIONTYPE_AllocVecPooled)
						{
							if(IsActive)
							{
								VoiceComplaint(stackFrame,NULL,th,"In FreeVecPooled(0x%08lx,0x%08lx,%ld): Memory was not allocated with AllocVecPooled()\n",poolHeader,memoryBlock);
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
							VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) called on puddle that is not in pool\n",poolHeader,memoryBlock);
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
					REG_A0	= (ULONG)poolHeader;
					REG_A1	= (ULONG)memoryBlock;
					REG_A6	= (ULONG)SysBase;
					MyEmulHandle->EmulCallDirect68k(OldFreeVecPooled);
				}
			}
		}
		else
		{
			if(IsActive)
			{
				VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) called\n",poolHeader,memoryBlock);
				hit = TRUE;
			}
		}
	}
	else
	{
		if(IsActive)
		{
			VoiceComplaint(stackFrame,pc,NULL,"FreeVecPooled(0x%08lx,0x%08lx) called from interrupt/exception\n",poolHeader,memoryBlock);
		}
	}

	if(hit && WaitAfterHit)
	{
		WaitForBreak();
	}
}
