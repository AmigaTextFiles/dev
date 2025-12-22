
#ifndef _TEK_EXEC_H
#define	_TEK_EXEC_H

/*
**	tek/exec.h
**	tasks, signals, msgports
*/

#include <tek/mem.h>


/* 
**	task structure
**
**	consider it private and access it with the supplied accessor
**	macros, so that your code won't break once this structure gets
**	blackboxed.
*/

typedef	struct					/* task */
{
	THNDL handle;				/* object handle */
	TAPTR basetask;				/* base task (may be backptr to this task) */

	TVOID (*func)(TAPTR);		/* user entry function */
	TBOOL (*initfunc)(TAPTR);	/* user init function in child context */

	TAPTR userdata;				/* user/init data */

	TKNOB thread;				/* kernel thread object */
	TKNOB timer;				/* kernel timer object */

	TMMU heapmmu;				/* heap memory manager */
	TAPTR heapallocator;		/* heapmmu's underlying allocator */

	TKNOB runlock;				/* run-environment lock */

	TKNOB statusevent;			/* status change event */
	TUINT status;				/* task status */

	TKNOB siglock;				/* signal lock */
	TKNOB sigevent;				/* signal event */
	TUINT sigstate;				/* current signal state */
	TUINT sigfree;				/* free signals */
	TUINT sigused;				/* used signals */

	TAPTR port;					/* task's primaray async msgport */
	TAPTR syncreplyport;		/* task's internal msgport for synchronized replies */
	
	TMMU *msgmmu;				/* ptr to basetask message memory manager */

}	TTASK;


/* 
**	task status
**
**	applications never need to query these flags.
*/

#define TTASK_STATUS_INITIALIZING	0		/* task is initializing */
#define TTASK_STATUS_RUNNING		1		/* task is running */	
#define TTASK_STATUS_FINISHED		2		/* task has concluded */
#define TTASK_STATUS_FAILED			3		/* task failed to initialize and was never running in tekspace */


typedef struct						/* lock */
{
	THNDL handle;					/* object handle */
	TKNOB lock;						/* kernel lock object */
}	TLOCK;


typedef struct						/* message communication port */
{
	THNDL handle;					/* object handle */
	TKNOB lock;						/* kernel lock object */
	TLIST msglist;					/* list of queued messages */
	TAPTR sigtask;					/* task to be signalled on msg arrival */
	TUINT signal;					/* signal to appear in sigtask */
	TAPTR proxy;					/* proxy object for this port */
	TAPTR reserved[2];
}	TPORT;


/* 
**	task entry and init functions
*/

typedef TVOID (*TTASKFUNC)(TAPTR task);
typedef TBOOL (*TTASKINITFUNC)(TAPTR task);


/* 
**	task signals
**
**	note: currently there are 31 free user signals, but the number of
**	reserved signals (like TTASK_SIG_ABORT) may grow in the future.
**	TEKlib guarantees that a newly created task's upper 16 signal bits
**	(0x8000000 through 0x00010000) will remain available to the user.
**	more free user signals (if available) can be obtained safely with
**	TAllocSignal(). allocation is recommended anyway.
*/

#define TTASK_MAX_SIGNALS			32
#define TTASK_SIG_ABORT				0x00000001
#define TTASK_SIG_RESERVED 			TTASK_SIG_ABORT
#define TTASK_SIG_USER	 			0xffff0000


/* 
**	task tags
*/

#define TTASKTAGS_					(TTAG_USER + 0x300)
#define TTask_MMU					(TTAG) (TTASKTAGS_ + 0)		/* parent memory manager */
#define TTask_InitFunc				(TTAG) (TTASKTAGS_ + 1)		/* child init function */
#define TTask_UserData				(TTAG) (TTASKTAGS_ + 2)		/* ptr to user/init data */
#define TTask_HeapMMU				(TTAG) (TTASKTAGS_ + 3)		/* memory manager for task's heap space */
#define TTask_CreatePort			(TTAG) (TTASKTAGS_ + 4)		/* create a message port in task's context */


/* 
**	TFLOAT time support macros
*/

#define TTIMETOF(t) 				(((TFLOAT) (t)->sec) + 0.000001f * ((TFLOAT) (t)->usec))
#define TFTOTIME(f,t)				(t)->sec = (TUINT) (f); (t)->usec = (TUINT) (((f) - (t)->sec) * 1000000);
#define TTimeDelayF(task,f)			{ TTIME t; TFTOTIME(f,&t); TTimeDelay(task, &t); }


/* 
**	support macros for memory allocation from a task's heap memory manager.
**	memory allocated from the task's heap will be automatically freed when
**	the task exits.
*/

