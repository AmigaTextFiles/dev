
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TStaticFree(TMEMHEAD *head, TAPTR mem)
**
**	free memory allocated from a static allocator.
*/

TVOID TStaticFree(TMEMHEAD *head, TAPTR mem)
{
	if (head && mem)
	{
		TMEMNODE *p = (TMEMNODE *) ((TUINT8 *) mem - head->memnodesize);

		if (p->next)
		{
			/* not end node */
			
			head->freesize += p->size - p->free;
			p->free = p->size;

			if (p->next->size == p->next->free)
			{
				head->freesize += head->memnodesize;
				p->size += head->memnodesize + p->next->size;
				p->free += head->memnodesize + p->next->size;
				p->next = p->next->next;
				if (p->next)
				{
					p->next->prev = p;
				}
			}

			if (p->prev)
			{
				if (p->prev->free == p->prev->size)
				{
					p->prev->size += p->size + head->memnodesize;
					p->prev->free += p->size + head->memnodesize;
					p->prev->next = p->next;
					p->next->prev = p->prev;
					head->freesize += head->memnodesize;
					p = p->prev;
				}
			}
			
			if (p->prev)
			{
				if (p->prev->free)
				{
					/* 
					**		move node and concatenate with
					**		leftover space at the previous node.
					**
					**		||***.||*****||*||
					**	->	||***||......||*||
					*/					

					TUINT psize = p->size;
					TMEMNODE *pprev = p->prev, *pnext = p->next;
					TMEMNODE *n = (TMEMNODE *) ((TUINT8 *)p->prev + head->memnodesize + p->prev->size - p->prev->free);

					pprev->size -= pprev->free;
					n->prev = pprev;
					n->next = pnext;
					pnext->prev = n;
					pprev->next = n;
					n->size = psize + pprev->free;
					n->free = n->size;
					pprev->free = 0;
				}
			}
		}
		else
		{
			/* end node */

			if (p->prev)
			{
				p->prev->next = TNULL;
				p->prev->size += p->size + head->memnodesize;
				p->prev->free += p->size + head->memnodesize;

				head->freesize += p->size - p->free + head->memnodesize;
							
				if (p->prev->free == p->prev->size && p->prev->prev)
				{
					p->prev->prev->size += p->prev->size + head->memnodesize;
					p->prev->prev->free += p->prev->size + head->memnodesize;
					p->prev->prev->next = TNULL;
					head->freesize += head->memnodesize;
				}
			}
			else
			{
				head->freesize += p->size - p->free;
				p->free = p->size;
			}
		}
	}
}
