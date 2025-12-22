
#include "tek/mem.h"
#include "tek/kn/exec.h"
#include "tek/msg.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TInitMMU(TMMU *mmu, TAPTR allocator, TUINT mmutype, TTAGITEM *tags)
**
**	initialize a memory management unit.
**
**	TODO:	- change interface to using taglists
**
*/

static TINT mmudestroyfunc(TMMU *mmu);

static TAPTR voidalloc(TAPTR x, TUINT size);
static TAPTR voidrealloc(TAPTR x, TAPTR oldmem, TUINT newsize);
static TVOID voidfree(TAPTR x, TAPTR mem);
static TUINT voidgetsize(TAPTR x, TAPTR mem);

static TAPTR mmu_kernelalloc(TAPTR userdata, TUINT size);
static TVOID mmu_kernelfree(TAPTR mmu, TAPTR mem);
static TAPTR mmu_kernelrealloc(TAPTR userdata, TAPTR oldmem, TUINT newsize);
static TUINT mmu_kernelgetsize(TAPTR userdata, TAPTR mem);

static TAPTR mmu_trackalloc(TMMU *mmu, TUINT size);
static TAPTR mmu_trackrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize);
static TVOID mmu_trackfree(TMMU *mmu, TBYTE *mem);
static TUINT mmu_trackgetsize(TMMU *mmu, TBYTE *mem);
static TINT mmu_trackdestroy(TMMU *mmu);

static TAPTR mmu_taskalloc(TMMU *mmu, TUINT size);
static TAPTR mmu_taskrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize);
static TVOID mmu_taskfree(TMMU *mmu, TBYTE *mem);
static TUINT mmu_taskgetsize(TMMU *mmu, TBYTE *mem);
static TINT mmu_taskdestroy(TMMU *mmu);

static TAPTR mmu_tasktrackalloc(TMMU *mmu, TUINT size);
static TAPTR mmu_tasktrackrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize);
static TVOID mmu_tasktrackfree(TMMU *mmu, TBYTE *mem);
static TUINT mmu_tasktrackgetsize(TMMU *mmu, TBYTE *mem);
static TINT mmu_tasktrackdestroy(TMMU *mmu);

static TAPTR pooltaskalloc(TMMU *mmu, TUINT size);
static TAPTR pooltaskrealloc(TMMU *mmu, TAPTR oldmem, TUINT newsize);
static TVOID pooltaskfree(TMMU *mmu, TAPTR mem);
static TUINT pooltaskgetsize(TMMU *mmu, TAPTR mem);
static TINT pooltaskdestroy(TMMU *mmu);

static TAPTR msgpooltaskalloc(TMMU *mmu, TUINT size);
static TAPTR msgpooltaskrealloc(TMMU *mmu, TAPTR oldmem, TUINT newsize);
static TVOID msgpooltaskfree(TMMU *mmu, TAPTR mem);
static TUINT msgpooltaskgetsize(TMMU *mmu, TAPTR mem);
static TINT msgpooltaskdestroy(TMMU *mmu);


