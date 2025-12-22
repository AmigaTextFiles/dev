
#include "tek/msg.h"
#include "tek/kn/exec.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TSendMsg(TAPTR task, TPORT *msgport, TAPTR msg)
**
**	send message, blocking. returns either the ack'd or replied
**	message, or TNULL for failure.
**
*/

TAPTR TSendMsg(TAPTR task, TPORT *msgport, TAPTR mem)
{
	TAPTR reply = TNULL;

	if (task && msgport && mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;

		msg->replyport = TTaskSyncPort(task);				/* replyport is task's syncport */
		msg->sender = TNULL;								/* sender is local address space */

		msg->status = TMSG_STATUS_SENT | TMSG_STATUS_PENDING;

		kn_lock(&msgport->lock);
		TAddTail(&msgport->msglist, (TNODE *) msg);
		TSignal(msgport->sigtask, msgport->signal);
		kn_unlock(&msgport->lock);

		for (;;)
		{
			TWait(task, TTaskSyncPort(task)->signal);
			reply = TGetMsg(TTaskSyncPort(task));
			if (reply)
			{
				break;
			}
			tdbprintf(10,"TEKLIB TSendMsg(): WARNING: got signal on syncport with no message\n");
		}

		if (reply != mem)
		{
			tdbprintf(40,"TEKLIB TSendMsg(): ALERT: message returned was not sent\n");
		}

		if (TGetMsgStatus(reply) == TMSG_STATUS_FAILED)
		{
			reply = TNULL;			/* indicate failure */
		}
	}

	return reply;
}
