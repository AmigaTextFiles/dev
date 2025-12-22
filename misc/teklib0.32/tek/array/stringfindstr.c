
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TStringFindStr(TSTRPTR s1, TSTRPTR s2)
**
**	find regular substring in a dynamic string.
**
*/

TINT TStringFindStr(TSTRPTR s1, TSTRPTR s2)
{
	if (s1 && s2)
	{
		TARRAY *a1 = ((TARRAY *) s1) - 1;

		if (a1->valid)
		{
			TUINT len1 = a1->len - 1;
			TUINT len2 = TStrLen(s2);
		
			if (len2 > 0 && len1 >= len2)
			{
				return TStringFindSimple(s1, s2, len1, len2);
			}
		}
	}
	return -1;
}

