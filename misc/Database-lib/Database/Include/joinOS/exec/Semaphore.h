/* Semaphore.h
 *
 *	Exec's SignalSemaphore structure and functions.
 */

#ifndef _SEMAPHORE_H_
#define _SEMAPHORE_H_

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA

#include <exec/semaphores.h>

#else

#ifndef _TASKS_H_
#include <joinOS/exec/Tasks.h>
#endif

#ifndef _LISTS_H_
#include <joinOS/exec/Lists.h>
#endif

/* --- Structure for waitqueue of semaphore --------------------------------- */

/* For every task waiting for a semaphore, a node of this type is added to the
 * queue ss_WaitQueue of the semaphore.
 */

struct SemaphoreRequest
{
	struct Node sr_Link;
	struct Task *sr_Task;
};

/* --- SignalSemaphore structure -------------------------------------------- */

/* The following structure is used to handle semaphores in an AmigaOS compatible
 * manner.
 * Use the new CreateSignalSemaphore() and DeleteSignalSemaphore() functions to
 *	create/delete semaphores.
 * See "Autodocs:CreateSignalSemaphore" for details how to create a semaphore
 * in a system independent manner without using CreateSignalSemaphore().
 */

struct SignalSemaphore
{
	struct Node ss_Link;		/* node structure, must be used for named semaphores
									 * or for semaphore lists for ObtainSemaphoreList()*/
	SHORT ss_NestCount;		/* number of shared locks on this semaphore */
	struct MinList ss_WaitQueue;	/* the list header for the list of other tasks
											 * waiting for this semaphore */
	struct SemaphoreRequest ss_MultipleLink;	/* used for shared access */
	struct Task *ss_Owner;	/* the task currently owning the semaphore */
	SHORT ss_QueueCount;		/* number of other tasks waiting for the semaphore */
};

#endif		/* _AMIGA */

#endif		/* _SEMAPHORE_H_ */
