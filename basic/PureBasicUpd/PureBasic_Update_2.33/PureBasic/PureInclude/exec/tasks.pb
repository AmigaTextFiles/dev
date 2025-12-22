;
; ** $VER: tasks.h 39.3 (18.9.92)
; ** Includes Release 40.15
; **
; ** Task Control Block, Singals, and Task flags.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"

;  Please use Exec functions to modify task structure fields, where available.
;
Structure Task
    tc_Node.Node
    tc_Flags.b
    tc_State.b
    tc_IDNestCnt.b     ;  intr disabled nesting
    tc_TDNestCnt.b     ;  task disabled nesting
    tc_SigAlloc.l     ;  sigs allocated
    tc_SigWait.l     ;  sigs we are waiting for
    tc_SigRecvd.l     ;  sigs we have received
    tc_SigExcept.l     ;  sigs we will take excepts for
    tc_TrapAlloc.w     ;  traps allocated
    tc_TrapAble.w     ;  traps enabled
    *tc_ExceptData.l     ;  points to except data
    *tc_ExceptCode.l     ;  points to except code
    *tc_TrapData.l     ;  points to trap data
    *tc_TrapCode.l     ;  points to trap code
    *tc_SPReg.l      ;  stack pointer
    *tc_SPLower.l     ;  stack lower bound
    *tc_SPUpper.l     ;  stack upper bound + 2
    *tc_Switch.l     ;  task losing CPU
    *tc_Launch.l    ;  task getting CPU
    tc_MemEntry.List     ;  Allocated memory. Freed by RemTask()
    *tc_UserData.l     ;  For use by the task; no restrictions!
EndStructure

;
;  * Stack swap structure as passed to StackSwap()
;
Structure StackSwapStruct
 *stk_Lower.l ;  Lowest byte of stack
 stk_Upper.l ;  Upper end of stack (size + Lowest)
 *stk_Pointer.l ;  Stack pointer at switch point
EndStructure

; ----- Flag Bits ------------------------------------------
#TB_PROCTIME = 0
#TB_ETASK = 3
#TB_STACKCHK = 4
#TB_EXCEPT = 5
#TB_SWITCH = 6
#TB_LAUNCH = 7

#TF_PROCTIME = (1 << 0)
#TF_ETASK = (1 << 3)
#TF_STACKCHK = (1 << 4)
#TF_EXCEPT = (1 << 5)
#TF_SWITCH = (1 << 6)
#TF_LAUNCH = (1 << 7)

; ----- Task States ----------------------------------------
#TS_INVALID = 0
#TS_ADDED = 1
#TS_RUN  = 2
#TS_READY = 3
#TS_WAIT = 4
#TS_EXCEPT = 5
#TS_REMOVED = 6

; ----- Predefined Signals -------------------------------------
#SIGB_ABORT = 0
#SIGB_CHILD = 1
#SIGB_BLIT = 4 ;  Note: same as SINGLE
#SIGB_SINGLE = 4 ;  Note: same as BLIT
#SIGB_INTUITION = 5
#SIGB_NET = 7
#SIGB_DOS = 8

#SIGF_ABORT = (1 << 0)
#SIGF_CHILD = (1 << 1)
#SIGF_BLIT = (1 << 4)
#SIGF_SINGLE = (1 << 4)
#SIGF_INTUITION = (1 << 5)
#SIGF_NET = (1 << 7)
#SIGF_DOS = (1 << 8)

