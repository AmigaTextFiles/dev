MODULE	'exec/nodes',
			'exec/ports',
			'exec/tasks'

OBJECT SemaphoreRequest|SSR
	Link|MLN:MLN,
	Waiter:PTR TO TC

OBJECT SignalSemaphore|SS
	Link|LN:LN,
	NestCount:WORD,
	WaitQueue:MLH,
	MultipleLink:SSR,
	Owner:PTR TO TC,
	QueueCount:WORD

OBJECT SemaphoreMessage
	Message|MN:MN,
	Semaphore:PTR TO SS

OBJECT Semaphore|SM
	MsgPort|MP:MP,
	Bids:WORD

CONST	SM_LOCKMSG=16,
		SM_SHARED=1,
		SM_EXCLUSIVE=0

#define sm_LockMsg mp_SigTask
