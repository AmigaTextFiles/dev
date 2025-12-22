
#include "tek/exec.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT signals = TTimedWait(TAPTR task, TUINT sigmask, TTIME *timeout)
**
**	suspend task to wait for a set of signals, or for a timeout.
**	when timeout is TNULL or (timeout->sec == 0 && timeout->usec == 0),
**	then this function is equivalent to TTaskWait.
*/

TUINT TTimedWait(TAPTR task, TUINT sigmask, TTIME *timeout)
{
	if (task)
	{
		if (timeout)
		{
			if (timeout->sec || timeout->usec)
			{	
				TUINT signals;
				TTIME t;
				TFLOAT total, tf1, newdelay;

				total = TTIMETOF(timeout);
				TTimeQuery(task, &t);
				tf1 = TTIMETOF(&t);
				
				for (;;)
				{			
					signals = TSetSignal(task, 0, sigmask) & sigmask;
					if (signals)
					{
						return signals;
					}
					
					if (!kn_timedwaitevent(&((TTASK *) task)->sigevent, &((TTASK *) task)->timer, timeout))
					{
						return 0;
					}

					TTimeQuery(task, &t);
					newdelay = total - (TTIMETOF(&t) - tf1);
					if (newdelay < 0.000001f)
					{
						kn_doevent(&((TTASK *) task)->sigevent);	/* make event pending again */
						return 0;
					}

					TFTOTIME(newdelay, &t);
					timeout = &t;
				}
			}
		}
		
		if (sigmask)
		{
			TWait(task, sigmask);
		}
	}
	return 0;
}
