
#include "tek/kn/elate/exec.h"
#include <elate/elate.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_memset32(TAPTR dest, TUINT numbytes, TUINT fillval)
**
**	fill memory (32 bit sized/aligned)
**
*/

TVOID kn_memset32(TAPTR dest, TUINT numbytes, TUINT fillval)
{
	memseti(dest, fillval, numbytes);
}