TBOOL TInitMMU(TMMU *mmu, TAPTR allocator, TUINT mmutype, TTAGITEM *tags)
{
	if (mmu)
	{
		kn_memset(mmu, sizeof(TMMU), 0);
		mmu->handle.destroyfunc = (TDESTROYFUNC) mmudestroyfunc;

		switch (mmutype)
		{
			case TMMUT_Kernel:
	
				if (!allocator)
				{
					/*	kernel allocator MMU */

					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) mmu_kernelalloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) mmu_kernelfree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) mmu_kernelrealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) mmu_kernelgetsize;
					mmu->type = mmutype;
					return TTRUE;
				}
				break;
	
			case TMMUT_Static:
			
				if (allocator)
				{
					/*	static allocator MMU */

					mmu->allocator = allocator;
					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) TStaticAlloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) TStaticFree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) TStaticRealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) TStaticGetSize;
					mmu->type = mmutype;
					return TTRUE;
				}
				break;
	
			case TMMUT_Pooled:
			
				if (allocator)
				{
					/*	pool allocator MMU */

					mmu->allocator = allocator;
					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) TPoolAlloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) TPoolFree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) TPoolRealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) TPoolGetSize;
					mmu->type = mmutype;
					return TTRUE;
				}
				break;
	
			case TMMUT_MMU:
			
				if (allocator)
				{
					/*	MMU-via-MMU allocator, implementing no additional functionality. */

					mmu->allocator = allocator;
					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) TMMUAlloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) TMMUFree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) TMMURealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) TMMUGetSize;
					mmu->type = mmutype;
					return TTRUE;
				}
				else
				{
					/*	MMU-via-NULL-MMU allocator. valid, because a NULL MMU is defined to be a kernel allocator */

					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) mmu_kernelalloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) mmu_kernelfree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) mmu_kernelrealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) mmu_kernelgetsize;
					mmu->type = mmutype;
					return TTRUE;
				}
			
			case TMMUT_Tracking:
	
				/*	memory-tracking allocator on top of a MMU. */
	
				TInitList(&mmu->tracklist);
				mmu->allocator = mmu;
				mmu->suballocator = allocator;
				mmu->destroymmufunc = (TDESTROYFUNC) mmu_trackdestroy;
				mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) mmu_trackalloc;
				mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) mmu_trackfree;
				mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) mmu_trackrealloc;
				mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) mmu_trackgetsize;
				mmu->type = mmutype;
				return TTRUE;				


			case TMMUT_TaskSafe:
	
				/*	task-safe allocator on top of a MMU. */
	
				if (kn_initlock(&mmu->tasklock))
				{
					mmu->allocator = mmu;
					mmu->suballocator = allocator;
					mmu->destroymmufunc = (TDESTROYFUNC) mmu_taskdestroy;
					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) mmu_taskalloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) mmu_taskfree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) mmu_taskrealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) mmu_taskgetsize;
					mmu->type = mmutype;
					return TTRUE;
				}
				break;

			case TMMUT_TaskSafe+TMMUT_Tracking:
	
				/*	tasksafe plus memory-tracking allocator on top of a MMU. */

				if (kn_initlock(&mmu->tasklock))
				{			
					TInitList(&mmu->tracklist);
					mmu->allocator = mmu;
					mmu->suballocator = allocator;
					mmu->destroymmufunc = (TDESTROYFUNC) mmu_tasktrackdestroy;
					mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) mmu_tasktrackalloc;
					mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) mmu_tasktrackfree;
					mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) mmu_tasktrackrealloc;
					mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) mmu_tasktrackgetsize;
					mmu->type = mmutype;
					return TTRUE;
				}
				break;

			case TMMUT_TaskSafe+TMMUT_Pooled:
			
				/* tasksafe allocator on top of a pool */

				if (allocator)
				{
					if (kn_initlock(&mmu->tasklock))
					{
						mmu->allocator = mmu;
						mmu->suballocator = allocator;
						mmu->destroymmufunc = (TDESTROYFUNC) pooltaskdestroy;
						mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) pooltaskalloc;
						mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) pooltaskfree;
						mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) pooltaskrealloc;
						mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) pooltaskgetsize;
						mmu->type = mmutype;
						return TTRUE;
					}
				}
				break;

			case TMMUT_Message:
			{
				TBOOL okay = TTRUE;
			
				/* message allocator. currently this will be a tasksafe pooled allocator
				** on top of either a NULL MMU, or on top of another MMU which must be of
				** type TMMUT_Message as well */

				if (allocator)
				{
					okay = (((TMMU *) allocator)->type == TMMUT_Message);
				}
				
				if (okay)
				{
					if (kn_initlock(&mmu->tasklock))
					{
						mmu->userdata = TCreatePool(allocator, 256, 128, TNULL);
						if (mmu->userdata)
						{
							mmu->allocator = mmu;
							mmu->suballocator = allocator;
							mmu->destroymmufunc = (TDESTROYFUNC) msgpooltaskdestroy;
							mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) msgpooltaskalloc;
							mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) msgpooltaskfree;
							mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) msgpooltaskrealloc;
							mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) msgpooltaskgetsize;
							mmu->type = mmutype;
							return TTRUE;
						}
						kn_destroylock(&mmu->tasklock);
					}
				}
				break;
			}

			default:
				break;
		}

		/*
		**	as a fallback, initialize a void MMU that is incapable of allocating.
		**	this allows usage of an MMU without checking the return value of
		**	TInitMMU().
		*/

		mmu->allocfunc = (TAPTR (*)(TAPTR, TUINT)) voidalloc;
		mmu->freefunc = (TVOID (*)(TAPTR, TAPTR)) voidfree;
		mmu->reallocfunc = (TAPTR (*)(TAPTR, TAPTR, TUINT)) voidrealloc;
		mmu->getsizefunc = (TUINT (*)(TAPTR, TAPTR)) voidgetsize;
		mmu->type = TMMUT_Void;
	}

	return TFALSE;
}


