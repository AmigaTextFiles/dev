
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TMMUFreeHandle(TAPTR h)
**
**	free handle.
**
*/

TVOID TMMUFreeHandle(TAPTR h)
{
	if (h)
	{
		TMMUFree(((THNDL *) h)->mmu, h);
	}
}
