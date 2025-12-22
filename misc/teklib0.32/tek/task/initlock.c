
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TInitLock(TAPTR task, TLOCK *lock, TTAGITEM *tags)
**
**	initialize a locking object for accesses across tasks
**
*/

static TINT destroylock(TLOCK *lock);

TBOOL TInitLock(TAPTR task, TLOCK *lock, TTAGITEM *tags)
{
	if (lock)
	{
		if (kn_initlock(&lock->lock))
		{
			lock->handle.destroyfunc = (TDESTROYFUNC) destroylock;
			lock->handle.mmu = TNULL;
			return TTRUE;
		}
	}
	return TFALSE;
}

static TINT destroylock(TLOCK *lock)
{
	kn_destroylock(&lock->lock);	
	return 0;
}
