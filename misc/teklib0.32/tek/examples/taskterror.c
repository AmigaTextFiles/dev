
/*
**	tek/examples/taskterror.c
**	create a tree of childtasks
*/

#include <stdio.h>
#include <tek/exec.h>

#define CHILDSPERNODE	10
#define MAXTASKS		400
#define CHILDSIGREADY	0x80000000

struct shareddata
{
	TLOCK lock;
	TUINT taskcount;
};

void childfunc(TAPTR task)
{
	TAPTR childs[CHILDSPERNODE];
	struct shareddata *data;
	TTAGITEM tags[2];
	TUINT i;
	
	data = TTaskGetData(task);
	
	TInitTags(tags);
	TAddTag(tags, TTask_UserData, (TTAG) data);

	TLock(&data->lock);

	for (i = 0; i < CHILDSPERNODE; ++i)
	{	
		if (data->taskcount < MAXTASKS)
		{
			if ((childs[i] = TCreateTask(task, childfunc, tags)))
			{
				data->taskcount++;
				/*printf("\r%d tasks ", data->taskcount);
				fflush(NULL);*/
			}
			else
			{
				data->taskcount = MAXTASKS;
			}
		}
		else
		{
			childs[i] = TNULL;
		}
	}

	if (data->taskcount >= MAXTASKS)
	{
		TSignal(TTaskBaseTask(task), CHILDSIGREADY);
	}

	TUnlock(&data->lock);

	TWait(task, TTASK_SIG_ABORT);

	for (i = 0; i < CHILDSPERNODE; ++i)
	{
		if (childs[i])
		{
			TSignal(childs[i], TTASK_SIG_ABORT);
			TDestroy(childs[i]);
		}
	}
}


int main(int argc, char **argv)
{
	TAPTR basetask, subtask;

	basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		struct shareddata data;
		data.taskcount = 1;

		if (TInitLock(basetask, &data.lock, TNULL))
		{
			TTIME time1, time2, time3;
			TTAGITEM tags[2];
			
			TInitTags(tags);
			TAddTag(tags, TTask_UserData, &data);

			printf("creating a tree of %d tasks, with %d childs per node\n", MAXTASKS, CHILDSPERNODE);

			TTimeQuery(basetask, &time1);

			subtask = TCreateTask(basetask, childfunc, tags);
			if (subtask)
			{
				TWait(basetask, CHILDSIGREADY);
				TTimeQuery(basetask, &time2);
				TSignal(subtask, TTASK_SIG_ABORT);
				TDestroy(subtask);
			}

			TTimeQuery(basetask, &time3);

			printf("done. time elapsed:\n");
			printf("creating tasks:   %.4fs\n", TTIMETOF(&time2) - TTIMETOF(&time1));
			printf("destroying tasks: %.4fs\n", TTIMETOF(&time3) - TTIMETOF(&time2));

		}
		TDestroy(basetask);
	}

	return 0;
}

