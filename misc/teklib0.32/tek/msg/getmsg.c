
#include "tek/msg.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TGetMsg(TPORT *msgport)
**
**	get next pending message from messageport.
**
*/

TAPTR TGetMsg(TPORT *msgport)
{
	if (msgport)
	{
		TMSG *msg;
		kn_lock(&msgport->lock);
		msg = (TMSG *) TRemHead(&msgport->msglist);
		kn_unlock(&msgport->lock);
		if (msg)
		{
			if (!(msg->status & TMSG_STATUS_PENDING))
			{
				tdbprintf(2, "*** TEKLIB TGetMsg: getting message with PENDING bit not set\n");
			}

			msg->status &= ~TMSG_STATUS_PENDING;
			return (TAPTR) (msg + 1);
		}
	}
	return TNULL;
}
