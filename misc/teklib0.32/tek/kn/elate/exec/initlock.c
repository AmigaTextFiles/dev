
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_initlock(TKNOB *lock)
**
**	init kernel lock
**
*/

TBOOL kn_initlock(TKNOB *lock)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_MUTEX))
	{
		if (kn_mtx_init((ELATE_MUTEX *) lock, MTX_FIFO|MTX_NONE|MTX_RECURSIVE, 0) == 0)
		{
			return TTRUE;
		}
	}
	else
	{
		ELATE_MUTEX *mtx = kn_alloc(sizeof(ELATE_MUTEX));
		if (mtx)
		{
			if (kn_mtx_init(mtx, MTX_FIFO|MTX_NONE|MTX_RECURSIVE, 0) == 0)
			{
				*((ELATE_MUTEX **) lock) = mtx;
				return TTRUE;
			}
			kn_free(mtx);
		}
	}

	dbkprintf(10, "*** TEKLIB kernel: could not create lock\n");
	return TFALSE;
}
