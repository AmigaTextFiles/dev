
#include <stdio.h>
#include "tek/kn/elate/exec.h"


/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TAPTR kn_findself(TVOID)
**
**	find context data.
**
*/

TAPTR kn_findself(TVOID)
{
	char buffer[16];
	struct elatethread *t;
	
	sprintf(buffer, "tektask%08x", kn_proc_pid_get());
	t = kn_nda_find(buffer);
	if (t)
	{
		return t->data;
	}
	else
	{
		dbkprintf(20,"*** TEKLIB kernel: cannot find self context\n");
		return TNULL;
	}
}
