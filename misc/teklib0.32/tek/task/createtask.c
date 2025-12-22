
#include "tek/exec.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TCreateTask(TAPTR parenttask, TTASKFUNC function, TTAGITEM *tags)
**
**	create task.
**
**	tags:
**		TTask_MMU				mmu to allocate task structures from, default: the basetask's heap mmu
**		TTask_HeapMMU			mmu to put task's heap mmu on, default: TTask_MMU
**		TTask_InitFunc			init function, default: TNULL
**
**	TODO: fixme: user-specified TTask_HeapMMU is currently overwritten with a pool allocator!!! (stimmt garnicht, oder?)
**	TODO: return a task return value with TDestroy(task) ?
**	TODO: add user TTask_MsgMMU tag
**
*/

static TINT destroytask(TTASK *task);
static TVOID taskentryfunc(TTASK *task);

TAPTR TCreateTask(TAPTR parenttask, TTASKFUNC function, TTAGITEM *taglist)
{
	TTASKINITFUNC initfunction = (TTASKINITFUNC) TGetTagValue(TTask_InitFunc, TNULL, taglist);
	
	if (!(function || initfunction) == !parenttask)
	{
		TAPTR parentmmu = TGetTagValue(TTask_MMU, parenttask ? 
			&((TTASK *)((TTASK *) parenttask)->basetask)->heapmmu : TNULL, taglist);

		TTASK *newtask = TMMUAllocHandle0(parentmmu, (TDESTROYFUNC) destroytask, sizeof(TTASK));
		if (newtask)
		{
			newtask->heapallocator = TGetTagValue(TTask_HeapMMU, parentmmu, taglist);

			if (parenttask)
			{
				/*
				**	create new context.
				*/
				
				if (kn_initlock(&newtask->siglock))
				{
					if (kn_initlock(&newtask->runlock))
					{
						if (kn_initevent(&newtask->statusevent))
						{
							newtask->basetask = ((TTASK *) parenttask)->basetask;
							newtask->msgmmu = ((TTASK *) (newtask->basetask))->msgmmu;
							newtask->func = function;
							newtask->initfunc = initfunction;
							newtask->userdata = TGetTagValue(TTask_UserData, TNULL, taglist);
							newtask->sigstate = 0;
							newtask->sigfree = ~TTASK_SIG_RESERVED;
							newtask->sigused = TTASK_SIG_RESERVED;
							newtask->status = TTASK_STATUS_INITIALIZING;
				
							kn_lock(&newtask->runlock);
			
							if (kn_initthread(&newtask->thread, (TVOID (*)(TAPTR data)) taskentryfunc, newtask))
							{
								kn_unlock(&newtask->runlock);

								kn_waitevent(&newtask->statusevent);


								#ifndef TEKLIB_PTHREADS_FLAW

									kn_destroyevent(&newtask->statusevent);	
								
									/* race condition in pthreads? */

								#endif


								if (newtask->status != TTASK_STATUS_FAILED)
								{
									return newtask;
								}
							}
							else
							{
								kn_unlock(&newtask->runlock);
							}
						}
						kn_destroylock(&newtask->runlock);
					}
					kn_destroylock(&newtask->siglock);
				}
			}
			else
			{
				/*
				**	establish base context.
				*/
			
				newtask->heapallocator = TCreatePool(newtask->heapallocator, 1024, 512, TNULL);
				if (newtask->heapallocator)
				{
					if (TInitMMU(&newtask->heapmmu, newtask->heapallocator, TMMUT_Pooled+TMMUT_TaskSafe, TNULL))
					{
						newtask->msgmmu = TMMUAlloc(&newtask->heapmmu, sizeof(TMMU));
						if (newtask->msgmmu)
						{
							if (TInitMMU(newtask->msgmmu, TNULL, TMMUT_Message, TNULL))
							{
								if (kn_inittimer(&newtask->timer))
								{
									if (kn_initlock(&newtask->siglock))
									{
										if (kn_initevent(&newtask->sigevent))
										{
											newtask->basetask = newtask;
											newtask->sigstate = 0;
											newtask->sigfree = ~TTASK_SIG_RESERVED;
											newtask->sigused = TTASK_SIG_RESERVED;
											
											if (kn_initbasecontext(&newtask->thread, newtask))
											{
												newtask->port = TCreatePort(newtask, TNULL);
												if (newtask->port)
												{
													newtask->syncreplyport = TCreatePort(newtask, TNULL);
													if (newtask->syncreplyport)
													{
														newtask->status = TTASK_STATUS_RUNNING;
														return newtask;
													}
													TDestroy(newtask->port);
												}
												kn_destroybasecontext(&newtask->thread);
											}
											kn_destroyevent(&newtask->sigevent);
										}
										kn_destroylock(&newtask->siglock);
									}
									kn_destroytimer(&newtask->timer);
								}
								TDestroy(newtask->msgmmu);
							}
							TMMUFree(&newtask->heapmmu, newtask->msgmmu);		/* redundant */
						}
						TDestroy(&newtask->heapmmu);
					}
					TDestroy(newtask->heapallocator);
				}
			}
			TMMUFreeHandle(newtask);
		}
	}

	tdbprintf(10, "*** TEKLIB: createtask failed\n");
	
	return TNULL;
}


