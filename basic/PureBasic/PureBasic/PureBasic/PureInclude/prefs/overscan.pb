;
; ** $VER: overscan.h 38.4 (22.10.92)
; ** Includes Release 40.15
; **
; ** File format for overscan preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "graphics/gfx.pb"


; ***************************************************************************


#ID_OSCN = $4F53434E

#OSCAN_MAGIC = $FEDCBA89


Structure OverscanPrefs

    os_Reserved.l
    os_Magic.l
    os_HStart.w
    os_HStop.w
    os_VStart.w
    os_VStop.w
    os_DisplayID.l
    os_ViewPos.Point
    os_Text.Point
    os_Standard.Rectangle
EndStructure

;  os_HStart, os_HStop, os_VStart, os_VStop can only be looked at if
;  * os_Magic equals OSCAN_MAGIC. If os_Magic is set to any other value,
;  * these four fields are undefined
;


; ***************************************************************************


