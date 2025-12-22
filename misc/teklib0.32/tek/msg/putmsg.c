
#include "tek/msg.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TPutMsg(TPORT *msgport, TAPTR msg)
**
**	put one-way msg to msgport, unreliable
**
*/

TVOID TPutMsg(TPORT *msgport, TAPTR mem)
{
	if (msgport && mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;

		msg->replyport = TNULL;
		msg->sender = TNULL;				/* sender is local address space */

		msg->status = TMSG_STATUS_SENT | TMSG_STATUS_PENDING;

		kn_lock(&msgport->lock);

		TAddTail(&msgport->msglist, (TNODE *) msg);
		TSignal(msgport->sigtask, msgport->signal);

		kn_unlock(&msgport->lock);
	}
}