static TVOID taskentryfunc(TTASK *task)
{
	TBOOL success = TFALSE;

	if (kn_inittimer(&task->timer))
	{
		if (kn_initevent(&task->sigevent))
		{
			task->heapallocator = TCreatePool(task->heapallocator, 512, 256, TNULL);
			if (task->heapallocator)
			{
				if (TInitMMU(&task->heapmmu, task->heapallocator, TMMUT_TaskSafe+TMMUT_Pooled, TNULL))
				{
					task->port = TCreatePort(task, TNULL);
					if (task->port)
					{
						task->syncreplyport = TCreatePort(task, TNULL);
						if (task->syncreplyport)
						{
							success = TTRUE;

							if (task->initfunc)
							{
								success = (*task->initfunc)(task);
							}

							if (success)
							{
								kn_lock(&task->runlock);
			
								task->status = TTASK_STATUS_RUNNING;
								kn_doevent(&task->statusevent);
			
								if (task->func)
								{
									(*task->func)(task);
								}
							}
				
							TDestroy(task->syncreplyport);
						}
						TDestroy(task->port);
					}
					TDestroy(&task->heapmmu);
				}
				TDestroy(task->heapallocator);
			}
			kn_destroyevent(&task->sigevent);
		}
		kn_destroytimer(&task->timer);
	}

	kn_deinitthread(&task->thread);

	if (success)
	{
		task->status = TTASK_STATUS_FINISHED;
		kn_unlock(&task->runlock);
	}
	else
	{
		task->status = TTASK_STATUS_FAILED;
		kn_doevent(&task->statusevent);
	}
}



static TINT destroytask(TTASK *task)
{
	if (task->basetask != task)
	{
		kn_lock(&task->runlock);

		#ifdef TEKLIB_PTHREADS_FLAW

			kn_destroyevent(&task->statusevent);
			
			/* race condition in pthreads? */

		#endif

		kn_unlock(&task->runlock);
		kn_destroylock(&task->runlock);
		kn_destroylock(&task->siglock);
		kn_destroythread(&task->thread);
	}
	else
	{
		TDestroy(task->syncreplyport);
		TDestroy(task->port);
		kn_destroybasecontext(&task->thread);
		kn_destroyevent(&task->sigevent);
		kn_destroylock(&task->siglock);
		kn_destroytimer(&task->timer);
		TDestroy(task->msgmmu);
		TMMUFree(&task->heapmmu, task->msgmmu);
		TDestroy(&task->heapmmu);
		TDestroy(task->heapallocator);
	}

	TMMUFreeHandle(task);

	return 0;
}
