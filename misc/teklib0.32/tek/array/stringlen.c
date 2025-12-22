
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TStringLen(TSTRPTR string)
**
**	get length of a dynamic string.
**
*/

TUINT TStringLen(TSTRPTR string)
{
	if (string)
	{
		TARRAY *a1 = ((TARRAY *) string) - 1;
		return a1->len - 1;
	}
	return 0;
}
