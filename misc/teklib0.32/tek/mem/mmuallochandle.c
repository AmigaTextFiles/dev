
#include "tek/mem.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMMUAllocHandle(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)
**
**	allocate a generic handle with destructor
**
*/

TAPTR TMMUAllocHandle(TAPTR mmu, TDESTROYFUNC destroyfunc, TUINT size)
{
	if (size)
	{
		THNDL *handle = TMMUAlloc(mmu, size);
		if (handle)
		{
			handle->destroyfunc = destroyfunc;
			handle->mmu = mmu;
			return (TAPTR) handle;
		}
	}
	return TNULL;
}
