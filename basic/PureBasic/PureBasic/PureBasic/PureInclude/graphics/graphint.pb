;
; ** $VER: graphint.h 39.0 (23.9.91)
; ** Includes Release 40.15
; **
; **
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"

;  structure used by AddTOFTask
Structure Isrvstr
    is_Node.Node
    *Iptr.Isrvstr   ;  passed to srvr by os
    *code.w
    *ccode.w
    Carg.w
EndStructure

