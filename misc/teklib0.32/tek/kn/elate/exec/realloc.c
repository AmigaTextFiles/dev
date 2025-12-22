
#include "tek/kn/exec.h"
#include <stdlib.h>

extern void *kn_mem_realloc(void *, int)
	__ELATE_QCALL__(("qcall sys/kn/mem/realloc"));

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR kn_realloc(TAPTR oldmem, TUINT newsize)
**
**	realloc kernel memory.
**
*/

TAPTR kn_realloc(TAPTR oldmem, TUINT newsize)
{
	return (TAPTR) kn_mem_realloc(oldmem, newsize);
}
