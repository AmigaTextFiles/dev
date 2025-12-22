
#include "tek/kn/elate/exec.h"
#include <string.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_memcopy32(TAPTR from, TAPTR to, TUINT numbytes)
**
**	copy memory (32 bit sized/aligned)
**
*/

TVOID kn_memcopy32(TAPTR from, TAPTR to, TUINT numbytes)
{
	memcpy(to, from, numbytes);
}
