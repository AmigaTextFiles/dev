
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TAllocSignal(TAPTR task, TUINT signals)
**
**	alloc task signal(s).
**
*/

TUINT TAllocSignal(TAPTR task, TUINT signals)
{
	TUINT newsignal = 0;

	if (task)
	{
		kn_lock(&((TTASK *) task)->siglock);

		if (signals)
		{
			if ((signals & ((TTASK *) task)->sigfree) == signals)
			{
				newsignal = signals;
			}
		}
		else
		{
			TINT x;
			TUINT trysignal = 0x00000001;
			
			for (x = 0; x < TTASK_MAX_SIGNALS; ++x)
			{
				if (!(trysignal & TTASK_SIG_RESERVED))
				{
					if (trysignal & ((TTASK *) task)->sigfree)
					{
						newsignal = trysignal;
						break;
					}
				}
				trysignal <<= 1;
			}
		}

		((TTASK *) task)->sigfree &= ~newsignal;
		((TTASK *) task)->sigstate &= ~newsignal;				/* clear from current set of signals */
		((TTASK *) task)->sigused |= newsignal;

		kn_unlock(&((TTASK *) task)->siglock);
	}
	
	return newsignal;
}
