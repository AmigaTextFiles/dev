
/*
**	tek/examples/randomtest.c
**	random quality test
*/

#include <stdio.h>
#include <math.h>
#include <tek/exec.h>

#define NUMSEED		10000
#define NUMRAND		1000
#define NUMSLOT		100

int main(int argc, char **argv)
{
	TAPTR basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TINT *slots = TTaskAlloc0(basetask, 4 * 65536);
		if (slots)
		{
			TTIME t1, t2;
			TUINT i, j;
			TINT seed;
			TDOUBLE d, deviation = 0;

			printf("getting %d random numbers each from %d seed values\n", NUMRAND, NUMSEED);
			fflush(NULL);
			
			TTimeQuery(basetask, &t1);
			
			for (i = 0; i < NUMSEED; ++i)
			{
				seed = TGetRandomSeed(basetask);
				for (j = 0; j < NUMRAND; ++j)
				{
					seed = TGetRandom(seed);
					slots[seed%NUMSLOT]++;
				}
			}

			TTimeQuery(basetask, &t2);
			
			printf("all done. time elapsed: %.4fs\n", TTIMETOF(&t2)-TTIMETOF(&t1));
			fflush(NULL);
			
			for (i = 0; i < NUMSLOT; ++i)
			{
				d = (TDOUBLE) NUMRAND / (TDOUBLE) NUMSLOT * (TDOUBLE) NUMSEED - (TDOUBLE) slots[i];
				deviation += sqrt(d * d);
			}
			
			printf("deviation from perfect randomness: %.5f\n", (TFLOAT) deviation / (TFLOAT) NUMSLOT);
			fflush(NULL);

			TTaskFree(basetask, slots);			
		}
		TDestroy(basetask);
	}
	
	return 0;
}
