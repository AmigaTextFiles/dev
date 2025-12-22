
#include "tek/mem.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TUINT TMMUGetSize(TAPTR mmu, TAPTR mem)
**
**	get size of an MMU allocation.
**
*/

TUINT TMMUGetSize(TAPTR mmu, TAPTR mem)
{
	if (mem)
	{
		if (mmu)
		{
			if (((TMMU *) mmu)->getsizefunc)
			{
				return (*((TMMU *) mmu)->getsizefunc)(((TMMU *) mmu)->allocator, mem);
			}
		}
		else
		{
			return (TUINT) kn_getsize(mem);
		}
	}
	return 0;
}
