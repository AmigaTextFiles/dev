
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TDestroyPort(TAPTR msgport)
**
**	destroy message port. this is a private function, there
**	should be no need for the user to call it directly.
*/

TINT TDestroyPort(TAPTR port)
{
	TPORT *msgport = (TPORT *) port;
	if (msgport->proxy)
	{
		/*
		**	destroy a port proxy which was created in the replyport proxy scenario.
		**	port proxies created in the msgport proxy scenario are destroyed with
		**	a different destructor - see TFindSockPort()
		*/

		TSignal(msgport->proxy, TTASK_SIG_ABORT);
		TDestroy(msgport->proxy);
	}

	TFreeSignal(msgport->sigtask, msgport->signal);
	kn_destroylock(&msgport->lock);
	TMMUFreeHandle(msgport);
	return 0;
}
