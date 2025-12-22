;
; ** $VER: semaphores.h 39.1 (7.2.92)
; ** Includes Release 40.15
; **
; ** Definitions for locking functions.
; **
; ** (C) Copyright 1986-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/tasks.pb"


; ***** SignalSemaphore ********************************************

;  Private structure used by ObtainSemaphore()
Structure SemaphoreRequest

sr_Link.MinNode
*sr_Waiter.Task
EndStructure

;  Signal Semaphore data structure
Structure SignalSemaphore

ss_Link.Node
 ss_NestCount.w
ss_WaitQueue.MinList
ss_MultipleLink.SemaphoreRequest
*ss_Owner.Task
 ss_QueueCount.w
EndStructure

; ***** Semaphore procure message (for use in V39 Procure/Vacate ***
Structure SemaphoreMessage

ssm_Message.Message
*ssm_Semaphore.SignalSemaphore
EndStructure

#SM_SHARED = (1)
#SM_EXCLUSIVE = (0)

; ***** Semaphore (Old Procure/Vacate type, not reliable) **********

Structure Semaphore ;  Do not use these semaphores!

sm_MsgPort.MsgPort
 sm_Bids.w
EndStructure

;#sm_LockMsg = mp_SigTask


