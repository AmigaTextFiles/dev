
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVFlushArea(TAPTR visual, TINT x, TINT y, TINT w, TINT h)
**
**	sync/expose area.
*/

TVOID TVFlushArea(TAPTR visual, TINT x, TINT y, TINT w, TINT h)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_FLUSHAREA;
			msg->op.rect.x = x;
			msg->op.rect.y = y;
			msg->op.rect.w = w;
			msg->op.rect.h = h;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
