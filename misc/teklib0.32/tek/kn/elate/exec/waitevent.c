
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_waitevent(TKNOB *event)
**
**	wait for kernel event.
**
*/

TVOID kn_waitevent(TKNOB *event)
{
	if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
	{
		kn_evf_wait((ELATE_EVF *) event, 1, EVFF_AND + EVFF_CLR);
	}
	else
	{
		kn_evf_wait(*((ELATE_EVF **) event), 1, EVFF_AND + EVFF_CLR);
	}
}
