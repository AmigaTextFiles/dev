;
; ** $VER: input.h 38.2 (28.6.91)
; ** Includes Release 40.15
; **
; ** File format for input preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "devices/timer.pb"


; ***************************************************************************


#ID_INPT = $494E5054


Structure InputPrefs

    ip_Keymap.b[16]
    ip_PointerTicks.w
    ip_DoubleClick.timeval
    ip_KeyRptDelay.timeval
    ip_KeyRptSpeed.timeval
    ip_MouseAccel.w
EndStructure


; ***************************************************************************


