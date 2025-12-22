
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVDrawRGB(TAPTR visual, TINT x, TINT y, TUINT *buffer, TINT w, TINT h, TINT totw)
**
**	draw rgb array
*/

TVOID TVDrawRGB(TAPTR visual, TINT x, TINT y, TUINT *buffer, TINT w, TINT h, TINT totw)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_DRAWRGB;
			msg->op.rgb.rgbbuf = buffer;
			msg->op.rgb.x = x;
			msg->op.rgb.y = y;
			msg->op.rgb.w = w;
			msg->op.rgb.h = h;
			msg->op.rgb.totw = totw;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
