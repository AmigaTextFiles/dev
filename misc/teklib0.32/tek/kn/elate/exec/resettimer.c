
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_resettimer(TKNOB *timer)
**
**	reset kernel timer to zero.
**
*/

TVOID kn_resettimer(TKNOB *timer)
{
	if (sizeof(TKNOB) >= sizeof(long))
	{
		*((long *) timer) = kn_time_get();
	}
	else
	{
		*(*((long **) timer)) = kn_time_get();
	}
}
