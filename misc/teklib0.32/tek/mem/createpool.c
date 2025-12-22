
#include "tek/mem.h"
#include "tek/debug.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TCreatePool(TAPTR mmu, TUINT chunksize, TUINT thressize, TTAGITEM *tags)
**
**	create pooled allocator
**
**	TODO: implement a tag for pre-allocation size?
**
*/

static TINT destroypool(TAPTR mp);

TAPTR TCreatePool(TAPTR mmu, TUINT chunksize, TUINT thressize, TTAGITEM *tags)
{
	TUINT alignment = TALIGN_DEFAULT;
	TMEMPOOL *pool;

	if (chunksize > 0 && thressize <= chunksize)
	{	
		pool = TMMUAllocHandle(mmu, destroypool, sizeof(TMEMPOOL));
		if (pool)
		{
			TInitList(&pool->list);

			pool->align = alignment;
			pool->chunksize = (chunksize + alignment) & ~alignment;
			pool->thressize = (thressize + alignment) & ~alignment;
			pool->poolnodesize = (sizeof(TPOOLNODE) + alignment) & ~alignment;
			pool->memnodesize = (sizeof(TMEMNODE) + alignment) & ~alignment;

			pool->dyngrow = (TBOOL) TGetTagValue(TMem_DynGrow, (TTAG) TTRUE, tags);

			if (pool->dyngrow)
			{
				pool->dynfactor = (TFLOAT) pool->chunksize / (TFLOAT) pool->thressize;
			}

			return pool;
		}
	}
	
	return TNULL;
}


static TINT destroypool(TAPTR mp)
{
	TMEMPOOL *pool = (TMEMPOOL *) mp;
	TNODE *node;
	TINT numfreed = 0;

	while ((node = TRemHead(&pool->list)))
	{
		TMMUFree(pool->handle.mmu, node);
		numfreed++;
	}

	if (numfreed)
	{
		tdbprintf1(5, "*** destroypool: %d allocations pending\n", numfreed);
	}
	
	TMMUFreeHandle(pool);
	return numfreed;
}
