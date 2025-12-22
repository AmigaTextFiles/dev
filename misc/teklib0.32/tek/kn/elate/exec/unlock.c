
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_unlock(TKNOB *lock)
**
**	release kernel lock.
**
*/

TVOID kn_unlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_MUTEX))
	{
		kn_mtx_unlock((ELATE_MUTEX *) lock);
	}
	else
	{
		kn_mtx_unlock(*((ELATE_MUTEX **) lock));
	}
}
