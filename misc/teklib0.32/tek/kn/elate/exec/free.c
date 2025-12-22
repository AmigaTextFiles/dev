
#include "tek/kn/elate/exec.h"
#include <stdlib.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_free(TAPTR mem)
**
**	return memory to the kernel.
**
*/

TVOID kn_free(TAPTR mem)
{
	kn_mem_free(mem);
}