/**************************************************************************
**	void allocator
**************************************************************************/

static TAPTR voidalloc(TAPTR x, TUINT size)
{
	return TNULL;
}

static TAPTR voidrealloc(TAPTR x, TAPTR oldmem, TUINT newsize)
{
	return TNULL;
}	

static TVOID voidfree(TAPTR x, TAPTR mem)
{
}

static TUINT voidgetsize(TAPTR x, TAPTR mem)
{
	return 0;
}


/**************************************************************************
**	kernel allocator
**************************************************************************/

static TAPTR mmu_kernelalloc(TAPTR allocator, TUINT size)
{
	return kn_alloc(size);
}

static TVOID mmu_kernelfree(TAPTR allocator, TAPTR mem)
{
	kn_free(mem);
}

static TAPTR mmu_kernelrealloc(TAPTR allocator, TAPTR oldmem, TUINT newsize)
{
	return kn_realloc(oldmem, newsize);
}

static TUINT mmu_kernelgetsize(TAPTR allocator, TAPTR mem)
{
	return kn_getsize(mem);
}



/**************************************************************************
**	tracking MMU allocator
**************************************************************************/

static TAPTR mmu_trackalloc(TMMU *mmu, TUINT size)
{
	TBYTE *mem = TMMUAlloc(mmu->suballocator, size + sizeof(TNODE));
	if (mem)
	{
		TAddTail(&mmu->tracklist, (TNODE *) mem);
		return (TAPTR) (mem + sizeof(TNODE));
	}
	return TNULL;
}

static TAPTR mmu_trackrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize)
{
	TBYTE *newmem;

	if (oldmem)
	{
		TRemove((TNODE *) (oldmem - sizeof(TNODE)));
		newmem = TMMURealloc(mmu->suballocator, oldmem - sizeof(TNODE), newsize + sizeof(TNODE));
	}
	else
	{
		newmem = TMMUAlloc(mmu->suballocator, newsize + sizeof(TNODE));
	}

	if (newmem)
	{
		TAddTail(&mmu->tracklist, (TNODE *) newmem);
		return (TAPTR) (newmem + sizeof(TNODE));
	}
	
	return TNULL;
}	

static TVOID mmu_trackfree(TMMU *mmu, TBYTE *mem)
{
	TRemove((TNODE *) (mem - sizeof(TNODE)));
	TMMUFree(mmu->suballocator, mem - sizeof(TNODE));
}

static TUINT mmu_trackgetsize(TMMU *mmu, TBYTE *mem)
{
	return TMMUGetSize(mmu->suballocator, mem - sizeof(TNODE));
}

static TINT mmu_trackdestroy(TMMU *mmu)
{
	TNODE *nextnode, *node = mmu->tracklist.head;
	TINT numfreed = 0;
	
	while ((nextnode = node->succ))
	{
		TMMUFree(mmu->suballocator, node);
		numfreed++;
		node = nextnode;
	}

	if (numfreed) tdbprintf1(5, "*** mmu_trackdestroy: %d allocations pending\n", numfreed);
	return numfreed;
}


/**************************************************************************
**	tasksafe MMU allocator
**************************************************************************/

static TAPTR mmu_taskalloc(TMMU *mmu, TUINT size)
{
	TBYTE *mem;
	kn_lock(&mmu->tasklock);
	mem = TMMUAlloc(mmu->suballocator, size);
	kn_unlock(&mmu->tasklock);
	return mem;
}

static TAPTR mmu_taskrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize)
{
	TBYTE *newmem;
	kn_lock(&mmu->tasklock);
	newmem = TMMURealloc(mmu->suballocator, oldmem, newsize);
	kn_unlock(&mmu->tasklock);
	return newmem;
}	

static TVOID mmu_taskfree(TMMU *mmu, TBYTE *mem)
{
	kn_lock(&mmu->tasklock);
	TMMUFree(mmu->suballocator, mem);
	kn_unlock(&mmu->tasklock);
}

