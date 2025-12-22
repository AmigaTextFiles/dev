
/*
**	socktask test -
**	kill a running server.
**
**	see also:
**		client.c
**		server.c
*/

#include <stdio.h>
#include <tek/exec.h>
#include <tek/sock.h>

#define MSGSIZE	100

int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TPORT *msgport = TFindSockPort(basetask, "127.0.0.1", 44444, TNULL);
		if (msgport)
		{
			TSTRPTR msg = TTaskAllocMsg(basetask, MSGSIZE);
			if (msg)
			{
				sprintf(msg, "KILL!");
				TPutReplyMsg(msgport, TTaskPort(basetask), msg);
				TWaitPort(TTaskPort(basetask));
				TGetMsg(TTaskPort(basetask));
				TFreeMsg(msg);
			}
			TDestroy(msgport);
		}
		TDestroy(basetask);
	}

	return 0;
}
