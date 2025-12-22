
#include "tek/kn/elate/exec.h"
#include <stdlib.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR kernel_alloc0(TUINT size)
**
**	get blank memory from kernel.
**
*/

TAPTR kernel_alloc0(TUINT size)
{
	TAPTR mem;

	size = (size + 3) & ~3;

	mem = kn_mem_allocdata(size);

	if (mem)
	{	
		kn_memset32(mem, size, 0);
	}

	return mem;
}
