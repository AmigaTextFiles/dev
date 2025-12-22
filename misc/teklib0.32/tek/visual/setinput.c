
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT oldmask = TVSetInput(TAPTR visual, TUINT clearmask, TUINT setmask)
**
**	get and set mask of input events to be monitored.
*/

TUINT TVSetInput(TAPTR visual, TUINT clearmask, TUINT setmask)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;
	TUINT ret;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_SETINPUT;
			msg->op.input.clearmask = clearmask;
			msg->op.input.setmask = setmask;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			ret = msg->op.input.oldmask;
			kn_unlock(&v->asyncport->lock);
			return ret;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
