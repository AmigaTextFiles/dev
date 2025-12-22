
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_lock(TKNOB *lock)
**
**	obtain kernel lock.
**
*/

TVOID kn_lock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_MUTEX))
	{
		kn_mtx_lock((ELATE_MUTEX *) lock);
	}
	else
	{
		kn_mtx_lock(*((ELATE_MUTEX **) lock));
	}
}
