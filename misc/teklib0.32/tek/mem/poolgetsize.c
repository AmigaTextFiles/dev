
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TPoolGetSize(TAPTR mp, TAPTR mem)
**
**	get size of an allocation from a pool.
**
*/

TUINT TPoolGetSize(TAPTR mp, TAPTR mem)
{
	if (mp && mem)
	{
		TPOOLNODE **mem2 = (TPOOLNODE **) mem;
		TPOOLNODE *pn = *(--mem2);
		return TStaticGetSize(&pn->memhead, mem2) - sizeof(TPOOLNODE *);
	}
	return 0;
}
