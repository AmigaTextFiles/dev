
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_querytimer(TKNOB *timer, TTIME *time)
**
**	query kernel timer.
**
*/

TVOID kn_querytimer(TKNOB *timer, TTIME *time)
{
	long dt = kn_time_get();
	
	if (sizeof(TKNOB) >= sizeof(long))
	{
		dt -= *((long *) timer);
	}
	else
	{
		dt -= *(*((long **) timer));
	}

	time->sec = (TUINT) (dt / 1000000000);
	time->usec = (TUINT) ((dt % 1000000000) / 1000);
}
