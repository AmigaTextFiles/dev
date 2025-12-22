;
; ** $VER: interrupts.h 39.1 (18.9.92)
; ** Includes Release 40.15
; **
; ** Callback structures used by hardware & software interrupts
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"


Structure Interrupt
    is_Node.Node
    is_Data.l      ;  server data segment
    *is_Code.l     ;  server code entry - Pointer to the begin ASM segment
EndStructure


Structure IntVector   ;  For EXEC use ONLY!
    *iv_Data.l
    *iv_Code.l
    *iv_Node.Node
EndStructure


Structure SoftIntList   ;  For EXEC use ONLY!
    sh_List.List
    sh_Pad.w
EndStructure

#SIH_PRIMASK = ($f0)

;  this is a fake INT definition, used only for AddIntServer and the like
#INTB_NMI = 15
#INTF_NMI = (1 << 15)

