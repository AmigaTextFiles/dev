
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TSignal(TAPTR task, TUINT signals)
**
**	send signals to a task.
**
**	an event is thrown when not all of the affecting signals
**	are already present in the task's signal mask.
**
*/

TVOID TSignal(TAPTR task, TUINT signals)
{
	if (task && signals)
	{
		kn_lock(&((TTASK *) task)->siglock);

		if ((signals & ((TTASK *) task)->sigstate) != signals)
		{
			((TTASK *) task)->sigstate |= signals;
			kn_doevent(&((TTASK *) task)->sigevent);
		}
	
		kn_unlock(&((TTASK *) task)->siglock);
	}
}
