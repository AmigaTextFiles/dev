
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR task = TTaskFindSelf(TVOID)
**
**	find self - get task context
**
*/

TAPTR TTaskFindSelf(TVOID)
{
	return kn_findself();
}
