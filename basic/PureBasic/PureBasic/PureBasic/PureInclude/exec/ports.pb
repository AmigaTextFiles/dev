;
; ** $VER: ports.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Message ports and Messages.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/tasks.pb"


; ***** MsgPort ****************************************************

Structure MsgPort
    mp_Node.Node
    mp_Flags.b
    mp_SigBit.b  ;  signal bit number
    *mp_SigTask.l  ;  object to be signalled
    mp_MsgList.List ;  message linked list
EndStructure

; #mp_SoftInt = mp_SigTask ;  Alias

;  mp_Flags: Port arrival actions (PutMsg)
#PF_ACTION = 3 ;  Mask
#PA_SIGNAL = 0 ;  Signal task in mp_SigTask
#PA_SOFTINT = 1 ;  Signal SoftInt in mp_SoftInt/mp_SigTask
#PA_IGNORE = 2 ;  Ignore arrival


; ***** Message ****************************************************

Structure Message
    mn_Node.Node
    *mn_ReplyPort.MsgPort  ;  message reply port
    mn_Length.w      ;  total message length, in bytes
        ;  (include the size of the Message
        ;  structure in the length)
EndStructure

