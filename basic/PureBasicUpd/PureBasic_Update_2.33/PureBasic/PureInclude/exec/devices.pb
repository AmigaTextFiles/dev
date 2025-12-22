;
; ** $VER: devices.h 39.0 (15.10.91)
; ** Includes Release 40.15
; **
; ** Include file for use by Exec device drivers
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/ports.pb"

; ***** Device *****************************************************

Structure Device
    dd_Library.Library
EndStructure


; ***** Unit *******************************************************

Structure Unit
    unit_MsgPort.MsgPort ;  queue for unprocessed messages
     ;  instance of msgport is recommended
    unit_flags.b
    unit_pad.b
    unit_OpenCnt.w  ;  number of active opens
EndStructure


#UNITF_ACTIVE = (1 << 0)
#UNITF_INTASK = (1 << 1)

