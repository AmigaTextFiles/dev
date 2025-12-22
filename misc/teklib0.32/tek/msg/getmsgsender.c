
#include "tek/msg.h"
#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TSTRPTR sender = TGetMsgSender(TAPTR msg)
**
**	get message sender host.
*/

TSTRPTR TGetMsgSender(TAPTR mem)
{
	if (mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;
		if (msg->sender)
		{
			return kn_getsockname(((knnetmsg *) msg->sender)->sendername);
		}
	}
	return TNULL;
}
