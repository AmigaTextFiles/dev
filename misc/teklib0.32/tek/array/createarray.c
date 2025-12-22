
#include "tek/mem.h"
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TCreateArray(TAPTR mmu, TUINT size, TUINT len, TTAGITEM *tags)
**
**	create array header.
**
*/

TAPTR TCreateArray(TAPTR mmu, TUINT size, TUINT len, TTAGITEM *tags)
{
	if (size >= 1 && size <= 0xffff)		/* current element size limit is 2^16-1 bytes */
	{
		TUINT alloclen = (len + ARRAY_ALIGNMENT) & ~ARRAY_ALIGNMENT;
		TARRAY *arr = TMMUAlloc(mmu, sizeof(TARRAY) + alloclen * size);
		if (arr)
		{
			arr->mmu = mmu;
			arr->len = len;
			arr->alloclen = alloclen;
			arr->size = (TUINT16) size;
			arr->valid = 1;
			return (TAPTR) (((TARRAY *) arr) + 1);
		}
	}
	return TNULL;
}
