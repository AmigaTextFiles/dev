
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVFRect(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TVPEN pen)
**
**	draw filled rectangle
*/

TVOID TVFRect(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TVPEN pen)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_FRECT;
			msg->op.colrect.x = x;
			msg->op.colrect.y = y;
			msg->op.colrect.w = w;
			msg->op.colrect.h = h;
			msg->op.colrect.pen = pen;
			TPutReplyMsg(TTaskPort(v->task), v->asyncport, msg);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}

