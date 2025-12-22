
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TStaticRealloc(TMEMHEAD *head, TAPTR mem, TUINT size)
**
**	reallocate allocation from static allocator.
*/

TAPTR TStaticRealloc(TMEMHEAD *head, TAPTR mem, TUINT size)
{
	if (size)
	{
		size = (size + head->align) & ~head->align;

		if (mem)
		{
			TMEMNODE *p = (TMEMNODE *) ((TUINT8 *) mem - head->memnodesize);
			TUINT oldsize = p->size - p->free;

			if (size < oldsize)
			{
				/* shrink */
		
				if (p->next)
				{
					if (p->next->free == p->next->size)
					{
						/*	next node is free - move next node. */

						TMEMNODE *pnnext = p->next->next;
						TUINT pnsize = p->next->size;
						TMEMNODE *n = (TMEMNODE *)((TUINT8 *)p + head->memnodesize + size);

						head->freesize += p->size - size - p->free;
												
						n->prev = p;
						n->next = pnnext;
						n->size = pnsize + p->size - size;
						n->free = n->size;
						
						p->next = n;
						if (n->next)
						{
							n->next->prev = n;
						}
						
						p->size = size;
						p->free = 0;

						return mem;
					}
					else if (p->size - size > head->memnodesize)
					{
						/* next node is not free, but there is room for a new node */
						
						TMEMNODE *n = (TMEMNODE *) ((TUINT8 *)p + head->memnodesize + size);

						head->freesize += p->size - size - p->free - head->memnodesize;

						n->next = p->next;
						n->prev = p;
						n->next->prev = n;
						
						n->size = p->size - size - head->memnodesize;
						n->free = n->size;
			
						p->size = size;
						p->free = 0;
			
						p->next = n;
			
						return mem;
					}
					else
					{
						/* no room for a new node */

						head->freesize += p->size - size - p->free;
						p->free = p->size - size;
						return mem;
					}				
				}
				else
				{
					/* endnode */

					head->freesize -= p->free - p->size + size;
					p->free = p->size - size;
					return mem;
				}
			}
			else if (size > oldsize)
			{
				TUINT8 *newmem;

				/* enlarge */
				
				if (p->next)
				{
					if (p->next->size == p->next->free)
					{
						/* next node is free */
		
						if (p->size + p->next->size > size)
						{
							/* move next node */
	
							TUINT pnsize = p->next->size;
							TMEMNODE *pnnext = p->next->next;
							TMEMNODE *n = (TMEMNODE *)(((TUINT8 *) p) + head->memnodesize + size);

							head->freesize -= size - p->size + p->free;

							n->next = pnnext;
							n->prev = p;
							n->size = pnsize - size + p->size;
							n->free = n->size;
							if (pnnext)
							{
								pnnext->prev = n;
							}
							
							p->size = size;
							p->free = 0;
							p->next = n;

							return mem;					
						}
						else if (p->size + p->next->size + head->memnodesize >= size)
						{
							/* eliminate next node */

							head->freesize -= size - p->size + p->free - head->memnodesize + p->free;
						
							p->size += p->next->size + head->memnodesize;
							p->next = p->next->next;
							p->next->prev = p;	
														
							p->free = p->size - size;
							return mem;
						}
					}
					else if (p->free)
					{
						/* leftover in this node */
						
						if (p->size >= size)
						{
							/* sufficient */
				
							head->freesize -= p->free - p->size + size;			
							p->free = p->size - size;
							return mem;
						}
					}
				}
				else
				{
					/* endnode */
				
					if (p->size >= size)
					{
						head->freesize -= p->free - p->size + size;
						p->free = p->size - size;
						return mem;
					}
				}
		
				/*
				**	last resort: try to reallocate by
				**	allocating, copying, and freeing
				*/
				
				newmem = TStaticAlloc(head, size);
				if (newmem)
				{
					TMemCopy32(mem, newmem, TMIN(size, oldsize));
					TStaticFree(head, mem);
				}
				
				return newmem;					
			}
			else
			{
				/* size unchanged */
				return mem;
			}
		}
		else
		{
			/* size, but no mem -> alloc */
		
			return TStaticAlloc(head, size);
		}
	}
	else
	{
		/* no size */
		
		if (mem)
		{
			TStaticFree(head, mem);
		}
	}

	return TNULL;
}
