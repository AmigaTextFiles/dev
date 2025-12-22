
#include "tek/kn/elate/exec.h"
#include <stdio.h>

extern pid_t kn_proc_exec_local(ELATE_SPAWN *, ELATE_PCB *)
	__ELATE_QCALL__(("qcall sys/kn/proc/exec/local"));

extern void kn_mem_free(void *)
	__ELATE_QCALL__(("qcall sys/kn/mem/free"));

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	TBOOL kn_initthread(TKNOB *thread, TVOID (*threadfunc)(TAPTR data), TAPTR data)
**
**	init thread.
**
*/

TBOOL kn_initthread(TKNOB *thread, TVOID (*threadfunc)(TAPTR data), TAPTR selfdata)
{
	if (sizeof(TKNOB) >= sizeof(struct elatethread))
	{
		struct elatethread *t = (struct elatethread *) thread;

		kn_memset(t, sizeof(struct elatethread), 0);

		if (kn_proc_getparams(kn_proc_pid_get(), &t->pcb) == 0)
		{
			strcpy(t->toolname, "dispatch");
			sprintf(t->adrstr, "%d", (int) t);
			t->argvblock[0] = t->toolname;
			t->argvblock[1] = t->adrstr;
			t->argvblock[2] = TNULL;
			t->data = selfdata;
			t->function = threadfunc;

			t->globaldata = t;			/* self reference via global data */
	
			t->spawn = kn_proc_spawn_make("lib/tek/kn/exec/dispatch", 
				t->argvblock,
				NULL,				/* stackname */
				NULL,				/* dataname */
				t->globaldata,		/* global */
				sizeof(TAPTR),		/* globalsize */
				1,1);

			if (t->spawn)
			{
				t->initok = 0;
				t->pid = kn_proc_exec_local(t->spawn, &t->pcb);
				if (t->pid > 0)
				{
					/* 
					**	setup self reference.
					*/
					
					void *ndadata;

					sprintf(t->globalname, "tektask%08x", t->pid);
					ndadata = kn_nda_name(t, t->globalname);
					if (ndadata == t)
					{
						t->initok = 1;
						kn_proc_wake(t->pid);
						return TTRUE;
					}

					kn_proc_chld(t->pid, 0, NULL);
					kn_proc_delete(t->pid);
				}
				kn_mem_free(t->spawn);
			}
		}
	}
	else
	{
		struct elatethread *t = kn_alloc0(sizeof(struct elatethread));
		if (t)
		{
			if (kn_proc_getparams(kn_proc_pid_get(), &t->pcb) == 0)
			{
				strcpy(t->toolname, "dispatch");
				sprintf(t->adrstr, "%d", (int) t);
				t->argvblock[0] = t->toolname;
				t->argvblock[1] = t->adrstr;
				t->argvblock[2] = TNULL;
				t->data = selfdata;
				t->function = threadfunc;
	
				t->globaldata = t;			/* self reference via global data */
		
				t->spawn = kn_proc_spawn_make("lib/tek/kn/exec/dispatch", 
					t->argvblock,
					NULL,				/* stackname */
					NULL,				/* dataname */
					t->globaldata,		/* global */
					sizeof(TAPTR),		/* globalsize */
					1,1);

				if (t->spawn)
				{
					t->initok = 0;
					t->pid = kn_proc_exec_local(t->spawn, &t->pcb);
					if (t->pid > 0)
					{
						/* 
						**	setup self reference.
						*/
						
						void *ndadata;
	
						sprintf(t->globalname, "tektask%08x", t->pid);
						ndadata = kn_nda_name(t, t->globalname);
						if (ndadata == t)
						{
							*((struct elatethread **) thread) = t;
							t->initok = 1;
							kn_proc_wake(t->pid);
							return TTRUE;
						}
	
						kn_proc_chld(t->pid, 0, NULL);
						kn_proc_delete(t->pid);
					}
					kn_mem_free(t->spawn);
				}
			}
			kn_free(t);
		}
	}

	dbkprintf(10,"*** TEKLIB kernel: could not create thread\n");
	return TFALSE;
}
