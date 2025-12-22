
#include "tek/mem.h"
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TArraySetLen(TAPTR *mem, TUINT len)
**
**	set array length.
*/

TBOOL TArraySetLen(TAPTR *memp, TUINT len)
{
	if (memp)
	{
		TUINT newalloclen;
		TARRAY *newarray;
		TARRAY *array = (*((TARRAY **) memp)) - 1;
		if (array)
		{
			if (array->valid)
			{
				if (len == array->len)
				{
					return TTRUE;
				}
				
				if (len > (array->len & ~ARRAY_ALIGNMENT) && len < array->len)
				{
					array->len = len;
					return TTRUE;
				}

				newalloclen = (len + ARRAY_ALIGNMENT) & ~ARRAY_ALIGNMENT;
				newarray = TMMURealloc(array->mmu, array, sizeof(TARRAY) + newalloclen * array->size);
				if (newarray)
				{
					newarray->alloclen = newalloclen;
					newarray->len = len;
					*memp = (TAPTR) (((TARRAY *) newarray) + 1);
					return TTRUE;
				}
				
				array->valid = 0;
			}
		}
	}
	return TFALSE;
}
