
#include "tek/mem.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMMURealloc(TAPTR mmu, TAPTR mem, TUINT size)
**
**	reallocate an allocation from a MMU.
**
*/

TAPTR TMMURealloc(TAPTR mmu, TAPTR mem, TUINT size)
{
	if (mmu)
	{
		if (((TMMU *) mmu)->reallocfunc)
		{
			return (*((TMMU *) mmu)->reallocfunc)(((TMMU *) mmu)->allocator, mem, size);
		}
		else if (((TMMU *) mmu)->getsizefunc)
		{
			TUINT oldsize = (*((TMMU *) mmu)->getsizefunc)(((TMMU *) mmu)->allocator, mem);
			if (oldsize > 0)
			{
				TAPTR newmem = (*((TMMU *) mmu)->allocfunc)(((TMMU *) mmu)->allocator, size);
				if (newmem)
				{
					TMemCopy32(mem, newmem, TMIN(oldsize, size));
					(*((TMMU *) mmu)->freefunc)(((TMMU *) mmu)->allocator, mem);
				}
				return newmem;
			}
		}
	}
	else
	{
		return kn_realloc(mem, size);
	}

	return TNULL;
}