#define TTaskAlloc(task,size) TMMUAlloc(&((TTASK *) (task))->heapmmu, size)
#define TTaskAlloc0(task,size) TMMUAlloc0(&((TTASK *) (task))->heapmmu, size)
#define TTaskFree(task,mem) TMMUFree(&((TTASK *) (task))->heapmmu, mem)
#define TTaskRealloc(task,mem,newsize) TMMURealloc(&((TTASK *) (task))->heapmmu, mem, newsize)
#define TTaskGetSize(task,mem) TMMUGetSize(&((TTASK *) (task))->heapmmu, mem)
#define TTaskAllocHandle(task,df,size) TMMUAllocHandle(&((TTASK *) (task))->heapmmu, (TDESTROYFUNC) df, size)
#define TTaskAllocHandle0(task,df,size) TMMUAllocHandle0(&((TTASK *) (task))->heapmmu, (TDESTROYFUNC) df, size)


/* 
**	task accessor macros
*/

#define TTaskGetData(task)			((TTASK *) (task))->userdata
#define TTaskSetData(task,data)		{ ((TTASK *) (task))->userdata = data; }
#define TTaskPort(task)				((TPORT *)(((TTASK *) (task))->port))
#define TTaskBaseTask(task)			((TTASK *) (task))->basetask
#define TTaskHeapMMU(task)			&((TTASK *) (task))->heapmmu
#define TTaskMsgMMU(task)			((TTASK *) (task))->msgmmu
#define TTaskSyncPort(task)			((TPORT *)(((TTASK *) (task))->syncreplyport))


TBEGIN_C_API


extern TAPTR TCreateTask(TAPTR parenttask, TTASKFUNC function, TTAGITEM *tags)		__ELATE_QCALL__(("qcall lib/tek/task/createtask"));
extern TAPTR TCreateTaskTags(TAPTR parenttask, TTASKFUNC function, TTAG tag1, ...)	__ELATE_QCALL__(("qcall lib/tek/task/createtasktags"));

extern TUINT TAllocSignal(TAPTR task, TUINT signals)							__ELATE_QCALL__(("qcall lib/tek/task/allocsignal"));
extern TVOID TFreeSignal(TAPTR task, TUINT signal)								__ELATE_QCALL__(("qcall lib/tek/task/freesignal"));
extern TVOID TSignal(TAPTR task, TUINT signals)									__ELATE_QCALL__(("qcall lib/tek/task/signal"));
extern TUINT TSetSignal(TAPTR task, TUINT newsignals, TUINT sigmask)			__ELATE_QCALL__(("qcall lib/tek/task/setsignal"));
extern TUINT TWait(TAPTR task, TUINT sigmask)									__ELATE_QCALL__(("qcall lib/tek/task/wait"));
extern TUINT TTimedWait(TAPTR task, TUINT sigmask, TTIME *timeout)				__ELATE_QCALL__(("qcall lib/tek/task/timedwait"));

extern TBOOL TInitLock(TAPTR task, TLOCK *lock, TTAGITEM *tags)					__ELATE_QCALL__(("qcall lib/tek/task/initlock"));
extern TVOID TLock(TLOCK *lock)													__ELATE_QCALL__(("qcall lib/tek/task/lock"));
extern TVOID TUnlock(TLOCK *lock)												__ELATE_QCALL__(("qcall lib/tek/task/unlock"));

extern TPORT *TCreatePort(TAPTR task, TTAGITEM *tags)							__ELATE_QCALL__(("qcall lib/tek/task/createport"));
extern TPORT *TCreatePortTags(TAPTR task, TTAG tag1, ...)						__ELATE_QCALL__(("qcall lib/tek/task/createporttags"));

extern TVOID TWaitPort(TPORT *port)												__ELATE_QCALL__(("qcall lib/tek/task/waitport"));

extern TVOID TTimeDelay(TAPTR task, TTIME *time)								__ELATE_QCALL__(("qcall lib/tek/task/timedelay"));
extern TVOID TTimeQuery(TAPTR task, TTIME *time)								__ELATE_QCALL__(("qcall lib/tek/task/timequery"));
extern TVOID TTimeReset(TAPTR task)												__ELATE_QCALL__(("qcall lib/tek/task/timereset"));

extern TINT TGetRandomSeed(TAPTR task)											__ELATE_QCALL__(("qcall lib/tek/task/getrandomseed"));


/* 
**	private functions.
*/

extern TINT TDestroyPort(TAPTR msgport)											__ELATE_QCALL__(("qcall lib/tek/task/destroyport"));
extern TAPTR TTaskFindSelf(TVOID)												__ELATE_QCALL__(("qcall lib/tek/task/taskfindself"));


TEND_C_API


#endif
