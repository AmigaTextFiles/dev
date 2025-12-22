
#include "tek/kn/elate/exec.h"
#include <stdlib.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR kn_alloc(TUINT size)
**
**	get memory from kernel.
**
*/

TAPTR kn_alloc(TUINT size)
{
	return kn_mem_allocdata(size);
}
