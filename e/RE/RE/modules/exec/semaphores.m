#ifndef	EXEC_SEMAPHORES_H
#define	EXEC_SEMAPHORES_H

#ifndef EXEC_NODES_H
MODULE  'exec/nodes'
#endif 
#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif 
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif 
#ifndef EXEC_TASKS_H
MODULE  'exec/tasks'
#endif 


OBJECT SemaphoreRequest

		Link:MinNode
		Waiter:PTR TO Task
ENDOBJECT


OBJECT SignalSemaphore

				Link:Node
	NestCount:WORD
				WaitQueue:MinList
		MultipleLink:SemaphoreRequest
				Owner:PTR TO Task
	QueueCount:WORD
ENDOBJECT


OBJECT SemaphoreMessage

			Message:Message
		Semaphore:PTR TO SignalSemaphore
ENDOBJECT

#define	SM_SHARED	(1)
#define	SM_EXCLUSIVE	(0)

OBJECT Semaphore
	
		MsgPort:MsgPort
	Bids:WORD
ENDOBJECT

#define sm_LockMsg	mp_SigTask
#endif	
