;
; ** $VER: startup.h 36.3 (11.7.90)
; ** Includes Release 40.15
; **
; ** workbench startup definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/ports.pb"

Structure WBStartup
    sm_Message.Message ;  a standard message structure
    *sm_Process.MsgPort ;  the process descriptor for you
    sm_Segment.l ;  a descriptor for your code
    sm_NumArgs.l ;  the number of elements in ArgList
    *sm_ToolWindow.b ;  description of window
    *sm_ArgList.WBArg ;  the arguments themselves
EndStructure

Structure WBArg
    *wa_Lock.l ;  a lock descriptor
    *wa_Name.b ;  a string relative to that lock
EndStructure

