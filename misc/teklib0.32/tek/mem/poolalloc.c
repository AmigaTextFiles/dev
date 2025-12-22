
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TPoolAlloc(TAPTR mp, TUINT size)
**
**	allocate memory from a pool.
**
*/

TAPTR TPoolAlloc(TAPTR mp, TUINT size)
{
	if (mp && size)
	{
		TMEMPOOL *pool = (TMEMPOOL *) mp;
		TNODE *nextnode, *node;
		TBYTE *newchunk;
		TUINT allocsize;
		TBOOL addtail = TFALSE;
		
		size = ((size + pool->align) & ~pool->align) + sizeof(TPOOLNODE *); 
		
		if (size <= pool->thressize)
		{
			node = pool->list.head;
			while ((nextnode = node->succ))
			{
				if (((TPOOLNODE *) node)->memhead.freesize >= size)		/* have we got a chance? */
				{
					TPOOLNODE **mem = TStaticAlloc(&((TPOOLNODE *) node)->memhead, size);
					if (mem)
					{
						*mem++ = (TPOOLNODE *) node;
						return (TAPTR) mem;
					}
				}
				node = nextnode;
			}

			allocsize = pool->chunksize;		/* regular chunk */
		}
		else
		{
			if (pool->dyngrow)
			{
				pool->chunksize = ((TUINT) ((TFLOAT) size * pool->dynfactor) + pool->align) & ~pool->align;
				pool->thressize = (size + pool->align) & ~pool->align;

				allocsize = pool->chunksize;	/* regular chunk, after chunk resizing */
			}
			else
			{
				allocsize = (size + pool->align) & ~pool->align;	 /* large chunk, realigned */
				addtail = TTRUE;
			}
		}


		/*
		**	allocate new chunk
		*/

		newchunk = TMMUAlloc(pool->handle.mmu, pool->poolnodesize + pool->memnodesize + allocsize);
		if (newchunk)
		{
			TPOOLNODE **mem;

			TInitMemHead(&((TPOOLNODE *) newchunk)->memhead,
				(TAPTR) (newchunk + pool->poolnodesize),
				pool->memnodesize + allocsize, TNULL);

			((TPOOLNODE *) newchunk)->numbytes = allocsize;

			mem = TStaticAlloc(&((TPOOLNODE *) newchunk)->memhead, size);

			if (addtail)
			{
				TAddTail(&pool->list, (TNODE *) newchunk);
			}
			else
			{
				TAddHead(&pool->list, (TNODE *) newchunk);
			}

			*mem++ = (TPOOLNODE *) newchunk;

			return (TAPTR) mem;
		}
	}

	return TNULL;
}
