
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TWait(TAPTR task, TUINT sigmask)
**
**	suspend task to wait for a set of signals.
**
*/

TUINT TWait(TAPTR task, TUINT sigmask)
{
	if (sigmask)
	{
		TUINT signals;
		for (;;)
		{
			kn_lock(&((TTASK *) task)->siglock);

			signals = ((TTASK *) task)->sigstate & sigmask;
			((TTASK *) task)->sigstate &= ~sigmask;
			
			kn_unlock(&((TTASK *) task)->siglock);

			if (signals)
			{
				return signals;
			}

			kn_waitevent(&((TTASK *) task)->sigevent);
		}
	}
	
	return 0;
}
