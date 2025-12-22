
#include "tek/visual.h"
#include "tek/kn/exec.h"
#include "tek/kn/elate/visual.h"

#include <elate/taort.h>
#include <elate/elate.h>
#include <elate/ave.h>

#include <stdio.h>

/* 
**	TEKlib
**	(C) 1999-2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_waitvisual(TAPTR v, TKNOB *timer, TKNOB *evt)
**
*/



TBOOL kn_waitvisual(TAPTR vis, TKNOB *timer, TKNOB *evt)
{
	struct visual_elate *v = (struct visual_elate *) vis;
	TTIME delay = {0, 50000};

	if (v->evtpending)
	{
		return TTRUE;
	}
	
	if (getevent(vis, &v->pendingevent, &v->pendingx, &v->pendingy, &v->pendingkeycooked, &v->pendingresize, &v->pendingbuttonstate))
	{
		v->evtpending = TTRUE;
	}
	
	if (!v->evtpending)
	{
		kn_timedwaitevent(evt, timer, &delay);
	}

	return v->evtpending;
}
