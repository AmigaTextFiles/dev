
#include "tek/msg.h"
#include "tek/kn/exec.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TReplyMsg(TAPTR msg)
**
**	reply a message.
**
*/

TVOID TReplyMsg(TAPTR mem)
{
	if (mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;
		TPORT *replyport = msg->replyport;

		if (replyport)
		{
			msg->status = TMSG_STATUS_REPLIED | TMSG_STATUS_PENDING;

			kn_lock(&replyport->lock);

			TAddTail(&replyport->msglist, (TNODE *) msg);
			TSignal(replyport->sigtask, replyport->signal);

			kn_unlock(&replyport->lock);
		}
		else
		{
			TMMUFreeHandle(msg);
		}
	}
}
