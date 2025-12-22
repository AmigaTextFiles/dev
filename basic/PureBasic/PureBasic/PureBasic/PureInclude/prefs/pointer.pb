;
; ** $VER: pointer.h 39.2 (9.6.92)
; ** Includes Release 40.15
; **
; ** File format for pointer preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************

; ***************************************************************************

#ID_PNTR = $504E5452

; ***************************************************************************

Structure PointerPrefs

    pp_Reserved.l[4]
    pp_Which.w       ;  0=NORMAL, 1=BUSY
    pp_Size.w        ;  see <intuition/pointerclass.h>
    pp_Width.w       ;  Width in pixels
    pp_Height.w      ;  Height in pixels
    pp_Depth.w       ;  Depth
    pp_YSize.w       ;  YSize
    pp_X.w
    pp_Y.w  ;  Hotspot

    ;  Color Table:  numEntries = (1 << pp_Depth) - 1

    ;  Data follows
EndStructure

; ***************************************************************************

;  constants for PointerPrefs.pp_Which
#WBP_NORMAL = 0
#WBP_BUSY = 1

; ***************************************************************************

Structure RGBTable

    t_Red.b
    t_Green.b
    t_Blue.b
EndStructure

; ***************************************************************************

