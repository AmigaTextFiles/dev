
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TMSGPORT *TCreatePort(TAPTR task, TTAGITEM *tags)
**
**	create message port.
**
**	tags:
**		TTask_MMU		- mmu used for allocating the message port. default: task's heap mmu.
**
*/

TPORT *TCreatePort(TAPTR task, TTAGITEM *tags)
{
	if (task)
	{
		TAPTR mmu = TGetTagValue(TTask_MMU, &((TTASK *) task)->heapmmu, tags);
		TPORT *msgport = TMMUAllocHandle(mmu, (TDESTROYFUNC) TDestroyPort, sizeof(TPORT));
		if (msgport)
		{
			msgport->signal = TAllocSignal(task, 0);
			if (msgport->signal)
			{
				if (kn_initlock(&msgport->lock))
				{
					msgport->proxy = TNULL;
					msgport->sigtask = task;
					TInitList(&msgport->msglist);
					return msgport;
				}
				TFreeSignal(task, msgport->signal);
			}
			TMMUFreeHandle(msgport);
		}
	}
	return TNULL;
}
