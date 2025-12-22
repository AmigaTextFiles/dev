
/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TRemSockPort(TPORT *msgport)
**
**	remove a messageport from socket
**
*/

#include "tek/msg.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

TVOID TRemSockPort(TPORT *msgport)
{
	if (msgport)
	{
		TAPTR proxy;

		kn_lock(&msgport->lock);

		proxy = msgport->proxy;
		msgport->proxy = TNULL;

		kn_unlock(&msgport->lock);

		if (proxy)
		{
			TSignal(proxy, TTASK_SIG_ABORT);
			TDestroy(proxy);
		}
	}
}
