
#include "tek/exec.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TWaitPort(TPORT *msgport)
**
**	wait for a message-port to be non-empty.
**
*/

TVOID TWaitPort(TPORT *msgport)
{
	TBOOL isempty;

	if (msgport)
	{
		for (;;)
		{
			kn_lock(&msgport->lock);

			isempty = TListEmpty(&msgport->msglist);

			kn_unlock(&msgport->lock);

			if (!isempty)
			{
				return;
			}
			
			TWait(msgport->sigtask, msgport->signal);
		}
	}
}
