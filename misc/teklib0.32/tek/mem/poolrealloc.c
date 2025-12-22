
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TPoolRealloc(TAPTR mp, TAPTR poolmem, TUINT size)
**
**	reallocate memory from a pooled allocator.
**
*/

TAPTR TPoolRealloc(TAPTR mp, TAPTR poolmem, TUINT size)
{
	if (mp)
	{
		TMEMPOOL *pool = (TMEMPOOL *) mp;
		TPOOLNODE **mem = (TPOOLNODE **) poolmem;
		TPOOLNODE *poolnode;

		size = (size + pool->align) & ~pool->align;

		if (mem)
		{
			poolnode = *(--mem);
			if (size)
			{
				TMEMNODE *memnode = (TMEMNODE *) ((TBYTE *) mem - pool->memnodesize);
				TUINT realnodesize = memnode->size;
				if (realnodesize != size + sizeof(TPOOLNODE *))
				{
					TPOOLNODE **newmem;
					
					newmem = TStaticRealloc(&poolnode->memhead, mem, size + sizeof(TPOOLNODE *));
					if (newmem)
					{
						*newmem++ = (TPOOLNODE *) poolnode;
						return newmem;
					}

					newmem = TPoolAlloc(pool, size);
					if (newmem)
					{
						TMemCopy32(poolmem, newmem, TMIN(realnodesize - sizeof(TPOOLNODE *), size));

						TStaticFree(&poolnode->memhead, mem);
						if (poolnode->memhead.freesize == poolnode->numbytes)
						{
							TRemove((TNODE *) poolnode);
							TMMUFree(pool->handle.mmu, (TAPTR) poolnode);
						}
						return newmem;
					}
				}
				else
				{
					/* same size requested */
				
					return mem;
				}
			}
			else
			{
				/* size zero requested from a valid allocation */
			
				TStaticFree(&poolnode->memhead, mem);
		
				if (poolnode->memhead.freesize == poolnode->numbytes)
				{
					TRemove((TNODE *) poolnode);
					TMMUFree(pool->handle.mmu, (TAPTR) poolnode);
				}
				return TNULL;
			}
		}
		else
		{
			if (size)
			{
				return TPoolAlloc(pool, size);
			}
		}
	}

	return TNULL;
}
