
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TSetSignal(TAPTR t, TUINT newsignals, TUINT sigmask)
**
**	set/get a task's signal state.
**
**	an event is thrown if there are newsignals covered
**	by sigmask that are not already present in the task's
**	signal state.
**
*/

TUINT TSetSignal(TAPTR task, TUINT newsignals, TUINT sigmask)
{
	TUINT oldsignals = 0;

	kn_lock(&((TTASK *) task)->siglock);
	
	oldsignals = ((TTASK *) task)->sigstate;
	((TTASK *) task)->sigstate &= ~sigmask;
	((TTASK *) task)->sigstate |= newsignals;

	if (newsignals & sigmask & oldsignals)
	{
		kn_doevent(&((TTASK *) task)->sigevent);
	}

	kn_unlock(&((TTASK *) task)->siglock);
	
	return oldsignals;
}
