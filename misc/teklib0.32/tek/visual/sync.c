
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVSync(TAPTR visual)
**
**	sync context
*/

TVOID TVSync(TAPTR visual)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_SYNC;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);
			return;
		}
		TWaitPort(v->asyncport);		/* wait for free node */
	}
}
