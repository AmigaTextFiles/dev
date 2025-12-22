
#include "tek/kn/elate/exec.h"
#include <stdio.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_initbasecontext(TKNOB *thread, TAPTR data)
**
**	init kernel basecontext.
**
*/

TBOOL kn_initbasecontext(TKNOB *thread, TAPTR selfdata)
{
	if (sizeof(TKNOB) >= sizeof(struct elatethread))
	{
		struct elatethread *t = (struct elatethread *) thread;
		void *ndadata;

		kn_memset(t, sizeof(struct elatethread), 0);

		sprintf(t->globalname, "tektask%08x", kn_proc_pid_get());
		ndadata = kn_nda_name(t, t->globalname);
		if (ndadata == t)
		{
			t->data = selfdata;
			return TTRUE;
		}
		else
		{
			dbkprintf1(20,"*** TEKLIB kernel: could not setup NDA record %s\n", ndadata);
		}
	}
	else
	{
		struct elatethread *t = kn_alloc0(sizeof(struct elatethread));
		if (t)
		{
			void *ndadata;
			sprintf(t->globalname, "tektask%08x", kn_proc_pid_get());
			ndadata = kn_nda_name(t, t->globalname);
			if (ndadata == t)
			{
				t->data = selfdata;
				*((struct elatethread **) thread) = t;
				return TTRUE;
			}
			else
			{
				dbkprintf1(20,"*** TEKLIB kernel: could not setup NDA record %s\n", ndadata);
			}
		}
	}

	dbkprintf(10,"*** TEKLIB kernel: could not establish basecontext\n");
	return TFALSE;
}
