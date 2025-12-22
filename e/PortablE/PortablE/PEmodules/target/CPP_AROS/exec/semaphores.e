/* $Id: semaphores.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/nodes', 'target/exec/ports', 'target/exec/tasks'
{#include <exec/semaphores.h>}
NATIVE {EXEC_SEMAPHORES_H} CONST

CONST SM_LOCKMSG=16

                           /* Signal Semaphores */

/* Private structure for use in ObtainSemaphore */
NATIVE {SemaphoreRequest} OBJECT ssr
    {sr_Link}	mln	:mln
    {sr_Waiter}	waiter	:PTR TO tc
ENDOBJECT

NATIVE {SignalSemaphore} OBJECT ss
    {ss_Link}	ln	:ln
    {ss_NestCount}	nestcount	:INT
    {ss_WaitQueue}	waitqueue	:mlh
    {ss_MultipleLink}	multiplelink	:ssr
    {ss_Owner}	owner	:PTR TO tc
    {ss_QueueCount}	queuecount	:INT
ENDOBJECT

/* For use in Procure()/Vacate() */
NATIVE {SemaphoreMessage} OBJECT semaphoremessage
    {ssm_Message}	mn	:mn
    {ssm_Semaphore}	semaphore	:PTR TO ss
ENDOBJECT

NATIVE {SM_EXCLUSIVE} CONST SM_EXCLUSIVE = (0)
NATIVE {SM_SHARED}    CONST SM_SHARED    = (1)
