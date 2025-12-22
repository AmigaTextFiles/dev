
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_destroylock(TKNOB *lock)
**
**	delete kernel lock.
**
*/

TVOID kn_destroylock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_MUTEX))
	{
		kn_mtx_destroy((ELATE_MUTEX *) lock);
	}
	else
	{
		kn_mtx_destroy(*((ELATE_MUTEX **) lock));
		kn_free(*((ELATE_MUTEX **) lock));
	}
}
