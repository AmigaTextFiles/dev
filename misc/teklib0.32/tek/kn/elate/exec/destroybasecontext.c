
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_destroybasecontext(TKNOB *basecontext)
**
**	destroy kernel basecontext.
**
*/

TVOID kn_destroybasecontext(TKNOB *basecontext)
{
	if (sizeof(TKNOB) >= sizeof(struct elatethread))
	{
		kn_nda_del(((struct elatethread *) basecontext)->globalname);
	}
	else
	{
		kn_nda_del((*((struct elatethread **) basecontext))->globalname);
		kn_free(*((struct elatethread **) basecontext));
	}
}
