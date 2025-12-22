
/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT portnr = TAddSockPort(TPORT *msgport, TUINT portnr, TTAGITEM *tags)
**
**	attach an invisible socket proxy to the given messageport,
**	making it available via TCP/IP network.
**
**	msgport - msgport to add to the network.
**	port    - port number to attach msgport to, or 0 for any port number
**
**	tags:
**		TSock_IdleTimeout, TTIME *	
**			timeout for idle connections. default: 100 seconds.
**		TSock_MaxMsgSize, TUINT
**			max msg size accepted from network, default: -1
**
**	TODO: add user msgmmu taglist argument
**
*/

#include "tek/sock.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

struct socktaskinitdata
{
	TPORT *msgport;
	TUINT portnr;				/* requested portnr, or 0 to allocate one */
	TMMU *msgmmu;
	TTIME idletimeout;
	TUINT maxmsgsize;
};

struct socktaskdata
{
	knsockobj sockname;			/* socket name object */
	TBOOL destroysockname;
	TUINT portnr;				/* actually assigned/allocated portnr */
	TAPTR serversocket;			/* server socket object */
	TPORT *msgport;				/* msgport added */
	TPORT *replyport;			/* replyport proxied */
};

static TBOOL socktaskinitfunc(TTASK *task);
static TVOID socktaskfunc(TTASK *task);


TUINT TAddSockPort(TPORT *msgport, TUINT portnr, TTAGITEM *tags)
{
	TUINT result = 0;
	if (msgport)
	{
		kn_lock(&msgport->lock);
		if (!msgport->proxy)
		{
			TTAGITEM tasktags[4];
			struct socktaskinitdata initdata;
			TTIME *idletime = (TTIME *) TGetTagValue(TSock_IdleTimeout, TNULL, tags);

			initdata.maxmsgsize = (TUINT) TGetTagValue(TSock_MaxMsgSize, (TTAG) 0xffffffff, tags);
			initdata.msgport = msgport;
			initdata.portnr = portnr;
			initdata.msgmmu = ((TTASK *) msgport->sigtask)->msgmmu;

			if (idletime)
			{
				initdata.idletimeout.sec = idletime->sec;
				initdata.idletimeout.usec = idletime->usec;
			}
			else
			{
				initdata.idletimeout.sec = 128;
				initdata.idletimeout.usec = 0;
			}
			
			tasktags[0].tag = TTask_InitFunc;
			tasktags[0].value = (TTAG) socktaskinitfunc;
			tasktags[1].tag = TTask_UserData;
			tasktags[1].value = (TTAG) &initdata;
			tasktags[2].tag = TTask_CreatePort;
			tasktags[2].value = (TTAG) TFALSE;
			tasktags[3].tag = TTAG_DONE;
			
			msgport->proxy = TCreateTask(msgport->sigtask, (TTASKFUNC) socktaskfunc, tasktags);
			if (msgport->proxy)
			{
				struct socktaskdata *data = TTaskGetData(msgport->proxy);
				result = data->portnr;
			}
		}
		kn_unlock(&msgport->lock);
	}
	return result;
}



static TBOOL socktaskinitfunc(TTASK *task)
{
	struct socktaskinitdata *initdata = TTaskGetData(task);
	struct socktaskdata *data = TTaskAlloc(task, sizeof(struct socktaskdata));
	if (data)
	{
		data->replyport = TCreatePort(task, TNULL);
		if (data->replyport)
		{
			data->serversocket = TNULL;

			if (initdata->portnr)
			{
				if ((data->destroysockname = kn_initsockname(&data->sockname, "0.0.0.0", initdata->portnr)))
				{
					data->portnr = initdata->portnr;
					data->serversocket = kn_createservsock(&task->heapmmu, initdata->msgmmu, &data->sockname, 
						initdata->maxmsgsize, &task->timer, &initdata->idletimeout, TNULL);
				}
			}
			else
			{
				data->destroysockname = TFALSE;
				data->serversocket = kn_createservsock(&task->heapmmu, initdata->msgmmu, TNULL, 
					initdata->maxmsgsize, &task->timer, &initdata->idletimeout, &data->portnr);
			}
		
			if (data->serversocket)
			{
				data->msgport = initdata->msgport;
				task->userdata = data;
				return TTRUE;
			}

			if (data->destroysockname)
			{
				kn_destroysockname(&data->sockname);
			}

			TDestroy(data->replyport);
		}
	}
	return TFALSE;
}


/* 
**	server task
*/

static TVOID socktaskfunc(TTASK *task)
{
	struct socktaskdata *data = task->userdata;
	TMSG *msg;

	do
	{
		while ((msg = kn_getservsockmsg(data->serversocket)))
		{
			/* put msg to msgport */

			msg->replyport = data->replyport;
			msg->status = TMSG_STATUS_SENT | TMSG_STATUS_PENDING;
			kn_lock(&data->msgport->lock);
			TAddTail(&data->msgport->msglist, (TNODE *) msg);
			TSignal(data->msgport->sigtask, data->msgport->signal);
			kn_unlock(&data->msgport->lock);
		}

		kn_waitservsock(data->serversocket, &task->sigevent);

		while ((msg = (TMSG *) TGetMsg(data->replyport)))
		{
			kn_returnservsockmsg(data->serversocket, msg - 1);
		}

	} while (!(TSetSignal(task, 0, data->replyport->signal) & TTASK_SIG_ABORT));

	kn_lock(&data->msgport->lock);
	kn_destroyservsock(data->serversocket);
	kn_unlock(&data->msgport->lock);

	if (data->destroysockname)
	{
		kn_destroysockname(&data->sockname);
	}

	TDestroy(data->replyport);
	
	TTaskFree(task, data);			/* not really needed - task allocations will be freed on task exit */
}

