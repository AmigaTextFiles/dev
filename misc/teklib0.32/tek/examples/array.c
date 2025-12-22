
/*
**	tek/examples/array.c
**
**	demonstrates brute dynamic array resizing.
**
**	in this example, we put a dynamic array on top of a reallocatable
**	pooled memory manager, with a prefetch ratio of 2:1. this allows
**	rapidly fast array resizing - independent from the underlying kernel's
**	realloc() efficiency.
*/

#include <stdio.h>
#include <stdlib.h>

#include <tek/exec.h>
#include <tek/array.h>


#define	NUM 2000000
#define DYNAMICGROWTH TTRUE


int main(int argc, char **argv)
{
	TAPTR task = TCreateTask(TNULL, TNULL, TNULL);
	if (task)
	{
		TMMU mmu;
		TAPTR pool = TCreatePool(TNULL, 256, 128, TNULL);		/* initial prefetch ratio = chunksize/threshold = 2 */
		if (pool)
		{
			if (TInitMMU(&mmu, pool, TMMUT_Pooled, TNULL))
			{
				TUINT *array = TCreateArray(&mmu, sizeof(TUINT), 0, TNULL);
				if (array)
				{
					TINT i;
					TTIME t1,t2,t3,t4;
					TBOOL success = TFALSE;	
	
					printf("running %d array growth iterations...\n", NUM); fflush(NULL);
	
					TTimeQuery(task, &t1);
		
					for (i = 0; i < NUM; ++i)
					{
						if (TArraySetLen((TAPTR) &array, i + 1))
						{
							array[i] = i;
						}
					}	
		
					TTimeQuery(task, &t2);
		
					printf("done. time elapsed: %.3fs.\n", TTIMETOF(&t2) - TTIMETOF(&t1)); fflush(NULL);
	
		
		
					if (TArrayValid(array))
					{
						TUINT l = TArrayGetLen(array);
				
						printf("array found in valid state. checking integrity...\n"); fflush(NULL);
				
						if (l == NUM)
						{
							for (i = 0; i < NUM; ++i)
							{
								if (array[i] != i)
								{
									printf("ALERT: array corrupt!\n");
									break;
								}
							}
							if (i == NUM)
							{
								printf("all right!\n");
								success = TTRUE;
							}
						}
						else
						{
							printf("array has incorrect size!\n");
						}
					}
					else
					{
						printf("array found in invalid state!\n");
					}
		
		
		
		
		
					if (success)
					{
						printf("shrinking array (%d iterations)...\n", NUM); fflush(NULL);
		
		
						TTimeQuery(task, &t3);
				
		
						for (i = NUM; i >= 0; --i)
						{
							TArraySetLen((TAPTR) &array, i);
						}	
		
		
						TTimeQuery(task, &t4);
		
				
						printf("done. time elapsed: %.3fs. checking integrity...\n", TTIMETOF(&t4) - TTIMETOF(&t3)); fflush(NULL);
		
						if (TArrayValid(array) && TArrayGetLen(array) == 0)
						{
							printf("all right!\n");
						}
						else
						{
							printf("array found in invalid state!\n");
						}
					}
				
		
					TDestroyArray(array);		
				}
				TDestroy(&mmu);
			}
			TDestroy(pool);
		}
		
		TDestroy(task);
	}

	return 0;
}
