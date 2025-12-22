#include <stdio.h>
#include <stdlib.h>
#include "test.h"
#include "dbg.h"

int main(int argc, char **argv)
{
	int i;
	int numIter = 10;
		
	if (argc > 1)
		numIter = atoi(argv[1]);
	
	set_debug_level(15);
	
	dprintf(10, "Original number = %d\n", get_number());
	dprintf(10, "Address = %p (%d)\n", get_number_ref(), *get_number_ref());
	dprintf(10, "Code = %p\n", get_func_ref());
	
	for (i = 0; i < numIter; i++)
	{
		set_number(i);
		printf("number = %d\n", get_number());
	}
	
	dprintf(10, "Address = %p (%d)\n", get_number_ref(), *get_number_ref());
}
