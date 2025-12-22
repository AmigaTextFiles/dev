
/*
**	tek/examples/timetest.c
**	timer accuracy test
*/

#include <stdio.h>
#include <math.h>
#include <tek/exec.h>

int main(int argc, char **argv)
{
	TAPTR basetask;

	basetask = TCreateTask(TNULL, TNULL, TNULL);
	if (basetask)
	{
		TTIME t1, t2, t3;
		TFLOAT ex, el;
		
		TFTOTIME(1.234567, &t2)

		TTimeQuery(basetask, &t1);
		TTimeDelay(basetask, &t2);
		TTimeQuery(basetask, &t3);

		ex = TTIMETOF(&t2);
		el = TTIMETOF(&t3) - TTIMETOF(&t1);

		printf("time expected  : %.6fs\n", ex);
		printf("time elapsed   : %.6fs\n", el);
		printf("time difference: %.6fs\n", el-ex);
		printf("time divergence: %.6f%%\n", (el-ex)*100.0f/ex);
		fflush(NULL);
		
		TDestroy(basetask);
	}
	
	return 0;
}
