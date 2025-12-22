;
; ** $VER: prtgfx.h 1.12 (26.7.90)
; ** Includes Release 40.15
; **
; ** printer.device structure definitions
; **
; ** (C) Copyright 1987-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

; 27/03/1999
;   Fixed a bit the union stuff (but not completely)
;   Changed Dest1Int -> DestOneInt
;           Dest2Int -> DestTwoInt
;

IncludePath   "PureInclude:"
XIncludeFile "graphics/rastport.pb"

#PCMYELLOW = 0  ;  byte index for yellow
#PCMMAGENTA = 1  ;  byte index for magenta
#PCMCYAN  = 2  ;  byte index for cyan
#PCMBLACK = 3  ;  byte index for black
#PCMBLUE  = #PCMYELLOW ;  byte index for blue
#PCMGREEN = #PCMMAGENTA ;  byte index for green
#PCMRED  = #PCMCYAN  ;  byte index for red
#PCMWHITE = #PCMBLACK ;  byte index for white

Structure colorEntry
  StructureUnion
    colorLong.l      ;  quick access to all of YMCB
    colorByte.b[4]   ;  1 entry for each of YMCB
    colorSByte.b[4]  ;  ditto (except signed)
  EndStructureUnion
EndStructure


Structure PrtInfo  ;  printer info
 *pi_render.l  ;  PRIVATE - DO NOT USE!
 *pi_rp.RastPort  ;  PRIVATE - DO NOT USE!
 *pi_temprp.RastPort ;  PRIVATE - DO NOT USE!
 *pi_RowBuf.w  ;  PRIVATE - DO NOT USE!
 *pi_HamBuf.w  ;  PRIVATE - DO NOT USE!
 *pi_ColorMap.colorEntry ;  PRIVATE - DO NOT USE!
 *pi_ColorInt.colorEntry ;  color intensities for entire row
 *pi_HamInt.colorEntry ;  PRIVATE - DO NOT USE!
 *pi_DestOneInt.colorEntry ;  PRIVATE - DO NOT USE!
 *pi_DestTwoInt.colorEntry ;  PRIVATE - DO NOT USE!
 *pi_ScaleX.w  ;  array of scale values for X
 *pi_ScaleXAlt.w  ;  PRIVATE - DO NOT USE!
 *pi_dmatrix.b  ;  pointer to dither matrix
 *pi_TopBuf.w  ;  PRIVATE - DO NOT USE!
 *pi_BotBuf.w  ;  PRIVATE - DO NOT USE!

 pi_RowBufSize.w  ;  PRIVATE - DO NOT USE!
 pi_HamBufSize.w  ;  PRIVATE - DO NOT USE!
 pi_ColorMapSize.w  ;  PRIVATE - DO NOT USE!
 pi_ColorIntSize.w  ;  PRIVATE - DO NOT USE!
 pi_HamIntSize.w  ;  PRIVATE - DO NOT USE!
 pi_Dest1IntSize.w  ;  PRIVATE - DO NOT USE!
 pi_Dest2IntSize.w  ;  PRIVATE - DO NOT USE!
 pi_ScaleXSize.w  ;  PRIVATE - DO NOT USE!
 pi_ScaleXAltSize.w  ;  PRIVATE - DO NOT USE!

 pi_PrefsFlags.w  ;  PRIVATE - DO NOT USE!
 pi_special.l  ;  PRIVATE - DO NOT USE!
 pi_xstart.w  ;  PRIVATE - DO NOT USE!
 pi_ystart.w  ;  PRIVATE - DO NOT USE!
 pi_width.w   ;  source width (in pixels)
 pi_height.w  ;  PRIVATE - DO NOT USE!
 pi_pc.l   ;  PRIVATE - DO NOT USE!
 pi_pr.l   ;  PRIVATE - DO NOT USE!
 pi_ymult.w   ;  PRIVATE - DO NOT USE!
 pi_ymod.w   ;  PRIVATE - DO NOT USE!
 pi_ety.w   ;  PRIVATE - DO NOT USE!
 pi_xpos.w   ;  offset to start printing picture
 pi_threshold.w  ;  threshold value (from prefs)
 pi_tempwidth.w  ;  PRIVATE - DO NOT USE!
 pi_flags.w   ;  PRIVATE - DO NOT USE!
EndStructure

