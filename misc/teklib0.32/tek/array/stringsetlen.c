
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringSetLen(TSTRPTR *string, TUINT len)
**
**	set length of a dynamic string.
**
*/

TBOOL TStringSetLen(TSTRPTR *string, TUINT len)
{
	if (string)
	{
		TARRAY *a1 = *((TARRAY **) string) - 1;
		if (a1->valid)
		{
			if (TArraySetLen((TAPTR *) string, len + 1))
			{
				(*string)[len] = 0;
				return TTRUE;
			}
		}
	}
	return TFALSE;
}
