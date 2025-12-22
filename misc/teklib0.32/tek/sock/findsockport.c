
/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	msgport = TFindSockPort(TAPTR task, TSTRPTR ipname, TUINT16 port, TTAGITEM *tags)
**
**	return proxy to a remote messageport.
**
**	task	- current context
**	ipname	- ip name string (if TNULL, localmachine will be contacted)
**	port    - port number on which the remote messageport is expected
**
**	tags:
**		TSock_ReplyTimeout, TTIME *	
**			timeout for replies. default: 10 seconds.
**			by current definitions, the socket will immediately fall into
**			a 'broken' state and reject further communication with a remote
**			partner when a reply timeouts.
*/

#include "tek/sock.h"
#include "tek/debug.h"
#include "tek/kn/exec.h"
#include "tek/kn/sock.h"

struct clientsocktaskinitdata
{
	TSTRPTR ipname;
	TUINT16 portnr;
	TTIME replytimeout;
};

struct clientsocktaskdata
{
	knsockobj sockname;			/* remote socket name object */
	TAPTR clientsocket;			/* client socket object */
	TPORT *msgport;				/* msgport proxied */
};

static TBOOL clientsocktaskinitfunc(TTASK *task);
static TVOID clientsocktaskfunc(TTASK *task);
static TINT destroyproxymsgport(TPORT *msgport);


TPORT *TFindSockPort(TAPTR task, TSTRPTR ipname, TUINT16 portnr, TTAGITEM *tags)
{
	TTASK *proxytask;

	struct clientsocktaskinitdata initdata;
	TTAGITEM tasktags[4];

	TTIME *replytime = (TTIME *) TGetTagValue(TSock_ReplyTimeout, TNULL, tags);

	initdata.ipname = ipname;
	initdata.portnr = portnr;
	
	if (replytime)
	{
		initdata.replytimeout.sec = replytime->sec;
		initdata.replytimeout.usec = replytime->usec;
	}
	else
	{
		initdata.replytimeout.sec = 32;
		initdata.replytimeout.usec = 0;
	}

	tasktags[0].tag = TTask_InitFunc;
	tasktags[0].value = (TTAG) clientsocktaskinitfunc;
	tasktags[1].tag = TTask_UserData;
	tasktags[1].value = (TTAG) &initdata;
	tasktags[2].tag = TTask_CreatePort;
	tasktags[2].value = (TTAG) TFALSE;
	tasktags[3].tag = TTAG_DONE;
	
	proxytask = TCreateTask(task, (TTASKFUNC) clientsocktaskfunc, tasktags);
	if (proxytask)
	{
		TPORT *msgport = ((struct clientsocktaskdata *) proxytask->userdata)->msgport;
		msgport->proxy = proxytask;
		return msgport;
	}

	return TNULL;
}



static TBOOL clientsocktaskinitfunc(TTASK *task)
{
	struct clientsocktaskinitdata *initdata = TTaskGetData(task);
	struct clientsocktaskdata *data = TTaskAlloc(task, sizeof(struct clientsocktaskdata));
	if (data)
	{
		data->msgport = TCreatePort(task, TNULL);
		if (data->msgport)
		{
			if (kn_initsockname(&data->sockname, initdata->ipname ? initdata->ipname : "127.0.0.1", initdata->portnr))
			{
				data->clientsocket = kn_createclientsock(&task->heapmmu, &data->sockname, &task->timer, &initdata->replytimeout);
				if (data->clientsocket)
				{
					/*	overwrite msgport's destructor - see annotations below */
					data->msgport->handle.destroyfunc = (TDESTROYFUNC) destroyproxymsgport;
					task->userdata = data;
					return TTRUE;
				}
				kn_destroysockname(&data->sockname);
			}
			TDestroy(data->msgport);
		}
		TTaskFree(task, data);
	}
	return TFALSE;
}



/* 
**	client task
*/

static TVOID clientsocktaskfunc(TTASK *task)
{
	struct clientsocktaskdata *data = task->userdata;
	TMSG *msg;
	TLIST pendlist;
	TUINT signals;

	TInitList(&pendlist);

	do
	{
		kn_waitclientsock(data->clientsocket, &task->sigevent);
		
		while ((msg = kn_getclientsockmsg(data->clientsocket)))
		{
			/* reply msg to respective replyport */

			if (msg->replyport)
			{
				msg->status |= TMSG_STATUS_PENDING;
				kn_lock(&msg->replyport->lock);
				TAddTail(&msg->replyport->msglist, (TNODE *) msg);
				TSignal(msg->replyport->sigtask, msg->replyport->signal);
				kn_unlock(&msg->replyport->lock);
			}
			else
			{
				TMMUFreeHandle(msg);
			}
		}

		while ((msg = (TMSG *) TRemHead(&pendlist)))
		{
			if (!kn_putclientsockmsg(data->clientsocket, msg))
			{
				TAddHead(&pendlist, (TNODE *) msg);				/* can be sent later */
				goto cst_skip;
			}
		}

		while ((msg = TGetMsg(data->msgport)))
		{
			if (!kn_putclientsockmsg(data->clientsocket, msg - 1))
			{
				TAddTail(&pendlist, (TNODE *) (msg - 1));		/* can be sent later */
				break;
			}
		}

cst_skip:

		signals = TSetSignal(task, 0, data->msgport->signal);

	} while (!(signals & TTASK_SIG_ABORT));


	if (!TListEmpty(&pendlist))
	{
		tdbprintf(10, "*** clientsocktaskfunc: shutting down proxy - warning: pendlist not empty\n");
	}

	kn_destroyclientsock(data->clientsocket);
	kn_destroysockname(&data->sockname);

	TDestroy(data->msgport);		/* actually destroy the msgport, this time with its regular destructor */

	TTaskFree(task, data);			/* not really needed - task allocations will be freed on task exit */
}



static TINT destroyproxymsgport(TPORT *msgport)
{
	/*
	**	this will cause this msgport to be deleted, because
	**	it's owned by its proxy. so deleting the proxy
	**	will destroy this messageport as well.
	*/

	TAPTR proxy = msgport->proxy;

	tdbprintf(2,"*** destroyproxymsgport: enter\n");

	msgport->proxy = TNULL;
	msgport->handle.destroyfunc = (TDESTROYFUNC) TDestroyPort;	/* overwrite with regular destructor */
	TSignal(proxy, TTASK_SIG_ABORT);
	TDestroy(proxy);

	tdbprintf(2,"*** destroyproxymsgport: done\n");

	return 0;
}

