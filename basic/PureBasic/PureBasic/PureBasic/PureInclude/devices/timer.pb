#DEVICES_TIMER_H = 1
;
; ** $VER: timer.h 36.16 (25.1.91)
; ** Includes Release 40.15
; **
; ** Timer device name and useful definitions.
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga Inc.
; **  All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/io.pb"

;  unit defintions
#UNIT_MICROHZ = 0
#UNIT_VBLANK = 1
#UNIT_ECLOCK = 2
#UNIT_WAITUNTIL = 3
#UNIT_WAITECLOCK = 4

;#TIMERNAME = "timer\device"

Structure timeval
    tv_secs.l
    tv_micro.l
EndStructure

Structure EClockVal
    ev_hi.l
    ev_lo.l
EndStructure

Structure timerequest
    tr_node.IORequest
    tr_time.timeval
EndStructure

;  IO_COMMAND to use for adding a timer
#TR_ADDREQUEST = #CMD_NONSTD
#TR_GETSYSTIME = (#CMD_NONSTD+1)
#TR_SETSYSTIME = (#CMD_NONSTD+2)

