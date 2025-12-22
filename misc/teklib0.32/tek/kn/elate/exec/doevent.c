
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_doevent(TKNOB *event)
**
**	do kernel event.
**
*/

TVOID kn_doevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
	{
		kn_evf_set((ELATE_EVF *) event, 1);
	}
	else
	{
		kn_evf_set(*((ELATE_EVF **) event), 1);
	}
}
