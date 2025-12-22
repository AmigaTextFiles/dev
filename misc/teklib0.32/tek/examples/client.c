
/*
**	tek/examples/client.c
**
**	simple socket message client
**
**	see also:
**		server.c
**		killserver.c
*/

#include <stdio.h>
#include <tek/msg.h>
#include <tek/sock.h>

#define	NUMMSG	1000
#define MSGSIZE	100

int main(int argc, char **argv)
{
	TAPTR basetask;

	basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TPORT *replyport = TTaskPort(basetask);
		TPORT *msgport = TFindSockPort(basetask, "127.0.0.1", 44444, TNULL);
		if (msgport)
		{
			char *msg, *replymsg;
			int numsent = 0, numrecvd = 0, numfailed = 0;
			TTIME t1, t2;
	
			TSTRPTR sendername;
			TUINT msgstatus;
			TTAGITEM msgattrs[3];
			
			TInitTags(msgattrs);
			TAddTag(msgattrs, TMsg_Sender, &sendername);
			TAddTag(msgattrs, TMsg_Status, &msgstatus);
			
			printf("sending %d messages to server and awaiting %d replies (msgsize: %d bytes)\n", NUMMSG, NUMMSG, MSGSIZE);
			
			TTimeQuery(basetask, &t1);
			
			do
			{
				if (numsent < NUMMSG)
				{
					msg = TTaskAllocMsg(basetask, MSGSIZE);
					if (msg)
					{
						sprintf(msg, "hallo teklib");
						TPutReplyMsg(msgport, replyport, msg);
						numsent++;
					}
				}
				else
				{
					TWaitPort(replyport);
				}
				
				while ((replymsg = TGetMsg(replyport)))
				{
					numrecvd++;
	
					TGetMsgAttrs(replymsg, msgattrs);
	
					if (msgstatus == TMSG_STATUS_FAILED)
					{
						numfailed++;
					}
	
					if (!((numsent+numrecvd+numfailed) & 0x1f))
					{
						printf("\rsent: %d - recvd: %d - failed: %d - sender: %s", numsent, numrecvd, numfailed, sendername); 
					}
					fflush(NULL);

					TFreeMsg(replymsg);
				}
				
	
			} while (numrecvd < NUMMSG);
	
			TTimeQuery(basetask, &t2);
	
			printf("\rsent: %d - recvd: %d - failed: %d\n", numsent, numrecvd, numfailed);
			
			printf("all done. time elapsed: %.4fs\n", TTIMETOF(&t2) - TTIMETOF(&t1));
		}

		TDestroy(msgport);
		TDestroy(basetask);
	}

	printf("good bye\n");

	return 0;
}
