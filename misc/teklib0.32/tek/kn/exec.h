
#ifndef _TEK_KERNEL_EXEC_H
#define	_TEK_KERNEL_EXEC_H 1

/*
**	tek/kn/exec.h
**	TEKlib kernel interface
**
**
**	TBOOL kn_initlock(TKNOB *lock)
**		init a kernel object structure with an atomic cross-task
**		locking mechanism. after initialization, the object has
**		no owner and is in unlocked state. when the same context
**		holds a lock on the object, further calls to kn_lock()
**		must succeed. this is also known as a recursive mutex.
**
**	TVOID kn_lock(TKNOB *lock)
**		block the caller as long as the lock is held inside another
**		context. return when the lock is free, when it gets unlocked
**		in another context, or when the lock is already held by the
**		caller. a call to this function must be empaired with a
**		matching call to kn_unlock() in the same context.
**
**	TVOID kn_unlock(TKNOB *lock)
**		unlock a locking object previously locked by the caller.
**
**	TBOOL kn_initbasecontext(TKNOB *thread, TAPTR data)
**		initialize kernel object structure with platform-specific
**		base context information, and make context data accessible
**		with kn_findself() in the current context.
**
**	TBOOL kn_initthread(TKNOB *thread, TVOID (*threadfunc)(TAPTR data), TAPTR data)
**		initialize kernel object structure with a new thread,
**		make context data accessible with kn_findself() and
**		launch the given function in the newly created context.
**
**	TAPTR kn_findself(TVOID)
**		return the current context specific data.
**
**	TVOID kn_deinitthread(TKNOB *thread)
**		thread closedown function for destroying platform-specific,
**		child-context related objects and buffers (if any). this function
**		is called shortly before returning from threadfunc(), but
**		it may not terminate the thread.
**
**	TBOOL kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *time)
**		wait for an event to occur, or for a timeout. the return value
**		will be TRUE when the event was already present, or when it
**		occured within the timeout period. timeout may be NULL, in
**		which case the event will be tested and returned immediately.
**		in either case, the event state will be cleared.
**
*/

#include "tek/type.h"

#ifdef KNEXECDEBUG
	#define	dbkprintf(l,x)		{if (l > 0 && l >= KNEXECDEBUG) platform_dbprintf(x);}
	#define	dbkprintf1(l,x,a)	{if (l > 0 && l >= KNEXECDEBUG) platform_dbprintf1(x,a);}
	#define	dbkprintf2(l,x,a,b)	{if (l > 0 && l >= KNEXECDEBUG) platform_dbprintf2(x,a,b);}
#else
	#define	dbkprintf(l,x)
	#define	dbkprintf1(l,x,a)
	#define	dbkprintf2(l,x,a,b)
#endif


extern TAPTR kn_alloc(TUINT size)														__ELATE_QCALL__(("qcall lib/tek/kn/exec/alloc"));
extern TAPTR kn_alloc0(TUINT size)														__ELATE_QCALL__(("qcall lib/tek/kn/exec/alloc0"));
extern TVOID kn_free(TAPTR mem)															__ELATE_QCALL__(("qcall lib/tek/kn/exec/free"));
extern TAPTR kn_realloc(TAPTR mem, TUINT size)											__ELATE_QCALL__(("qcall lib/tek/kn/exec/realloc"));
extern TUINT kn_getsize(TAPTR mem)														__ELATE_QCALL__(("qcall lib/tek/kn/exec/getsize"));

extern TVOID kn_memcopy(TAPTR from, TAPTR to, TUINT numbytes)							__ELATE_QCALL__(("qcall lib/tek/kn/exec/memcopy"));
extern TVOID kn_memcopy32(TAPTR from, TAPTR to, TUINT numbytes)							__ELATE_QCALL__(("qcall lib/tek/kn/exec/memcopy32"));
extern TVOID kn_memset(TAPTR dest, TUINT numbytes, TUINT8 fillval)						__ELATE_QCALL__(("qcall lib/tek/kn/exec/memset"));
extern TVOID kn_memset32(TAPTR dest, TUINT numbytes, TUINT fillval)						__ELATE_QCALL__(("qcall lib/tek/kn/exec/memset32"));

extern TBOOL kn_initlock(TKNOB *lock)													__ELATE_QCALL__(("qcall lib/tek/kn/exec/initlock"));
extern TVOID kn_destroylock(TKNOB *lock)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/destroylock"));
extern TVOID kn_lock(TKNOB *lock)														__ELATE_QCALL__(("qcall lib/tek/kn/exec/lock"));
extern TVOID kn_unlock(TKNOB *lock)														__ELATE_QCALL__(("qcall lib/tek/kn/exec/unlock"));

extern TBOOL kn_inittimer(TKNOB *timer)													__ELATE_QCALL__(("qcall lib/tek/kn/exec/inittimer"));
extern TVOID kn_destroytimer(TKNOB *timer)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/destroytimer"));
extern TVOID kn_querytimer(TKNOB *timer, TTIME *time)									__ELATE_QCALL__(("qcall lib/tek/kn/exec/querytimer"));
extern TVOID kn_timedelay(TKNOB *timer, TTIME *time)									__ELATE_QCALL__(("qcall lib/tek/kn/exec/timedelay"));
extern TVOID kn_resettimer(TKNOB *timer)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/resettimer"));

extern TBOOL kn_initevent(TKNOB *event)													__ELATE_QCALL__(("qcall lib/tek/kn/exec/initevent"));
extern TVOID kn_destroyevent(TKNOB *event)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/destroyevent"));
extern TVOID kn_doevent(TKNOB *event)													__ELATE_QCALL__(("qcall lib/tek/kn/exec/doevent"));
extern TVOID kn_waitevent(TKNOB *event)													__ELATE_QCALL__(("qcall lib/tek/kn/exec/waitevent"));
extern TBOOL kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *time)					__ELATE_QCALL__(("qcall lib/tek/kn/exec/timedwaitevent"));

extern TBOOL kn_initbasecontext(TKNOB *thread, TAPTR data)								__ELATE_QCALL__(("qcall lib/tek/kn/exec/initbasecontext"));
extern TVOID kn_destroybasecontext(TKNOB *thread)										__ELATE_QCALL__(("qcall lib/tek/kn/exec/destroybasecontext"));
extern TBOOL kn_initthread(TKNOB *thread, TVOID (*threadfunc)(TAPTR data), TAPTR data)	__ELATE_QCALL__(("qcall lib/tek/kn/exec/initthread"));
extern TVOID kn_deinitthread(TKNOB *thread)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/deinitthread"));
extern TVOID kn_destroythread(TKNOB *thread)											__ELATE_QCALL__(("qcall lib/tek/kn/exec/destroythread"));
extern TAPTR kn_findself(TVOID)															__ELATE_QCALL__(("qcall lib/tek/kn/exec/findself"));

extern TINT kn_getrandomseed(TKNOB *timer)												__ELATE_QCALL__(("qcall lib/tek/kn/exec/getrandomseed"));


#endif
