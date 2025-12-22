
/*
 *  MNTREQ.C
 *
 */

#include <local/typedefs.h>

void
mountrequest(bool)
int bool;
{
    static APTR original_pr_WindowPtr = NULL;
    register PROC *proc;

    proc = (PROC *)FindTask(0);
    if (!bool && proc->pr_WindowPtr != (APTR)-1) {
	original_pr_WindowPtr = proc->pr_WindowPtr;
	proc->pr_WindowPtr = (APTR)-1;
    }
    if (bool && proc->pr_WindowPtr == (APTR)-1)
	proc->pr_WindowPtr = original_pr_WindowPtr;
}


