
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TDestroy(TAPTR handle)
**
**	destroy a generic handle.
**
*/

TINT TDestroy(TAPTR object)
{
	if (object)
	{
		if (((THNDL *) object)->destroyfunc)
		{
			return (*((THNDL *) object)->destroyfunc)(object);
		}
	}

	return 0;
}
