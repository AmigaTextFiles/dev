
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TTimeReset(TAPTR task)
**
**	reset task timer
**
*/

TVOID TTimeReset(TAPTR task)
{
	if (task)
	{
		kn_resettimer(&((TTASK *) task)->timer);
	}
}
