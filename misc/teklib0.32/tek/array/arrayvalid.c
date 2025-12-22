
#include "tek/mem.h"
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	valid = TArrayValid(arraydata)
**	TBOOL               TAPTR
**
**	query array valid state
**
*/

TUINT TArrayValid(TAPTR arraydata)
{
	if (arraydata)
	{
		TARRAY *arr = ((TARRAY *) arraydata) - 1;
		return arr->valid;
	}
	return 0;
}

