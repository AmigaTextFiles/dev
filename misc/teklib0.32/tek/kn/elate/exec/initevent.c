
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_initevent(TKNOB *event)
**
**	init kernel event.
**
*/

TBOOL kn_initevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
	{
		if (kn_evf_init((ELATE_EVF *) event, 0) == 0)
		{
			return TTRUE;
		}
	}
	else
	{
		ELATE_EVF *evt = kn_alloc(sizeof(ELATE_EVF));
		if (evt)
		{
			if (kn_evf_init(evt, 0) == 0)
			{
				*((ELATE_EVF **) event) = evt;
				return TTRUE;
			}
			kn_free(evt);
		}
	}

	dbkprintf(10,"*** TEKLIB kernel: could not create event\n");
	return TFALSE;
}
