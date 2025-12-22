/* $VER: semaphores.h 39.1 (7.2.1992) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/exec/ports', 'target/exec/tasks'
{#include <exec/semaphores.h>}
NATIVE {EXEC_SEMAPHORES_H} CONST

CONST SM_LOCKMSG=16

/****** SignalSemaphore *********************************************/

/* Private structure used by ObtainSemaphore() */
NATIVE {SemaphoreRequest} OBJECT ssr
	{sr_Link}	mln	:mln
	{sr_Waiter}	waiter	:PTR TO tc
ENDOBJECT

/* Signal Semaphore data structure */
NATIVE {SignalSemaphore} OBJECT ss
	{ss_Link}	ln	:ln
	{ss_NestCount}	nestcount	:INT
	{ss_WaitQueue}	waitqueue	:mlh
	{ss_MultipleLink}	multiplelink	:ssr
	{ss_Owner}	owner	:PTR TO tc
	{ss_QueueCount}	queuecount	:INT
ENDOBJECT

/****** Semaphore procure message (for use in V39 Procure/Vacate) ****/
NATIVE {SemaphoreMessage} OBJECT semaphoremessage
	{ssm_Message}	mn	:mn
	{ssm_Semaphore}	semaphore	:PTR TO ss
ENDOBJECT

NATIVE {SM_SHARED}	CONST SM_SHARED	= 1
NATIVE {SM_EXCLUSIVE}	CONST SM_EXCLUSIVE	= 0

/****** Semaphore (Old Procure/Vacate type, not reliable) ***********/

NATIVE {Semaphore} OBJECT sm
	{sm_MsgPort}	mp	:mp
	{sm_Bids}	bids	:INT
ENDOBJECT

NATIVE {sm_LockMsg} DEF
