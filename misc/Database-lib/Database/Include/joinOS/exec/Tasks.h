#ifndef _TASKS_H_
#define _TASKS_H_ 1

/* Tasks.c
 *
 * This is the implementation of execs task structure, for use under Windoof.
 * Every process (even every thread) has its own task structure. This structure
 *	is located in a global shared memory region.
 * Everytime a process or thread is started, this structure is allocated and
 * initialized for that specific task. When a task terminates, the structure is
 * freed.
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _LISTS_H_
#include  <joinOS/exec/lists.h>
#endif

#ifdef _AMIGA

#ifndef EXEC_TASKS_H
#include <exec/tasks.h>
#endif

#else			/* _AMIGA */

/* --- Defines -------------------------------------------------------------- */

/* Task states, used for the tc_State field of the task structure, to indicate
 * the state of the task. (not all states are used under this implementation,
 * so don't rely on this values).
 */

#define TS_INVALID	0
#define TS_ADDED	1
#define TS_RUN		2
#define TS_READY	3
#define TS_WAIT	4
#define TS_EXCEPT	5
#define TS_REMOVED	6

/* Predefined Signals for the tc_Sig.. fields of the task structure.
 */

#define SIGB_ABORT	0
	/* This signal is send to a task, that should be aborted (RemTask()).
	 * A task , that called Wait(0L) at the end of execution, to come in a save
	 *	state to be removed (wait forever), do internaly a Wait() on this signal,
	 * which informs it, that it should remove itself.
	 */
#define SIGB_CHILD	1
	/* A task calling CreateTask() waits for this signal, notifying the task,
	 * that the new created task is completely initialized and ready to run,
	 * or that the creation failed, which can be determined if no task structure
	 * is added to Exec's list of tasks for the new task.
	 * The new created task waits for this signal that should be send to notify
	 * the new task that it can be executed now.
	 */
#define SIGB_BLIT	4		/* Note: same as SINGLE */
#define SIGB_SINGLE	4	/* Note: same as BLIT */
	/* This flag is used for SignalSemaphores, tasks that wants to gain access
	 * to a blocked semaphore, wait for this signal, which is signalised to
	 * every task in the semaphores WaitQueue, when the semaphore is released.
	 */
#define SIGB_INTUITION	5
#define SIGB_NET	7
#define SIGB_DOS	8
	/* This flag is used for the message port of the process-structure of an
	 * AmigaDOS process.
	 */
#define SIGF_ABORT	(1L<<0)
#define SIGF_CHILD	(1L<<1)
#define SIGF_BLIT	(1L<<4)
#define SIGF_SINGLE	(1L<<4)
#define SIGF_INTUITION	(1L<<5)
#define SIGF_NET	(1L<<7)
#define SIGF_DOS	(1L<<8)

/* --- Structures used for Tasks -------------------------------------------- */

/* The following structure is used for every process and most tasks.
 * Only processes that use the AmigaOS Exec library have it. Not every thread
 * used under control of Exec under Windoof has it, only that which are created
 * using CreateTask() have a task-structure. (Devices for example are threads
 * under Windoof, which have no task-structure).
 * The task structure is strictly private, don't touch or even read any of its
 *	fields in an application. (The first fields can carefully be read by user-
 * applications, but you don't have to, use the exec functions for manipulating
 * them.
 */

struct Task		/* longword aligned, size 92 */
{
	struct Node tc_Node;					/* tasks are linked together by this node */
	UBYTE tc_State;						/* the current state of the task
												 * see defines above */
	UBYTE tc_pad;
	ULONG tc_SigAlloc;					/* signals that are allocated */
	ULONG tc_SigWait;						/* signals the task waits for */
	ULONG tc_SigRecvd;					/* signals the task has received */
	APTR	tc_SPReg;						/* stack pointer */
	APTR	tc_SPLower;						/* stack lower bound */
	APTR	tc_SPUpper;						/* stack upper bound + 2 */
	struct List tc_MemEntry;			/* memory allocated by the task, memory that is
												 * linked in this list is freed automatically on
												 * task termination. */
	UWORD tc_Reserved;
	APTR tc_UserData;						/* for use by the task, no restrictions */
	/* The structure members behind this point are strictly private, don't
	 * access them in any kind.
	 */
	HANDLE tc_WaitSem;
			/* the semaphore used to wait for signals.
			 * DON'T USE THIS HANDLE TO ACCESS THE SEMAPHORE FROM DIFFERENT
			 * PROCESSES.
			 * Use
			 * 		CreateSemaphore (NULL,1,1,tc_Node.ln_Name)
			 *	to get access (a local HANDLE) to that semaphore.
			 */
	UBYTE *tc_SemName;			/* The unique name of the semaphore */
	HANDLE ForbidSem;
		/* This is a named semaphore "ForbidSem", used to implement the functions
		 * Forbid() and Permit(). These functions doesn't really disable task-
		 * switching under Windoof, they only serialize the access to Exec structures,
		 * so no other process can manipulate these structures while they are in
		 * progress by another process.
		 */
	ULONG ForbidNestCount;
		/* This is the counter how often the current task has called Forbid()
		 * without matching Permit(), the Forbid() counts are nested.
		 * Every function accessing the shared structures is paired by Forbid()
		 * and Permit() to have exclusive access.
		 * Another task only gets access to the shared structures, if the current
		 * holder of the semaphore releases it (the nest count is equal zero).
		 */
	ULONG tc_ProcessId;			/* the Id of the process, this task depends to */
	ULONG tc_ThreadId;			/* the Id of the thread, this task depends to */
	HANDLE tc_ThreadHandle;		/* the handle of the attached thread */
	APTR tc_StartArgs;			/* arguments passed from AddTask() */
};

/* Stack swap structure as passed to StackSwap()
 */
struct	StackSwapStruct
{
	APTR	stk_Lower;		/* Lowest byte of stack */
	ULONG	stk_Upper;		/* Upper end of stack (size + Lowest) */
	APTR	stk_Pointer;	/* Stack pointer at switch point */
};

#endif		/* _AMIGA */

#endif		/* _TASKS_H_ */
