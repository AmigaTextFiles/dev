
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_destroytimer(TKNOB *timer)
**
**	destroy kernel timer.
**
*/

TVOID kn_destroytimer(TKNOB *timer)
{
	if (sizeof(TKNOB) < sizeof(long))
	{
		kn_free(*((long **) timer));
	}
}
