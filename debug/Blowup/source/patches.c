/*
 * $Id: patches.c 1.3 1998/04/18 15:45:06 olsen Exp olsen $
 *
 * :ts=4
 *
 * Blowup -- Catches and displays task errors
 *
 * Written by Olaf `Olsen' Barthel <olsen@sourcery.han.de>
 * Public Domain
 */

#ifndef _GLOBAL_H
#include "global.h"
#endif	/* _GLOBAL_H */

/******************************************************************************/

/* library vector offset from amiga.lib */
extern ULONG FAR LVOAddTask;

/******************************************************************************/

typedef APTR (* ASM ADDTASKFUNC)(REG(a1) struct Task *		task,
                                 REG(a2) APTR				initialPC,
                                 REG(a3) APTR				finalPC,
                                 REG(a6) struct Library *	sysBase);

STATIC ADDTASKFUNC OldAddTask;

/******************************************************************************/

STATIC APTR	TaskTrapHandler;	/* the default system task trap handler */
STATIC APTR	ProcessTrapHandler;	/* the default system process trap handler */

/******************************************************************************/

/* this is in traphandler.asm */
extern VOID TrapHandler(VOID);

/******************************************************************************/

STATIC VOID
FixTaskTrapHandler(struct Task * tc)
{
	/* patch a task only if its trap handler matches the system default */
	if(tc->tc_Node.ln_Type == NT_TASK && (tc->tc_TrapCode == TaskTrapHandler || tc->tc_TrapCode == NULL))
	{
		tc->tc_TrapCode = (APTR)TrapHandler;
	}

	/* patch a process only if its trap handler matches the system default */
	if(tc->tc_Node.ln_Type == NT_PROCESS && tc->tc_TrapCode == ProcessTrapHandler)
	{
		tc->tc_TrapCode = (APTR)TrapHandler;
	}
}

/******************************************************************************/

STATIC VOID
FixAllTaskTrapHandlers(VOID)
{
	struct Node * node;

	/* this patches all tasks and processes in the system to use our
	 * custom trap handler code
	 */

	Forbid();

	FixTaskTrapHandler((struct Task *)FindTask(NULL));

	for(node = SysBase->TaskReady.lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		FixTaskTrapHandler((struct Task *)node);
	}

	for(node = SysBase->TaskWait.lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		FixTaskTrapHandler((struct Task *)node);
	}

	Permit();
}

/******************************************************************************/

STATIC VOID
ResetTaskTrapHandler(struct Task * tc)
{
	/* reset the trap handler only if we have a task and it has
	 * our custom trap handler installed; unknown trap code
	 * will not be replaced
	 */
	if(tc->tc_Node.ln_Type == NT_TASK && tc->tc_TrapCode == (APTR)TrapHandler)
	{
		tc->tc_TrapCode = TaskTrapHandler;
	}

	/* reset the trap handler only if we have a process and it has
	 * our custom trap handler installed; unknown trap code
	 * will not be replaced
	 */
	if(tc->tc_Node.ln_Type == NT_PROCESS && tc->tc_TrapCode == (APTR)TrapHandler)
	{
		tc->tc_TrapCode = ProcessTrapHandler;
	}
}

STATIC VOID
ResetAllTaskTrapHandlers(VOID)
{
	struct Node * node;

	/* this patches all tasks and processes in the system to use the
	 * system default trap handler code
	 */

	Forbid();

	ResetTaskTrapHandler((struct Task *)FindTask(NULL));

	for(node = SysBase->TaskReady.lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		ResetTaskTrapHandler((struct Task *)node);
	}

	for(node = SysBase->TaskWait.lh_Head ;
	    node->ln_Succ != NULL ;
	    node = node->ln_Succ)
	{
		ResetTaskTrapHandler((struct Task *)node);
	}

	Permit();
}

/******************************************************************************/

STATIC APTR ASM
NewAddTask(
	REG(a1) struct Task *		task,
	REG(a2) APTR				initialPC,
	REG(a3) APTR				finalPC,
	REG(a6) struct Library *	sysBase)
{
	/* fix up the trap handler code */
	FixTaskTrapHandler(task);

	/* and proceed to call the original operating system routine */
	return((*OldAddTask)(task,initialPC,finalPC,sysBase));
}

/******************************************************************************/

VOID
AddPatches(VOID)
{
	Forbid();

	/* The trap handler code is different for plain tasks and for
	 * processes; the default task trap handler will end straight
	 * in a dead-end alert whereas the process trap handler will
	 * show the familiar "Software error -- finish ALL disk activity..."
	 * requester, or at least attempt to do so. We have to take care of
	 * both cases. The default task trap handler comes from SysBase,
	 * whereas there is no absolutely safe way to obtain the default
	 * process trap handler; we try to do away with the current
	 * process' trap handler and hope that it will work.
	 */

	TaskTrapHandler		= SysBase->TaskTrapCode;
	ProcessTrapHandler	= ((struct Task *)FindTask(NULL))->tc_TrapCode;

	/* patch AddTask() so new tasks will automatically be fitted with
	 * the new trap handler
	 */
	OldAddTask = (ADDTASKFUNC)SetFunction((struct Library *)SysBase,(LONG)&LVOAddTask,(ULONG (*)())NewAddTask);

	/* finally, patch all running tasks to use the new trap handler */
	FixAllTaskTrapHandlers();

	Permit();
}

/******************************************************************************/

VOID
RemovePatches(VOID)
{
	Forbid();

	/* reset the AddTask() patch; note: may not be safe as other programs may
	 * have redirected the vector
	 */
	SetFunction((struct Library *)SysBase,(LONG)&LVOAddTask,(ULONG (*)())OldAddTask);

	/* finally, reset all running task/process trap handlers */
	ResetAllTaskTrapHandlers();

	Permit();
}
