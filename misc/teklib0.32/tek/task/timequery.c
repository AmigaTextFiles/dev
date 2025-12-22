
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TTimeQuery(TAPTR task, TTIME *time)
**
**	query task's lifetime.
**
*/

TVOID TTimeQuery(TAPTR task, TTIME *time)
{
	if (task && time)
	{
		kn_querytimer(&((TTASK *) task)->timer, time);
	}
}
