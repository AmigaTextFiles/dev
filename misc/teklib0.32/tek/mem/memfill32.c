
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR TMemFill32(TAPTR dest, TUINT numbytes, TUINT fillval)
**	
**	fill 32bit-aligned memory with 32bit value.
*/

TVOID TMemFill32(TAPTR dest, TUINT numbytes, TUINT fillval)
{
	kn_memset32(dest, numbytes, fillval);
}

