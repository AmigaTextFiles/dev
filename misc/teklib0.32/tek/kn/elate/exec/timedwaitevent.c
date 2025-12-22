
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL occured = kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *time)
**
**	wait for kernel event with timeout.
**
*/

TBOOL kn_timedwaitevent(TKNOB *event, TKNOB *timer, TTIME *time)
{
	if (time)
	{
		long t = ((long) time->sec) * 1000000000 + ((long) time->usec) * 1000;
		if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
		{
			return (kn_evf_timedwait((ELATE_EVF *) event, 1, EVFF_AND | EVFF_CLR, t) != 0);
		}
		else
		{
			return (kn_evf_timedwait(*((ELATE_EVF **) event), 1, EVFF_AND | EVFF_CLR, t) != 0);
		}
	}
	else
	{
		if (sizeof(TKNOB) >= sizeof(ELATE_EVF))
		{
			return (kn_evf_timedwait((ELATE_EVF *) event, 1, EVFF_AND | EVFF_CLR, 1) != 0);
			/*return (kn_evf_trywait((ELATE_EVF *) event, 1, EVFF_AND | EVFF_CLR) != 0);*/
		}
		else
		{
			return (kn_evf_timedwait(*((ELATE_EVF **) event), 1, EVFF_AND | EVFF_CLR, 1) != 0);
			/*return (kn_evf_trywait(*((ELATE_EVF **) event), 1, EVFF_AND | EVFF_CLR) != 0);*/
		}
	}
}