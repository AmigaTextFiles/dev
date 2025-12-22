
#include "tek/mem.h"
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TDestroyArray(TAPTR array)
**
**	create array header.
**
*/

TVOID TDestroyArray(TAPTR array)
{
	if (array)
	{
		TARRAY *arr = ((TARRAY *) array) - 1;
		TMMUFree(arr->mmu, arr);
	}
}
