
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TStringFind(TSTRPTR s1, TSTRPTR s2)
**
**	find dynamic substring in a dynamic string.
**
*/

TINT TStringFind(TSTRPTR s1, TSTRPTR s2)
{
	if (s1 && s2)
	{
		TARRAY *a1 = ((TARRAY *) s1) - 1;
		TARRAY *a2 = ((TARRAY *) s2) - 1;

		if (a1->valid && a2->valid)
		{
			TUINT len1 = a1->len - 1;
			TUINT len2 = a2->len - 1;
			
			if (len2 > 0 && len1 >= len2)
			{
				return TStringFindSimple(s1, s2, len1, len2);
			}
		}
	}
	return -1;
}
