
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVPlot(TAPTR visual, TINT x, TINT y, TVPEN pen)
**
**	plot.
*/

TVOID TVPlot(TAPTR v, TINT x, TINT y, TVPEN pen)
{
	TDRAWMSG *msg;
	for (;;)
	{
		if ((msg = TGetMsg(((TVISUAL *) v)->asyncport)))
		{
			msg->jobcode = TVJOB_PLOT;
			msg->op.plot.x = x;
			msg->op.plot.y = y;
			msg->op.plot.pen = pen;
			TPutReplyMsg(TTaskPort(((TVISUAL *) v)->task), ((TVISUAL *) v)->asyncport, msg);
			return;
		}
		TWaitPort(((TVISUAL *) v)->asyncport);		/* wait for free node */
	}
}
