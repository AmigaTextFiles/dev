
#include "tek/exec.h"
#include "tek/kn/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TINT TGetRandomSeed(TVOID)
**
**	get a random seed number.
**
*/

TINT TGetRandomSeed(TAPTR task)
{
	return kn_getrandomseed(&((TTASK *) task)->timer);
}
