
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TStaticAlloc(TMEMHEAD *head, TUINT size)
**
**	allocate from static allocator.
**
*/

TAPTR TStaticAlloc(TMEMHEAD *head, TUINT size)
{
	if (head && size)
	{
		TMEMNODE *p = (TMEMNODE *) head->mem;
		TMEMNODE *n;
	
		size = (size + head->align) & ~head->align;

		while (p->next)
		{
			if (p->free == p->size)
			{
				/* unused node */
			
				if (p->free > size + head->memnodesize)	
				{
					/* create new node */

					n = (TMEMNODE *) ((TUINT8 *) p + size + head->memnodesize);
					
					n->next = p->next;
					n->prev = p;

					n->size = p->free - size - head->memnodesize;
					n->free = n->size;
					
					p->size = size;
					p->free = 0;
					
					p->next->prev = n;
					p->next = n;

					head->freesize -= size + head->memnodesize;
				
					return (((TUINT8 *) p) + head->memnodesize);
				}
				else if (p->free >= size)
				{
					/* use node, do not create a new one */

					p->free -= size;

					head->freesize -= size;

					return (((TUINT8 *) p) + head->memnodesize);
				}
			}
			
			p = p->next;
		}

		/* endnode */
		
		if (p->free == p->size)
		{
			/* unused end node */
			
			if (p->size >= size)
			{
				p->free -= size;

				head->freesize -= size;

				return (((TUINT8 *) p) + head->memnodesize);
			}
		}
		else
		{
			/* already used end node */
			
			if (p->free >= size + head->memnodesize)
			{
				n = (TMEMNODE *) ((TUINT8 *) p + head->memnodesize + p->size - p->free);

				p->next = n;
				p->size -= p->free;
				n->next = TNULL;
				n->prev = p;
				n->size = p->free - head->memnodesize;
				n->free = n->size - size;
				p->free = 0;

				head->freesize -= size + head->memnodesize;

				return (((TUINT8 *) n) + head->memnodesize);
			}
		}
	}
	return TNULL;
}
