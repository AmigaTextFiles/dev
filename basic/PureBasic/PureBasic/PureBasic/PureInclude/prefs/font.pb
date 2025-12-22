;
; ** $VER: font.h 38.2 (27.9.91)
; ** Includes Release 40.15
; **
; ** File format for font preferences
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "graphics/text.pb"

; ***************************************************************************

#ID_FONT = $464F4E54 ; "FONT"

#FONTNAMESIZE = 128

Structure FontPrefs

    fp_Reserved.l[3]
    fp_Reserved2.w
    fp_Type.w
    fp_FrontPen.b
    fp_BackPen.b
    fp_DrawMode.b
    fp_TextAttr.TextAttr
    fp_Name.b[#FONTNAMESIZE]
EndStructure


;  constants for FontPrefs.fp_Type
#FP_WBFONT     = 0
#FP_SYSFONT    = 1
#FP_SCREENFONT = 2


; ***************************************************************************


