
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVLine(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2, TVPEN pen)
**
**	draw line
*/

TVOID TVLine(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2, TVPEN pen)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_LINE;
			msg->op.colrect.x = x1;
			msg->op.colrect.y = y1;
			msg->op.colrect.w = x2;
			msg->op.colrect.h = y2;
			msg->op.colrect.pen = pen;
			TPutReplyMsg(TTaskPort(v->task), v->asyncport, msg);
			return;
		}
		TWaitPort(v->asyncport);
	}
}
