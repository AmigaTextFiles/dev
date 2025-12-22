;
; ** $VER: nodes.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Nodes & Node type identifiers.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"

;
;  *  List Node Structure.  Each member in a list starts with a Node
;

Structure Node
    *ln_Succ.Node ;  Pointer to next (successor)
    *ln_Pred.Node ;  Pointer to previous (predecessor)
    ln_Type.b
    ln_Pri.b      ;  Priority, for sorting
    *ln_Name.b    ;  ID string, null terminated
EndStructure ;  Note: word aligned

;  minimal node -- no type checking possible
Structure MinNode
    *mln_Succ.MinNode
    *mln_Pred.MinNode
EndStructure


;
; ** Note: Newly initialized IORequests, and software interrupt structures
; ** used with Cause(), should have type NT_UNKNOWN.  The OS will assign a type
; ** when they are first used.
;
; ----- Node Types for LN_TYPE -----
#NT_UNKNOWN = 0
#NT_TASK  = 1 ;  Exec task
#NT_INTERRUPT = 2
#NT_DEVICE = 3
#NT_MSGPORT = 4
#NT_MESSAGE = 5 ;  Indicates message currently pending
#NT_FREEMSG = 6
#NT_REPLYMSG = 7 ;  Message has been replied
#NT_RESOURCE = 8
#NT_LIBRARY = 9
#NT_MEMORY = 10
#NT_SOFTINT = 11 ;  Internal flag used by SoftInits
#NT_FONT  = 12
#NT_PROCESS = 13 ;  AmigaDOS Process
#NT_SEMAPHORE = 14
#NT_SIGNALSEM = 15 ;  signal semaphores
#NT_BOOTNODE = 16
#NT_KICKMEM = 17
#NT_GRAPHICS = 18
#NT_DEATHMESSAGE = 19

#NT_USER  = 254 ;  User node types work down from here
#NT_EXTENDED = 255

