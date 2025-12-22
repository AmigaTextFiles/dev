
#include "tek/kn/elate/exec.h"

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TVOID kn_destroythread(TKNOB *thread)
**
**	destroy kernel thread.
**
*/

TVOID kn_destroythread(TKNOB *thread)
{
	if (sizeof(TKNOB) >= sizeof(struct elatethread))
	{
		struct elatethread *t = (struct elatethread *) thread;
		kn_proc_chld(t->pid, 0, NULL);
		kn_proc_delete(t->pid);
		kn_nda_del(t->globalname);
		kn_mem_free(t->spawn);
	}
	else
	{
		struct elatethread *t = *((struct elatethread **) thread);
		kn_proc_chld(t->pid, 0, NULL);
		kn_proc_delete(t->pid);
		kn_nda_del(t->globalname);
		kn_mem_free(t->spawn);
		kn_free(t);
	}
}
