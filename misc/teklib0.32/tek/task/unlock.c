
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TUnlock(TLOCK *lock)
**
**	release access to a lock
**
*/

TVOID TUnlock(TLOCK *lock)
{
	if (lock)
	{
		kn_unlock(&lock->lock);
	}
}
