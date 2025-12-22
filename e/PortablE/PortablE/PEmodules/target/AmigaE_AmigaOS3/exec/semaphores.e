/* $VER: semaphores.h 39.1 (7.2.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports', 'target/exec/tasks'
{MODULE 'exec/semaphores'}

NATIVE {SM_LOCKMSG} CONST
->CONST SM_LOCKMSG=16

/****** SignalSemaphore *********************************************/

/* Private structure used by ObtainSemaphore() */
NATIVE {ssr} OBJECT ssr
	{mln}	mln	:mln
	{waiter}	waiter	:PTR TO tc
ENDOBJECT

/* Signal Semaphore data structure */
NATIVE {ss} OBJECT ss
	{ln}	ln	:ln
	{nestcount}	nestcount	:INT
	{waitqueue}	waitqueue	:mlh
	{multiplelink}	multiplelink	:ssr
	{owner}	owner	:PTR TO tc
	{queuecount}	queuecount	:INT
ENDOBJECT

/****** Semaphore procure message (for use in V39 Procure/Vacate) ****/
NATIVE {semaphoremessage} OBJECT semaphoremessage
	{mn}	mn	:mn
	{semaphore}	semaphore	:PTR TO ss
ENDOBJECT

NATIVE {SM_SHARED}	CONST SM_SHARED	= 1
NATIVE {SM_EXCLUSIVE}	CONST SM_EXCLUSIVE	= 0

/****** Semaphore (Old Procure/Vacate type, not reliable) ***********/

NATIVE {sm} OBJECT sm
	{mp}	mp	:mp
	{bids}	bids	:INT
ENDOBJECT
