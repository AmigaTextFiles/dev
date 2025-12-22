
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVText(TAPTR visual, TINT x, TINT y, TSTRPTR text, TUINT len, TVPEN bgpen, TVPEN fgpen)
**
**	write text to fixed-width-text-cursor position
*/

TVOID TVText(TAPTR visual, TINT x, TINT y, TSTRPTR text, TUINT len, TVPEN bgpen, TVPEN fgpen)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_TEXT;
			msg->op.text.x = x;
			msg->op.text.y = y;
			msg->op.text.text = text;
			msg->op.text.len = len;
			msg->op.text.bgpen = bgpen;
			msg->op.text.fgpen = fgpen;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
