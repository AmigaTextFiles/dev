
/*
**	tek/examples/heaptest.c
**	heap memory test
*/

#include <stdio.h>
#include <tek/exec.h>
#include <tek/sock.h>

#define MAXTASKS	10
#define NUMALLOC	100000
#define NUMSLOTS	100
#define MAXBYTES	1000
#define MINBYTES	100

void clientfunc(TAPTR task)
{
	TAPTR parenttask = TTaskBaseTask(task);
	TINT seed = TGetRandomSeed(task);

	TAPTR *slots = TTaskAlloc0(task, NUMSLOTS * sizeof(TAPTR));
	if (slots)
	{
		TUINT i, j, size;
		for (i = 0; i < NUMALLOC; ++i)
		{
			j = (seed = TGetRandom(seed)) % NUMSLOTS;
			if (slots[j])
			{
				TMemFill(slots[j], TTaskGetSize(parenttask, slots[j]), 0x55);
				TTaskFree(parenttask, slots[j]);
				slots[j] = TNULL;
			}
			else
			{
				size = MINBYTES + ((seed = TGetRandom(seed)) % (MAXBYTES-MINBYTES));
				slots[j] = TTaskAlloc(parenttask, size);
			}
		}

		for (i = 0; i < NUMSLOTS; ++i)
		{
			TTaskFree(parenttask, slots[i]);
		}
		
		TTaskFree(task, slots);
	}
}



int main(int argc, char **argv)
{
	TAPTR basetask;

	basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TTIME t1, t2;
		TAPTR tasks[MAXTASKS];
		int i, j;
		
		printf("creating %d tasks each allocating %d times from parent heap MMU\n", MAXTASKS, NUMALLOC);
		fflush(NULL);

		TTimeQuery(basetask, &t1);

		for (i = 0, j = 0; i < MAXTASKS; ++i)
		{
			tasks[i] = TCreateTask(basetask, clientfunc, TNULL);
			if (tasks[i]) j++;
		}

		for (i = 0; i < MAXTASKS; ++i)
		{
			TDestroy(tasks[i]);
		}

		TTimeQuery(basetask, &t2);
		
		printf("all done. successfully created %d tasks. time elapsed: %.4fs\n", j, TTIMETOF(&t2) - TTIMETOF(&t1));
		fflush(NULL);

		TDestroy(basetask);
	}

	return 0;
}
