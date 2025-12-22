
/*
**	tek/examples/subtask.c
**
**	simple multitasking and messaging test.
**	pass messages to a subtask, let it calculate something,
**	and send replies back to the sender
*/

#include <stdio.h>
#include <tek/msg.h>


void calcfunc(TAPTR task)
{
	TUINT signals;
	TPORT *port = TTaskPort(task);
	TUINT *msg;

	do
	{
		while ((msg = TGetMsg(port)))
		{
			*msg *= 2;
			TReplyMsg(msg);
		}
	
		signals = TWait(task, TTASK_SIG_ABORT | port->signal);
	
	} while (!(signals & TTASK_SIG_ABORT));
}


int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TAPTR subtask = TCreateTask(basetask, calcfunc, TNULL);
		if (subtask)
		{
			TPORT *port = TTaskPort(basetask);
			TPORT *subport = TTaskPort(subtask);
			TINT i;
			TTIME t1, t2;
			TUINT *msg;

			msg = TTaskAllocMsg(basetask, sizeof(TUINT));
			if (msg)
			{
				*msg = 1;
	
				TTimeQuery(basetask, &t1);

				for (i = 0; i < 20; ++i)
				{
					TPutReplyMsg(subport, port, msg);
					TWaitPort(port);
					TGetMsg(port);
					printf("%d\n", *msg); fflush(NULL);
				}
					
				TTimeQuery(basetask, &t2);
	
				printf("time elapsed: %.5fs\n", TTIMETOF(&t2) - TTIMETOF(&t1)); fflush(NULL);

				TFreeMsg(msg);
			}
	
			TSignal(subtask, TTASK_SIG_ABORT);
			
			TDestroy(subtask);
		}
		
		TDestroy(basetask);
	}
	
	return 0;
}
