;
; ** $VER: screenmode.h 38.4 (25.6.92)
; ** Includes Release 40.15
; **
; ** File format for screen mode preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


#ID_SCRM = $5343524E


Structure ScreenModePrefs

    smp_Reserved.l[4]
    smp_DisplayID.l
    smp_Width.w
    smp_Height.w
    smp_Depth.w
    smp_Control.w
EndStructure

;  flags for ScreenModePrefs.smp_Control
#SMB_AUTOSCROLL = 1

#SMF_AUTOSCROLL = (1 << 0)

; ***************************************************************************


