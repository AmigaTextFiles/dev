
#include "tek/mem.h"
#include "tek/array.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	len = TArrayGetLen(arraydata)
**	TUINT              TAPTR
**
**	get array length.
**
*/

TUINT TArrayGetLen(TAPTR arraydata)
{
	if (arraydata)
	{
		TARRAY *arr = ((TARRAY *) arraydata) - 1;
		return arr->len;
	}
	return 0;
}
