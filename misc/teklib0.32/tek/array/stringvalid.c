
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL TStringLen(TSTRPTR string)
**
**	get valid state of a dynamic string
**
*/

TBOOL TStringValid(TSTRPTR string)
{
	if (string)
	{
		TARRAY *a1 = ((TARRAY *) string) - 1;
		return (TBOOL) a1->valid;
	}
	return TFALSE;
}
