
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_timedelay(TKNOB *timer, TTIME *time)
**
**	delay.
**
*/

TVOID kn_timedelay(TKNOB *timer, TTIME *time)
{
	kn_proc_sleep(((long) time->sec) * 1000000000 + ((long) time->usec) * 1000);
}
