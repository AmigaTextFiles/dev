
#include "tek/kn/elate/exec.h"

extern int kn_mem_size(void *)
	__ELATE_QCALL__(("qcall sys/kn/mem/size"));

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT kn_getsize(TAPTR mem)
**
**	get size of an allocation from kernel.
**
*/

TUINT kn_getsize(TAPTR mem)
{
	return (TUINT) kn_mem_size(mem);
}