static TUINT mmu_taskgetsize(TMMU *mmu, TBYTE *mem)
{
	TUINT size;
	kn_lock(&mmu->tasklock);
	size = TMMUGetSize(mmu->suballocator, mem);
	kn_unlock(&mmu->tasklock);
	return size;
}

static TINT mmu_taskdestroy(TMMU *mmu)
{
	kn_destroylock(&mmu->tasklock);
	return 0;
}



/**************************************************************************
**	tasksafe+tracking MMU allocator
**************************************************************************/

static TAPTR mmu_tasktrackalloc(TMMU *mmu, TUINT size)
{
	TBYTE *mem;
	kn_lock(&mmu->tasklock);	
	mem = TMMUAlloc(mmu->suballocator, size + sizeof(TNODE));
	if (mem)
	{
		TAddTail(&mmu->tracklist, (TNODE *) mem);
		kn_unlock(&mmu->tasklock);	
		return (TAPTR) (mem + sizeof(TNODE));
	}
	kn_unlock(&mmu->tasklock);	
	return TNULL;
}

static TAPTR mmu_tasktrackrealloc(TMMU *mmu, TBYTE *oldmem, TUINT newsize)
{
	TBYTE *newmem;
	kn_lock(&mmu->tasklock);	
	if (oldmem)
	{
		TRemove((TNODE *) (oldmem - sizeof(TNODE)));
		newmem = TMMURealloc(mmu->suballocator, oldmem - sizeof(TNODE), newsize + sizeof(TNODE));
	}
	else
	{
		newmem = TMMUAlloc(mmu->suballocator, newsize + sizeof(TNODE));
	}

	if (newmem)
	{
		TAddTail(&mmu->tracklist, (TNODE *) newmem);
		kn_unlock(&mmu->tasklock);	
		return (TAPTR) (newmem + sizeof(TNODE));
	}
	
	kn_unlock(&mmu->tasklock);	
	return TNULL;
}	

static TVOID mmu_tasktrackfree(TMMU *mmu, TBYTE *mem)
{
	kn_lock(&mmu->tasklock);	
	TRemove((TNODE *) (mem - sizeof(TNODE)));
	TMMUFree(mmu->suballocator, mem - sizeof(TNODE));
	kn_unlock(&mmu->tasklock);	
}

static TUINT mmu_tasktrackgetsize(TMMU *mmu, TBYTE *mem)
{
	TUINT size;
	kn_lock(&mmu->tasklock);	
	size = TMMUGetSize(mmu->suballocator, mem - sizeof(TNODE)) - sizeof(TNODE);
	kn_unlock(&mmu->tasklock);	
	return size;
}

static TINT mmu_tasktrackdestroy(TMMU *mmu)
{
	TNODE *nextnode, *node = mmu->tracklist.head;
	TINT numfreed = 0;
	
	while ((nextnode = node->succ))
	{
		TMMUFree(mmu->suballocator, node);
		numfreed++;
		node = nextnode;
	}

	kn_destroylock(&mmu->tasklock);

	if (numfreed) tdbprintf1(5, "*** mmu_tasktrackdestroy: %d allocations pending\n", numfreed);

	return numfreed;
}



/**************************************************************************
**	tasksafe allocator on top of a pool
**************************************************************************/

static TAPTR pooltaskalloc(TMMU *mmu, TUINT size)
{
	TBYTE *mem;
	kn_lock(&mmu->tasklock);
	mem = TPoolAlloc(mmu->suballocator, size);
	kn_unlock(&mmu->tasklock);
	return mem;
}

static TAPTR pooltaskrealloc(TMMU *mmu, TAPTR oldmem, TUINT newsize)
{
	TBYTE *newmem;
	kn_lock(&mmu->tasklock);
	newmem = TPoolRealloc(mmu->suballocator, oldmem, newsize);
	kn_unlock(&mmu->tasklock);
	return newmem;
}	

static TVOID pooltaskfree(TMMU *mmu, TAPTR mem)
{
	kn_lock(&mmu->tasklock);
	TPoolFree(mmu->suballocator, mem);
	kn_unlock(&mmu->tasklock);
}

