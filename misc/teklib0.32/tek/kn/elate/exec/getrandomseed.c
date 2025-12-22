
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT kn_getrandomseed(TKNOB *timer)
**
*/

TINT kn_getrandomseed(TKNOB *timer)
{
	return (TINT) kn_time_get();
}

