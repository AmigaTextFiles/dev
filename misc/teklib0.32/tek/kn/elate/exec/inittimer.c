
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_inittimer(TKNOB *timer)
**
**	init kernel timer.
**
*/

TBOOL kn_inittimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(long))
	{
		*((long *) timer) = kn_time_get();
		return TTRUE;
	}
	else
	{
		long *t = kn_alloc(sizeof(long));
		if (t)
		{
			*t = kn_time_get();
			*((long **) timer) = t;
			return TTRUE;
		}
	}
	
	dbprintf("*** TEKLIB kernel: could not create timer\n");
	return TFALSE;
}
