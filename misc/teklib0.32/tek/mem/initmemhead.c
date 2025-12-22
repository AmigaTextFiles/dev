
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TInitMemHead(TMEMHEAD *mh, TAPTR mem, TUINT size, TTAGITEM *tags)
**
**	init static memory header.
*/

TBOOL TInitMemHead(TMEMHEAD *mh, TAPTR mem, TUINT size, TTAGITEM *tags)
{
	if (mh && mem && size)
	{
		TUINT align = TALIGN_DEFAULT;
		TUINT memnodesize;

		size &= ~align;	
		memnodesize = (sizeof(TMEMNODE) + align) & ~align;
	
		if (size > memnodesize)
		{
			TMEMNODE *p = (TMEMNODE *) mem;

			p->next = TNULL;
			p->prev = TNULL;
			p->size = size - memnodesize;
			p->free = size - memnodesize;
			
			mh->mem = (TBYTE *) mem;
			mh->memnodesize = memnodesize;
			mh->align = align;
			mh->freesize = size - memnodesize;

			/*
			**	a NULL-handle is required for a MMU built on top of a memheader:
			*/

			mh->handle.mmu = TNULL;
			mh->handle.destroyfunc = (TDESTROYFUNC) TNULL;
		
			return TTRUE;
		}
	}
	return TFALSE;
}
