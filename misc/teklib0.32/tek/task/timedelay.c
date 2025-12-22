
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TTimeDelay(TAPTR task, TTIME *time)
**
**	delay. task must refer to the current context.
**
*/

TVOID TTimeDelay(TAPTR task, TTIME *time)
{
	if (task && time)
	{
		kn_timedelay(&((TTASK *) task)->timer, time);
	}
}
