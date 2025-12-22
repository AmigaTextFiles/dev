
/*
**	tek/examples/server.c
**
**	asynchronous server example
**
**	this server will echo incoming messages to the sender.
**	it will shutdown when a timout of 30 minutes has expired,
**	or when it receives a "KILL!" message.
**
**	see also:
**		client.c
**		killserver.c
**
*/

#include <stdio.h>
#include <string.h>
#include <tek/msg.h>
#include <tek/sock.h>

#define	SIG_CHILD		0x80000000		/* define a user signal for child termination */
#define TIMEOUT_SEC		30*60			/* timeout in seconds */

void servfunc(TAPTR task)
{
	TTAGITEM tags[2];
	TTIME idletimeout;

	TAPTR parenttask = TTaskGetData(task);			/* get parent task */
	TPORT *serverport = TTaskPort(task);			/* get own port */

	TFTOTIME(5, &idletimeout);
	TInitTags(tags);
	TAddTag(tags, TSock_IdleTimeout, &idletimeout);

	if (TAddSockPort(serverport, 44444, tags))		/* add msg port to network */
	{
		TUINT signals, nummsg = 0;
		TSTRPTR msg;

		TSTRPTR sendername;
		TUINT msgsize;
		TTAGITEM msgattrs[3];
		
		TInitTags(msgattrs);
		TAddTag(msgattrs, TMsg_Sender, &sendername);
		TAddTag(msgattrs, TMsg_Size, &msgsize);

		do
		{
			signals = TWait(task, serverport->signal | TTASK_SIG_ABORT);

			while ((msg = TGetMsg(serverport)))
			{
				++nummsg;
				if (!(nummsg & 0x1f))
				{
					TGetMsgAttrs(msg, msgattrs);
					/*printf("\rmessage %d: %s from %s (size: %d)", nummsg, msg, sendername, msgsize);
					fflush(NULL);*/
				}

				if (!strcmp(msg, "KILL!"))
				{
					TSignal(parenttask, SIG_CHILD);
				}

				TReplyMsg(msg);
			}

		} while (!(signals & TTASK_SIG_ABORT));
	}
}

int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TAPTR subtask;
		TTAGITEM tags[2];

		TInitTags(tags);
		TAddTag(tags, TTask_UserData, basetask);

		subtask = TCreateTask(basetask, servfunc, tags);
		if (subtask)
		{
			TTIME timeout;
			TFTOTIME(TIMEOUT_SEC, &timeout);

			printf("server started.\n");

			if (TTimedWait(basetask, SIG_CHILD, &timeout) == 0)
			{
				printf("timeout expired - shutting down\n");
			}
			else
			{
				printf("server got KILL! message - shutting down\n");
			}

			TSignal(subtask, TTASK_SIG_ABORT);
			TDestroy(subtask);
		}
		TDestroy(basetask);
	}
	return 0;
}
