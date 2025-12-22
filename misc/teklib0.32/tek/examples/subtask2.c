
/*
**	tek/examples/subtask2.c
**
**	demonstrates how to create a child task
**	that can be passed to another task.
*/

#include <stdio.h>
#include <tek/exec.h>

void subfunc2(TAPTR task)
{
	/* 
	**	keep this task busy with something time-consuming,
	**	e.g. random allocating from its heap MMU
	*/
	
	TINT seed = TGetRandomSeed(task);
	TAPTR *slots = TTaskAlloc0(task, 100 * sizeof(TAPTR));
	if (slots)
	{
		do
		{
			TUINT j, size;
			j = (seed = TGetRandom(seed)) % 100;
			if (slots[j])
			{
				TMemFill(slots[j], TTaskGetSize(task, slots[j]), 0x55);
				TTaskFree(task, slots[j]);
				slots[j] = TNULL;
			}
			else
			{
				size = 100 + ((seed = TGetRandom(seed)) % (1000-100));
				slots[j] = TTaskAlloc(task, size);
			}
	
		} while (!(TSetSignal(task, 0, 0) & TTASK_SIG_ABORT));
	}

	TWait(task, TTASK_SIG_ABORT);
}



TBOOL subinit1(TAPTR task)
{
	TAPTR *data = TTaskGetData(task);

	/* 
	**	let this task's init function create another task for us
	**	(and succeed only if creation was successful)
	*/

	return (TBOOL) (*data = TCreateTask(task, subfunc2, TNULL));
}



int main(int argc, char **argv)
{
	TAPTR basetask;
	basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TAPTR subtask;
		TAPTR subtask2;
		TTAGITEM tags[3];

		TInitTags(tags);
		TAddTag(tags, TTask_InitFunc, subinit1);
		TAddTag(tags, TTask_UserData, &subtask2);
		
		subtask = TCreateTask(basetask, TNULL, tags);
		if (subtask)
		{
			/*
			**	subtask's sole purpose was to create subtask2.
			**	we can safely destroy subtask.
			*/

			TDestroy(subtask);
			printf("subtask1 destroyed\n"); fflush(NULL);

			/* 
			**	subtask2 is still living. it is not
			**	dependent from subtask
			*/

			TTimeDelayF(basetask, 5);

			TSignal(subtask2, TTASK_SIG_ABORT);		
			TDestroy(subtask2);
			printf("subtask2 destroyed\n"); fflush(NULL);
		}
		TDestroy(basetask);
	}

	printf("all done\n"); fflush(NULL);
	return 0;
}

