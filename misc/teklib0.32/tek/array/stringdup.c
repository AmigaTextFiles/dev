
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TSTRPTR TStringDup(TSTRPTR s)
**
**	create duplicate from a dynamic string.
**
*/

TSTRPTR TStringDup(TSTRPTR s)
{
	if (s)
	{
		TARRAY *a = ((TARRAY *) s) - 1;
		if (a->valid)
		{
			TSTRPTR array = TCreateArray(a->mmu, 1, a->len, TNULL);
			if (array && a->len)
			{
				TMemCopy(s, array, a->len);
			}

			return array;
		}
	}
	return TNULL;
}
