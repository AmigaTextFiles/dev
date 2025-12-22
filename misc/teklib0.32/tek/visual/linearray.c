
#include "tek/visual.h"
#include "tek/debug.h"
#include "tek/kn/visual.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TVLineArray(TAPTR visual, TINT *array, TINT num, TVPEN pen)
**
**	draw line array
*/

TVOID TVLineArray(TAPTR visual, TINT *array, TINT num, TVPEN pen)
{
	TVISUAL *v = (TVISUAL *) visual;
	TDRAWMSG *msg;

	for (;;)
	{
		if ((msg = TGetMsg(v->asyncport)))
		{
			msg->jobcode = TVJOB_LINEARRAY;
			msg->op.array.array = array;
			msg->op.array.num = num;
			msg->op.array.pen = pen;

			TSendMsg(v->parenttask, TTaskPort(v->task), msg);			

			kn_lock(&v->asyncport->lock);
			TAddTail(&v->asyncport->msglist, (TNODE *) (((TMSG *) msg) - 1));
			kn_unlock(&v->asyncport->lock);
			return;
		}
		TWaitPort(v->asyncport);
	}
}
