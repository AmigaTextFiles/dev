;
; ** $VER: palette.h 39.2 (15.6.92)
; ** Includes Release 40.15
; **
; ** File format for palette preferences
; **
; ** (C) Copyright 1992-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "intuition/intuition.pb"

; ***************************************************************************


#ID_PALT = $50414C54


Structure PalettePrefs
    pap_Reserved.l[4]      ;  System reserved
    pap_4ColorPens.w[32]     ;
    pap_8ColorPens.w[32]     ;
    pap_Colors.ColorSpec[32] ;  Used as full 16-bit RGB values
EndStructure


; ***************************************************************************


