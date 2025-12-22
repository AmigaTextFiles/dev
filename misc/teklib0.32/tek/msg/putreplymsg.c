
#include "tek/msg.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TPutReplyMsg(TPORT *msgport, TPORT *replyport, TAPTR msg)
**
**	put msg to msgport, with a reply expected at replyport, reliable
**
**	replyport may be NULL
**
*/

TVOID TPutReplyMsg(TPORT *msgport, TPORT *replyport, TAPTR mem)
{
	if (msgport && mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;

		msg->replyport = replyport;
		msg->sender = TNULL;				/* sender is local address space */

		msg->status = TMSG_STATUS_SENT | TMSG_STATUS_PENDING;

		kn_lock(&msgport->lock);

		TAddTail(&msgport->msglist, (TNODE *) msg);
		TSignal(msgport->sigtask, msgport->signal);

		kn_unlock(&msgport->lock);
	}
}
