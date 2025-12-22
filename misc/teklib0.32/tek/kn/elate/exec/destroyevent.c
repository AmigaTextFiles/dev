
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_destroyevent(TKNOB *event)
**
**	destroy kernel event.
**
*/

TVOID kn_destroyevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
	{
		kn_evf_destroy((ELATE_EVF *) event);
	}
	else
	{
		kn_evf_destroy(*((ELATE_EVF **) event));
		kn_free(*((ELATE_EVF **) event));
	}
}
