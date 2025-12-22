
#include "tek/msg.h"
#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT numatt = TGetMsgAttrs(TAPTR msg, TTAGITEM *tags)
**
**	get message attributes.
*/

TUINT TGetMsgAttrs(TAPTR mem, TTAGITEM *tags)
{
	TUINT numatt = 0;

	if (mem)
	{
		TMSG *msg = ((TMSG *) mem) - 1;
		TAPTR *attp;
		
		attp = (TAPTR *) TGetTagValue(TMsg_Size, TNULL, tags);
		if (attp)
		{
			*attp = (TAPTR) (msg->size - sizeof(TMSG));
			numatt++;
		}

		attp = (TAPTR *) TGetTagValue(TMsg_Status, TNULL, tags);
		if (attp)
		{
			*attp = (TAPTR) msg->status;
			numatt++;
		}

		attp = (TAPTR *) TGetTagValue(TMsg_Sender, TNULL, tags);
		if (attp)
		{
			if (msg->sender)
			{
				*attp = (TAPTR) ((knnetmsg *) msg->sender)->symbolicname;		/* combined IP:port name string */
			}
			else
			{
				*attp = TNULL;
			}
			numatt++;
		}

		attp = (TAPTR *) TGetTagValue(TMsg_SenderHost, TNULL, tags);
		if (attp)
		{
			if (msg->sender)
			{
				*attp = (TAPTR) kn_getsockname(((knnetmsg *) msg->sender)->sendername);		/* host IP string */
			}
			else
			{
				*attp = TNULL;
			}
			numatt++;
		}

		attp = (TAPTR *) TGetTagValue(TMsg_SenderPort, TNULL, tags);
		if (attp)
		{
			if (msg->sender)
			{
				*attp = (TAPTR) ((TUINT) kn_getsockport(((knnetmsg *) msg->sender)->sendername));	/* port nr. */
			}
			else
			{
				*attp = (TAPTR) 0xffffffff;
			}
			numatt++;
		}
	}

	return numatt;
}
