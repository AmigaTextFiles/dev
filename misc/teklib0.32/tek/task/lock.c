
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TLock(TLOCK *lock)
**
**	block until caller has exclusive access to a lock
**
*/

TVOID TLock(TLOCK *lock)
{
	if (lock)
	{
		kn_lock(&lock->lock);
	}
}
