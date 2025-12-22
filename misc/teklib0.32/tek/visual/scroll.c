
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVScroll(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TINT dx, TINT dy)
**
**	scroll rectangle
*/

TVOID TVScroll(TAPTR visual, TINT x, TINT y, TINT w, TINT h, TINT dx, TINT dy)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_SCROLL;
			msg->op.scroll.x = x;
			msg->op.scroll.y = y;
			msg->op.scroll.w = w;
			msg->op.scroll.h = h;
			msg->op.scroll.dx = dx;
			msg->op.scroll.dy = dy;
			TPutReplyMsg(TTaskPort(v->task), v->asyncport, msg);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}