static TUINT pooltaskgetsize(TMMU *mmu, TAPTR mem)
{
	TUINT size;
	kn_lock(&mmu->tasklock);
	size = TPoolGetSize(mmu->suballocator, mem);
	kn_unlock(&mmu->tasklock);
	return size;
}

static TINT pooltaskdestroy(TMMU *mmu)
{
	kn_destroylock(&mmu->tasklock);
	return 0;
}



/**************************************************************************
**	msg allocator
**************************************************************************/

static TAPTR msgpooltaskalloc(TMMU *mmu, TUINT size)
{
	TMSG *msg;
	kn_lock(&mmu->tasklock);
	msg = TPoolAlloc(mmu->userdata, size + sizeof(TMSG));
	kn_unlock(&mmu->tasklock);
	if (msg)
	{
		msg->handle.destroyfunc = (TDESTROYFUNC) TNULL;
		msg->handle.mmu = mmu;
		msg->size = size + sizeof(TMSG);
		msg->status = TMSG_STATUS_UNDEFINED;
		return (TAPTR) (msg + 1);
	}
	return TNULL;
}

static TAPTR msgpooltaskrealloc(TMMU *mmu, TAPTR oldmem, TUINT newsize)
{
	/*
	**	messages cannot be reallocated.
	*/

	if (oldmem)
	{
		TMSG *oldmsg = ((TMSG *) oldmem) - 1;

		if (newsize == 0)
		{
			kn_lock(&mmu->tasklock);
			TPoolFree(mmu->userdata, (TAPTR) oldmsg);
			kn_unlock(&mmu->tasklock);
		}
		else
		{
			if (newsize + sizeof(TMSG) == oldmsg->size)
			{
				return oldmem;
			}
		}
	}
	
	return TNULL;
}	

static TVOID msgpooltaskfree(TMMU *mmu, TAPTR mem)
{
	if (mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;
		kn_lock(&mmu->tasklock);
		TPoolFree(mmu->userdata, (TAPTR) msg);

		kn_unlock(&mmu->tasklock);
	}
}

static TUINT msgpooltaskgetsize(TMMU *mmu, TAPTR mem)
{
	if (mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;
		return msg->size - sizeof(TMSG);
	}
	return 0;
}

static TINT msgpooltaskdestroy(TMMU *mmu)
{
	TDestroy(mmu->userdata);
	kn_destroylock(&mmu->tasklock);
	return 0;
}



/**************************************************************************
**
**	generic mmu destroy function
**
**	needs to be overwritten if a MMU was not initialized in place,
**	but created with TMMUAllocHandle(), or when an underlying allocator
**	is attached to and needs to be destroyed with the MMU.
**
**************************************************************************/

static TINT mmudestroyfunc(TMMU *mmu)
{
	if (mmu->destroymmufunc)
	{
		(*mmu->destroymmufunc)(mmu);
	}
	return 0;
}




#if 0

/**************************************************************************
**
**	beispiel für eine MMU mit zugrundeliegendem allocator,
**	die als ganzes per TMMUAllocHandle() erzeugt und per
**	TDestroy() zerstört wird
**
**************************************************************************/

static TINT destroycreatedmmu(TMMU *mmu)
{
	if (mmu->destroymmufunc)
	{
		(*mmu->destroymmufunc)(mmu);
	}
	
	if (mmu->destroyallocatorfunc)
	{
		if (mmu->suballocator && mmu->allocator == mmu)
		{
			(*mmu->destroyallocatorfunc)(mmu->suballocator);
		}
		else if (mmu->allocator)
		{
			(*mmu->destroyallocatorfunc)(mmu->allocator);
		}
	}

	TMMUFreeHandle(mmu);
	return 0;
}

TMMU *createpoolmmu(TMMU *parentmmu)
{
	TMMU *mmu = TMMUAllocHandle(parentmmu, TNULL, sizeof(TMMU));
	if (mmu)
	{
		TAPTR pool = TCreatePool(parentmmu, 256, 160, TNULL);
		if (pool)
		{
			if (TInitMMU(mmu, pool, TMMUT_Pooled, TNULL))
			{
				mmu->destroyallocatorfunc = TDestroy;
				mmu->handle.destroyfunc = (TDESTROYFUNC) destroycreatedmmu;		/* overwrite destructor */
				return mmu;
			}
			TDestroy(pool);
		}
		TMMUFree(parentmmu, mmu);
	}
	return TNULL;
}

#endif
