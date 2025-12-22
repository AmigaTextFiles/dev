/* $Id: semaphores.h,v 1.13 2005/11/10 15:33:07 hjfrieden Exp $ */
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

NATIVE {enSemaphoreRequestType} DEF
NATIVE {SM_SHARED}    CONST SM_SHARED    = 1
NATIVE {SM_EXCLUSIVE} CONST SM_EXCLUSIVE = 0


/****** Semaphore (Old Procure/Vacate type, not reliable) ***********/
/* Do not use these semaphores! */
/* Then why have them hanging around ? Using them will generate an exception 
struct Semaphore        
{ 
    struct MsgPort sm_MsgPort;
    WORD           sm_Bids;
};
*/

NATIVE {sm_LockMsg} DEF
