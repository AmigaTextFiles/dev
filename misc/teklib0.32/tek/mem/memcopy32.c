
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID TMemCopy32(TAPTR from, TAPTR to, TUINT numbytes)
**
**	copy 32bit aligned memory
**
*/

TVOID TMemCopy32(TAPTR from, TAPTR to, TUINT numbytes)
{
	kn_memcopy32(from, to, numbytes);
}
