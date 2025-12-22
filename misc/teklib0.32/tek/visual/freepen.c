
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVFreePen(TAPTR visual, TVPEN pen)
**
**	free pen.
*/

TVOID TVFreePen(TAPTR visual, TVPEN pen)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_FREEPEN;
			msg->op.pen.pen = pen;
			TPutReplyMsg(TTaskPort(v->task), v->asyncport, msg);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
