
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVPEN pen = TVAllocPen(TAPTR visual, TUINT rgb)
**
**	alloc pen.
*/

TVPEN TVAllocPen(TAPTR visual, TUINT rgb)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;
	TVPEN ret;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_ALLOCPEN;
			msg->op.rgbpen.rgb = rgb;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			ret = msg->op.rgbpen.pen;
			kn_unlock(&v->asyncport->lock);
			return ret;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
