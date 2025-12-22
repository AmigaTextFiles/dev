
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TFreeSignal(TAPTR task, TUINT signal)
**
**	free task signal(s).
**
*/

TVOID TFreeSignal(TAPTR task, TUINT signal)
{
	if (task && signal)
	{
		kn_lock(&((TTASK *) task)->siglock);

		((TTASK *) task)->sigfree |= signal;
		((TTASK *) task)->sigused &= ~signal;
		((TTASK *) task)->sigstate &= ~signal;
	
		kn_unlock(&((TTASK *) task)->siglock);
	}
}
