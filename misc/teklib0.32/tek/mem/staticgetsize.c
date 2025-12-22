
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TStaticGetSize(TMEMHEAD *head, TAPTR mem)
**
**	get size of a static allocation.
**
*/

TUINT TStaticGetSize(TMEMHEAD *head, TAPTR mem)
{
	if (mem && head)
	{
		TMEMNODE *p = (TMEMNODE *) ((TUINT8 *) mem - head->memnodesize);
		return p->size - p->free;
	}
	return 0;
}
