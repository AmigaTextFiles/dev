
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TPoolFree(TAPTR mp, TAPTR mem)
**
**	return allocation to a pool.
**
*/

TVOID TPoolFree(TAPTR mp, TAPTR mem)
{
	if (mp && mem)
	{
		TMEMPOOL *pool = (TMEMPOOL *) mp;
		TPOOLNODE **mem2 = (TPOOLNODE **) mem;
		TPOOLNODE *pn = *(--mem2);
		
		TStaticFree(&pn->memhead, mem2);

		if (pn->memhead.freesize == pn->numbytes)
		{
			TRemove((TNODE *) pn);
			TMMUFree(pool->handle.mmu, (TAPTR) pn);
		}
	}
}
